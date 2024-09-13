//  SearchResultViewController.swift
//  Terning-iOS
//
//  Created by 정민지 on 7/17/24.
//

import UIKit

import RxSwift

import SnapKit

@frozen
enum SearchResultType: Int, CaseIterable {
    case graphic = 0
    case search = 1
    case noSearch = 2
}

final class SearchResultViewController: UIViewController {
    
    // MARK: - Properties
    
    private var searchResultCount: Int = 0
    private var searchHasNext = true
    private var isFetchingMoreData = false
    private let sortButtonTapObservable = PublishSubject<Void>()
    
    private let sortBySubject = BehaviorSubject<String>(value: "deadlineSoon")
    private let pageSubject = BehaviorSubject<Int>(value: 0)
    private var textFieldKeyword: String?
    
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
        view.backgroundColor = .white
        
        setUI()
        setHierarchy()
        setLayout()
        setDelegate()
        bindViewModel()
    }
}

// MARK: - UI & Layout

extension SearchResultViewController {
    private func setUI() {
        navigationController?.isNavigationBarHidden = true
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
            .do(onNext: { _ in
                self.pageSubject.onNext(0)
            })
        
        let sortChanged = sortBySubject
            .withLatestFrom(keyword)
            .filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
            .map { _ in () }
            .do(onNext: { _ in
                self.pageSubject.onNext(0)
            })
        
        let pageChanged = pageSubject
            .filter { $0 > 0 }
            .do(onNext: { page in
                print("Page changed: \(page)")
            })
        
        let searchTrigger = Observable.merge(searchChanged, sortChanged, pageChanged.map { _ in () })
            .withLatestFrom(keyword)
            .do(onNext: { _ in
                if firstSearch {
                    firstSearch = false
                    self.rootView.searchTitleLabel.isHidden = true
                    self.rootView.updateLayout()
                    self.isFetchingMoreData = false
                }
            })
        
        let input = SearchResultViewModel.Input(
            keyword: searchTrigger,
            sortTap: sortButtonTapObservable.asObservable(),
            sortBy: sortBySubject.asObservable(),
            page: pageSubject.asObservable(),
            size: Observable.just(10),
            searchTrigger: searchTrigger.map { _ in () }
        )
        
        let output = viewModel.transform(input: input, disposeBag: disposeBag)
        
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
                
                if let currentPage = try? self.pageSubject.value(), currentPage > 1 {
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
                self.isFetchingMoreData = false
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
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JobCardScrapedCell.className, for: indexPath) as? JobCardScrapedCell, let SearchResult = rootView.searchResult else {
                return UICollectionViewCell()
            }
            cell.bind(model: SearchResult[indexPath.item], indexPath: indexPath)
            cell.delegate2 = self
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
            
            let jobDetailVC = JobDetailViewController()
            jobDetailVC.internshipAnnouncementId.onNext(selectedItem)
            self.navigationController?.pushViewController(jobDetailVC, animated: true)
        default:
            break
        }
    }
}

extension SearchResultViewController: JobCardScrapedCellProtocol {
    func scrapButtonDidTap(index: Int) {
        guard let searchResults = rootView.searchResult, !searchResults.isEmpty else {
            print("검색 결과가 비어 있습니다. 요청을 실행하지 않습니다.")
            return
        }
        
        guard index >= 0 && index < searchResults.count else {
            print("잘못된 인덱스입니다.")
            return
        }
        
        print("index", index)
        
        let model = searchResults[index]
        print("model", model)
        
        if model.isScrapped == false {          
            let searchModel = SearchResult(
                internshipAnnouncementId: model.internshipAnnouncementId,
                companyImage: model.companyImage,
                dDay: model.dDay,
                title: model.title,
                workingPeriod: model.workingPeriod,
                isScrapped: true,
                color: model.color,
                deadline: model.deadline,
                startYearMonth: model.startYearMonth
            )
            
            let alertViewController = NewCustomAlertVC(alertViewType: .scrap)
            alertViewController.setSearchData(model: searchModel)
            
            alertViewController.modalTransitionStyle = .crossDissolve
            alertViewController.modalPresentationStyle = .overFullScreen
            
            alertViewController.centerButtonDidTapAction = { [weak self] in
                guard let self = self else { return }
                
                let colorName = alertViewController.selectedColorNameRelay
                
                self.scrapAnnouncementWithCompletion(
                    internshipAnnouncementId: model.internshipAnnouncementId,
                    color: colorName.value
                ) { success in
                    if success {
                        self.bindViewModel()
                        self.rootView.collectionView.reloadData()
                        self.showToast(message: "관심 공고가 캘린더에 스크랩되었어요!")
                    }
                    self.dismiss(animated: false)
                }
            }
            self.present(alertViewController, animated: false)
            
        } else {

            let alertViewController = NewCustomAlertVC(alertViewType: .scrap)
            
            alertViewController.centerButtonDidTapAction = {
                
                self.dismiss(animated: false)
                
                self.showToast(message: "관심 공고가 캘린더에서 사라졌어요!")
            }
            
            alertViewController.modalTransitionStyle = .crossDissolve
            alertViewController.modalPresentationStyle = .overFullScreen
            
            self.present(alertViewController, animated: false)
        }
        
    }
    
