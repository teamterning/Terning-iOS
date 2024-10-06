//  SearchResultViewController.swift
//  Terning-iOS
//
//  Created by 정민지 on 7/17/24.
//

import UIKit

import RxSwift
import RxRelay

import SnapKit

@frozen
public enum SearchResultType: Int, CaseIterable {
    case graphic = 0
    case search = 1
    case noSearch = 2
}

final class SearchResultViewController: UIViewController {
    
    // MARK: - Properties
    
    private var selectedIndex: Int?
    private var selectedIndexPath: IndexPath?
    
    private var searchResultCount: Int = 0
    private var searchHasNext = true
    private let sortButtonTapObservable = PublishSubject<Void>()
    
    private let sortByRelay = BehaviorRelay<String>(value: "deadlineSoon")
    private let pageRelay = BehaviorRelay<Int>(value: 0)
    private var textFieldKeyword: String?
    
    private let addScrapSubject = PublishSubject<(Int, String)>()
    private let cancelScrapSubject = PublishSubject<Int>()
    
    private let viewModel: SearchResultViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Components
    
    let rootView = SearchResultView()
    
    // MARK: - Init
    
    init(viewModel: SearchResultViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setHierarchy()
        setLayout()
        setDelegate()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !self.isMovingToParent {
            if let indexPath = selectedIndexPath {
                reloadCollectionViewItems(at: indexPath)
            }
        }
    }
}

// MARK: - UI & Layout

extension SearchResultViewController {
    private func setUI() {
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        rootView.searchView.textField.becomeFirstResponder()
    }
    
    private func setHierarchy() {
        view.addSubview(rootView)
    }
    
    private func setLayout() {
        rootView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
        }
    }
}

// MARK: - Bind

