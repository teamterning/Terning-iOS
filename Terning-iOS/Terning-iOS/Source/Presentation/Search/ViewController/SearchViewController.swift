//
//  SearchViewController.swift
//  Terning-iOS
//
//  Created by 정민지 on 7/13/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

@frozen
enum RecomandType: Int, CaseIterable {
    case advertisement = 0
    case viewsNum = 1
    case scrapsNum = 2
}

final class SearchViewController: UIViewController {
    
    // MARK: - Properties
    private let searchButtonTappedSubject = PublishSubject<Void>()
    private let pageControlTappedSubject = PublishSubject<Int>()
    
    private var timer: Timer?
    private let viewModel: SearchViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Components
    
    let searchView = SearchView()
    
    // MARK: - Init
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view?.backgroundColor = .white
        
        setUI()
        setLayout()
        setDelegate()
        setAddTarget()
        bindViewModel()
        
        startTimer()
    }
}

// MARK: - UI & Layout

extension SearchViewController {
    private func setUI() {
        view.addSubview(searchView)
    }
    private func setLayout() {
        searchView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - Methods

extension SearchViewController {
    private func setDelegate() {
        searchView.collectionView.dataSource = self
        searchView.collectionView.delegate = self
    }
    
    private func setAddTarget() {
        searchView.searchView.textField.isUserInteractionEnabled = false
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleSearchViewTap))
        searchView.searchView.addGestureRecognizer(tapGestureRecognizer)
        searchView.pageControl.isUserInteractionEnabled = false
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(autoScroll), userInfo: nil, repeats: true)
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func pushToSearchResultView() {
        let searchResultVC = SearchResultViewController(
            viewModel: SearchResultViewModel(
                scrapRepository: JobDetailRepository(
                    scrapService: ScrapsService(
                        provider: Providers.scrapsProvider
                    )
                )
            )
        )
        
        searchResultVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(searchResultVC, animated: true)
    }
}

// MARK: - @objc func

extension SearchViewController {
    @objc
    private func handleSearchViewTap() {
        searchButtonTappedSubject.onNext(())
    }
    
    @objc
    private func autoScroll() {
        let currentPage = searchView.pageControl.currentPage
        let nextPage = (currentPage + 1) % (searchView.advertisement?.advertisements?.count ?? 1)
        let indexPath = IndexPath(item: nextPage, section: RecomandType.advertisement.rawValue)
        searchView.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        searchView.pageControl.currentPage = nextPage
    }
}

// MARK: - Bind

extension SearchViewController {
    private func bindViewModel() {
        let input = SearchViewModel.Input(
            viewDidLoad: Observable.just(()),
            searchButtonTapped: searchButtonTappedSubject.asObservable(),
            pageControlTapped: pageControlTappedSubject.asObservable()
        )
        
        let output = viewModel.transform(input: input, disposeBag: disposeBag)
        
        output.announcements
            .drive(onNext: { [weak self] advertisements in
                self?.searchView.advertisement = advertisements
                self?.searchView.collectionView.reloadData()
                self?.searchView.pageControl.numberOfPages = advertisements.advertisements?.count ?? 0
            })
            .disposed(by: disposeBag)
        
        output.recommendedByViews
            .drive(onNext: { [weak self] viewsNum in
                self?.searchView.viewsNum = viewsNum
                self?.searchView.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        output.recommendedByScraps
            .drive(onNext: { [weak self] scrapsNum in
                self?.searchView.scrapsNum = scrapsNum
                self?.searchView.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        output.searchTapped
            .drive(onNext: { [weak self] in
                self?.pushToSearchResultView()
            })
            .disposed(by: disposeBag)
        
        output.pageChanged
            .drive(onNext: { [weak self] page in
                guard let self = self else { return }
                let indexPath = IndexPath(item: page, section: RecomandType.advertisement.rawValue)
                self.searchView.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                self.searchView.pageControl.currentPage = page
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - UICollectionViewDataSource

extension SearchViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return RecomandType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch RecomandType(rawValue: section) {
        case .advertisement:
            return searchView.advertisement?.advertisements?.count ?? 0
        case .viewsNum:
            return searchView.viewsNum?.count ?? 0
        case .scrapsNum:
            return searchView.scrapsNum?.count ?? 0
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch RecomandType(rawValue: indexPath.section) {
        case .advertisement:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdvertisementCollectionViewCell.className, for: indexPath) as? AdvertisementCollectionViewCell,
                  let advertisements = searchView.advertisement?.advertisements else {
                return UICollectionViewCell()
            }
            cell.bind(with: advertisements[indexPath.row])
            return cell
        case .viewsNum:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendCollectionViewCell.className, for: indexPath) as? RecommendCollectionViewCell,
                  let viewsNum = searchView.viewsNum else {
                return UICollectionViewCell()
            }
            cell.bind(with: viewsNum[indexPath.row])
            return cell
        case .scrapsNum:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendCollectionViewCell.className, for: indexPath) as? RecommendCollectionViewCell,
                  let scrapsNum = searchView.scrapsNum else {
                return UICollectionViewCell()
            }
            cell.bind(with: scrapsNum[indexPath.row])
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

// MARK: - UICollectionViewDelegate

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let sectionType = RecomandType(rawValue: indexPath.section),
              let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SearchCollectionViewHeaderCell.className, for: indexPath) as? SearchCollectionViewHeaderCell else {
            return UICollectionReusableView()
        }
        
        switch sectionType {
        case .advertisement:
            break
        case .viewsNum:
            headerView.bind(
                title: "요즘 대학생들에게 인기 있는 공고",
                subTitle: "이번 주 가장 많이 조회한 공고에요",
                type: .main
            )
        case .scrapsNum:
            headerView.bind(
                title: nil,
                subTitle: "이번 주 가장 많이 스크랩 한 공고에요",
                type: .sub
            )
        }
        
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch RecomandType(rawValue: indexPath.section) {
        case .viewsNum:
            guard let viewsNum = searchView.viewsNum else { return }
            
            let selectedItem = viewsNum[indexPath.item].internshipAnnouncementId
            
            let jobDetailVC = JobDetailViewController(
                viewModel: JobDetailViewModel(
                    scrapRepository: JobDetailRepository(
                        scrapService: ScrapsService(
                            provider: Providers.scrapsProvider
                        )
                    )
                )
            )
            jobDetailVC.hidesBottomBarWhenPushed = true
            jobDetailVC.internshipAnnouncementId.accept(selectedItem)
            self.navigationController?.pushViewController(jobDetailVC, animated: true)
        case .scrapsNum:
            guard let scrapsNum = searchView.scrapsNum else { return }
            
            let selectedItem = scrapsNum[indexPath.item].internshipAnnouncementId
            
            let jobDetailVC = JobDetailViewController(
                viewModel: JobDetailViewModel(
                    scrapRepository: JobDetailRepository(
                        scrapService: ScrapsService(
                            provider: Providers.scrapsProvider
                        )
                    )
                )
            )
            jobDetailVC.hidesBottomBarWhenPushed = true
            jobDetailVC.internshipAnnouncementId.accept(selectedItem)
            self.navigationController?.pushViewController(jobDetailVC, animated: true)
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard let sectionType = RecomandType(rawValue: indexPath.section) else { return }
        
        if sectionType == .advertisement {
            searchView.pageControl.currentPage = indexPath.item
        }
        
    }
}