    private func scrapAnnouncementWithCompletion(internshipAnnouncementId: Int, color: String, completion: @escaping (Bool) -> Void) {
        self.scrapAnnouncement(internshipAnnouncementId: internshipAnnouncementId, color: color)
        completion(true)
    }
    
    private func parseStartDate(_ startDate: String) -> (year: Int?, month: Int?) {
        let dateComponents = startDate.components(separatedBy: "년 ")
        guard dateComponents.count == 2 else { return (nil, nil) }
        
        let yearString = dateComponents[0]
        let monthString = dateComponents[1].replacingOccurrences(of: "월", with: "")
        
        let year = Int(yearString.trimmingCharacters(in: .whitespaces))
        let month = Int(monthString.trimmingCharacters(in: .whitespaces))
        
        return (year, month)
    }
}

// MARK: - API

extension SearchResultViewController {
    private func patchScrapAnnouncement(internshipAnnouncementId: Int?, color: String, cell: JobCardScrapedCell) {
        guard let scrapId = internshipAnnouncementId else { return }
        Providers.scrapsProvider.request(.patchScrap(internshipAnnouncementId: scrapId, color: color)) { [weak self] result in
            LoadingIndicator.hideLoading()
            guard let self = self else { return }
            switch result {
            case .success(let response):
                let status = response.statusCode
                if 200..<300 ~= status {
                    print("스크랩 수정 성공")
                    self.bindViewModel()
                    self.rootView.collectionView.reloadData()
                } else {
                    print("400 error")
                    self.showToast(message: "네트워크 오류")
                }
            case .failure(let error):
                print(error.localizedDescription)
                self.showToast(message: "네트워크 오류")
            }
        }
    }
    
    private func cancelScrapAnnouncement(internshipAnnouncementId: Int?) {
        guard let scrapId = internshipAnnouncementId else { return }
        Providers.scrapsProvider.request(.removeScrap(internshipAnnouncementId: scrapId)) { [weak self] result in
            LoadingIndicator.hideLoading()
            guard let self = self else { return }
            switch result {
            case .success(let response):
                let status = response.statusCode
                if 200..<300 ~= status {
                    print("스크랩 취소 성공")
                    self.bindViewModel()
                    self.rootView.collectionView.reloadData()
                } else {
                    print("400 error")
                    self.showToast(message: "네트워크 오류")
                }
            case .failure(let error):
                print(error.localizedDescription)
                self.showToast(message: "네트워크 오류")
            }
        }
    }
}

// MARK: - SortSettingButtonProtocol

extension SearchResultViewController: SortSettingButtonProtocol {
    func didSelectSortingOption(_ option: SortingOptions) {
        sortBySubject.onNext(option.apiValue)
        
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

// MARK: - UIScrollViewDelegate

extension SearchResultViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        var isFetchingMoreData = false
        
        if offsetY >= contentHeight - height && searchHasNext && !isFetchingMoreData {
            isFetchingMoreData = true
            
            if let currentPage = try? pageSubject.value() {
                pageSubject.onNext(currentPage + 1)
            }
            
        }
    }
}