extension SearchResultViewController {
    private func bindViewModel() {
        var firstSearch = true
        
        let keyword = rootView.searchView.textField.rx.text.orEmpty.asObservable()
        
        let searchChanged = rootView.searchView.textField.rx.controlEvent(.editingDidEndOnExit)
            .withLatestFrom(keyword)
            .filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
            .map { _ in () }
            .do(onNext: { [weak self] _ in
                self?.pageRelay.accept(0)
            })
        
        let sortChanged = sortByRelay
            .withLatestFrom(keyword)
            .filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
            .map { _ in () }
            .do(onNext: { [weak self] _ in
                self?.pageRelay.accept(0)
            })
        
        let pageChanged = pageRelay
            .filter { $0 > 0 }
            .do(onNext: { page in
                print("❤️❤️❤️❤️❤️Page changed: \(page)")
            })
        
        let searchTrigger = Observable.merge(searchChanged, sortChanged, pageChanged.map { _ in () })
            .withLatestFrom(keyword)
            .do(onNext: { [weak self] _ in
                guard let self = self else { return }
                if firstSearch {
                    firstSearch = false
                    self.rootView.searchTitleLabel.isHidden = true
                    self.rootView.updateLayout()
                }
            })
        
        let input = SearchResultViewModel.Input(
            keyword: searchTrigger,
            sortTap: sortButtonTapObservable.asObservable(),
            sortBy: sortByRelay.asObservable(),
            page: pageRelay.asObservable(),
            size: Observable.just(10),
            searchTrigger: searchTrigger.map { _ in () },
            addScrapTrigger: addScrapSubject.asObservable(),
            cancelScrapTrigger: cancelScrapSubject.asObservable()
        )
        
        let output = viewModel.transform(input: input, disposeBag: disposeBag)
        
        rootView.collectionView.rx.prefetchItems
            .compactMap { $0.last?.item }
            .withUnretained(self)
            .bind { ss, row in
                guard row == 0 else { return }
                guard ss.searchHasNext else { return }
                ss.pageRelay.accept(ss.pageRelay.value + 1)
            }
            .disposed(by: disposeBag)
        
        output.showSortBottom
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                let contentVC = SortSettingViewController()
                contentVC.sortSettingDelegate = self
                presentCustomBottomSheet(contentVC)
            })
            .disposed(by: disposeBag)
        
        output.searchResults
            .drive(onNext: { [weak self] newSearchResults in
                guard let self = self else { return }
                if self.pageRelay.value >= 1 {
                    if let currentResults = self.rootView.searchResult {
                        self.rootView.searchResult = currentResults + newSearchResults
                    } else {
                        self.rootView.searchResult = newSearchResults
                    }
                } else {
                    self.rootView.collectionView.setContentOffset(.zero, animated: true)
                    self.rootView.searchResult = newSearchResults
                }
                self.rootView.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        output.keyword
            .drive(onNext: { [weak self] keyword in
                self?.textFieldKeyword = keyword
            })
            .disposed(by: disposeBag)
        
        output.totalCounts
            .drive(onNext: { [weak self] totalCounts in
                self?.searchResultCount = totalCounts
            })
            .disposed(by: disposeBag)
        
        output.hasNextPage
            .drive(onNext: { [weak self] hasNext in
                self?.searchHasNext = hasNext
            })
            .disposed(by: disposeBag)
        
        output.addScrapResult
            .drive(onNext: { [weak self] in
                guard let self = self, let index = self.selectedIndex else {
                    return
                }
                
                rootView.searchResult?[index].isScrapped = true
                rootView.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        output.cancelScrapResult
            .drive(onNext: { [weak self] in
                guard let self = self, let index = self.selectedIndex else {
                    return
                }
                
                rootView.searchResult?[index].isScrapped = false
                rootView.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        output.error
            .drive(onNext: { [weak self] errorMessage in
                guard let self = self else { return }
                
                self.showToast(message: errorMessage)
            })
            .disposed(by: disposeBag)
        
        output.successMessage
            .drive(onNext: { [weak self] successMessage in
                guard let self = self else { return }
                
                self.showToast(message: successMessage, heightOffset: 12)
                self.rootView.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Methods

extension SearchResultViewController {
    private func setDelegate() {
        rootView.collectionView.delegate = self
        rootView.collectionView.dataSource = self
        
        self.hideKeyboardWhenTappedAround()
        
        rootView.navigationBar.leftButtonAction = { [weak self] in
            guard let self = self else { return }
            self.popOrDismissViewController(animated: true)
        }
    }
    
    private func reloadCollectionViewItems(at indexPath: IndexPath) {
        let pageSize = 10
        let pageIndex = indexPath.item / pageSize
        let itemIndexInPage = indexPath.item % pageSize
        
        viewModel.fetchJobCards(keyword: textFieldKeyword ?? "", sortBy: sortByRelay.value, page: pageIndex, size: pageSize)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                
                let announcements = result.announcements
                
                if !announcements.isEmpty && itemIndexInPage < announcements.count {
                    let updatedResult = announcements[itemIndexInPage]
                    
                    if var currentResults = self.rootView.searchResult, indexPath.item < currentResults.count {
                        currentResults[indexPath.item] = updatedResult
                        self.rootView.searchResult = currentResults
                        self.rootView.collectionView.reloadItems(at: [indexPath])
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func addScrapAnnouncement(scrapId: Int, color: String) {
        addScrapSubject.onNext((scrapId, color))
    }
    
    private func cancelScrapAnnouncement(scrapId: Int?) {
        guard let scrapId = scrapId else { return }
        cancelScrapSubject.onNext(scrapId)
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension SearchResultViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return SearchResultType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch SearchResultType(rawValue: section) {
        case .graphic:
            return rootView.searchResult == nil ? 1 : 0
        case .search:
            return rootView.searchResult?.isEmpty == false ? (rootView.searchResult?.count ?? 0) : 0
        case .noSearch:
            return rootView.searchResult?.isEmpty == true ? 1 : 0
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch SearchResultType(rawValue: indexPath.section) {
        case .graphic:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GraphicCollectionViewCell.className, for: indexPath) as? GraphicCollectionViewCell else {
                return UICollectionViewCell()
            }
            return cell
            
        case .search:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JobCardCell.className, for: indexPath) as? JobCardCell, let SearchResult = rootView.searchResult else {
                return UICollectionViewCell()
            }
            cell.bind(model: SearchResult[indexPath.item], indexPath: indexPath)
            cell.delegate = self
            return cell
            
        case .noSearch:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InavailableFilterView.className, for: indexPath) as? InavailableFilterView, let title = self.textFieldKeyword else {
                return UICollectionViewCell()
            }
            cell.bind(title: title)
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
}

extension SearchResultViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let sectionType = SearchResultType(rawValue: indexPath.section),
              let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SortHeaderCell.className, for: indexPath) as? SortHeaderCell else {
            return UICollectionReusableView()
        }
        
        switch sectionType {
        case .graphic:
            break
        case .search:
            print("searchResultCount:", searchResultCount)
            headerView.bind(with: searchResultCount)
            
            headerView.sortButtonTapSubject
                .subscribe(onNext: { [weak self] in
                    self?.sortButtonTapObservable.onNext(())
                })
                .disposed(by: headerView.disposeBag)
        case .noSearch:
            headerView.bind(with: 0)
            
            headerView.sortButtonTapSubject
                .subscribe(onNext: { [weak self] in
                    self?.sortButtonTapObservable.onNext(())
                })
                .disposed(by: headerView.disposeBag)
        }
        return headerView
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch SearchResultType(rawValue: indexPath.section) {
        case .search:
            guard let SearchResult = rootView.searchResult else { return }
            let selectedItem = SearchResult[indexPath.item].internshipAnnouncementId
            
            selectedIndexPath = indexPath
            
            let jobDetailVC = JobDetailViewController(
                viewModel: JobDetailViewModel(
                    jobDetailRepository: JobDetailRepository(
                        scrapService: ScrapsService(
                            provider: Providers.scrapsProvider
                        )
                    )
                )
            )
            jobDetailVC.internshipAnnouncementId.accept(selectedItem)
            self.navigationController?.pushViewController(jobDetailVC, animated: true)
        default:
            break
        }
    }
}

extension SearchResultViewController: JobCardScrapedCellProtocol {
    func scrapButtonDidTap(index: Int) {
        guard let searchResults = rootView.searchResult, !searchResults.isEmpty else {
            return
        }
        
        guard index >= 0 && index < searchResults.count else {
            return
        }
        
        let model = searchResults[index]
        selectedIndex = index
        
        if model.isScrapped {
            let alertSheet = CustomAlertViewController(alertViewType: .info)
            
            alertSheet.modalTransitionStyle = .crossDissolve
            alertSheet.modalPresentationStyle = .overFullScreen
            
            alertSheet.centerButtonDidTapAction = { [weak self] in
                guard let self = self else { return }
                
                self.cancelScrapAnnouncement(scrapId: model.internshipAnnouncementId)
                self.dismiss(animated: false)
            }
            
            self.present(alertSheet, animated: false)
        } else {
            let alertSheet = CustomAlertViewController(alertViewType: .scrap)
            alertSheet.setAnnouncementData(model: model)
            
            alertSheet.modalTransitionStyle = .crossDissolve
            alertSheet.modalPresentationStyle = .overFullScreen
            
            alertSheet.centerButtonDidTapAction = { [weak self] in
                guard let self = self else { return }
                let selectedColorNameRelay = alertSheet.selectedColorNameRelay.value
                
                self.addScrapAnnouncement(scrapId: model.internshipAnnouncementId, color: selectedColorNameRelay)
                self.dismiss(animated: false)
            }
            
            self.present(alertSheet, animated: false)
        }
    }
}

// MARK: - SortSettingButtonProtocol

extension SearchResultViewController: SortSettingButtonProtocol {
    func didSelectSortingOption(_ option: SortingOptions) {
        sortByRelay.accept(option.apiValue)
        
        let visibleHeaders = rootView.collectionView.visibleSupplementaryViews(ofKind: UICollectionView.elementKindSectionHeader)
        
        if let sortHeader = visibleHeaders.first as? SortHeaderCell {
            sortHeader.setSortButtonTitle(option.title)
        }
    }
}

// MARK: - UIAdaptivePresentationControllerDelegate

extension SearchResultViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        removeModalBackgroundView()
    }
}
