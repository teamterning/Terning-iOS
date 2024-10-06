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
public enum RecomandType: Int, CaseIterable {
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
    
    let rootView = SearchView()
    
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
        view.backgroundColor = .white
        view.addSubview(rootView)
    }
    private func setLayout() {
        rootView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - Methods

extension SearchViewController {
    private func setDelegate() {
        rootView.collectionView.dataSource = self
        rootView.collectionView.delegate = self
    }
    
    private func setAddTarget() {
        rootView.searchView.textField.isUserInteractionEnabled = false
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleSearchViewTap))
        rootView.searchView.addGestureRecognizer(tapGestureRecognizer)
        rootView.pageControl.isUserInteractionEnabled = false
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
                jobDetailRepository: JobDetailRepository(
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
        let currentPage = rootView.pageControl.currentPage
        let nextPage = (currentPage + 1) % (rootView.advertisement?.advertisements?.count ?? 1)
        let indexPath = IndexPath(item: nextPage, section: RecomandType.advertisement.rawValue)
        rootView.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        rootView.pageControl.currentPage = nextPage
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
                self?.rootView.advertisement = advertisements
                self?.rootView.collectionView.reloadData()
                self?.rootView.pageControl.numberOfPages = advertisements.advertisements?.count ?? 0
            })
            .disposed(by: disposeBag)
        
        output.recommendedByViews
            .drive(onNext: { [weak self] viewsNum in
                self?.rootView.viewsNum = viewsNum
                self?.rootView.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        output.recommendedByScraps
            .drive(onNext: { [weak self] scrapsNum in
                self?.rootView.scrapsNum = scrapsNum
                self?.rootView.collectionView.reloadData()
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
                self.rootView.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                self.rootView.pageControl.currentPage = page
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
            return rootView.advertisement?.advertisements?.count ?? 0
        case .viewsNum:
            return rootView.viewsNum?.count ?? 0
        case .scrapsNum:
            return rootView.scrapsNum?.count ?? 0
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch RecomandType(rawValue: indexPath.section) {
        case .advertisement:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdvertisementCollectionViewCell.className, for: indexPath) as? AdvertisementCollectionViewCell,
                  let advertisements = rootView.advertisement?.advertisements else {
                return UICollectionViewCell()
            }
            cell.bind(with: advertisements[indexPath.row])
            return cell
        case .viewsNum:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendCollectionViewCell.className, for: indexPath) as? RecommendCollectionViewCell,
                  let viewsNum = rootView.viewsNum else {
                return UICollectionViewCell()
            }
            cell.bind(with: viewsNum[indexPath.row])
            return cell
        case .scrapsNum:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendCollectionViewCell.className, for: indexPath) as? RecommendCollectionViewCell,
                  let scrapsNum = rootView.scrapsNum else {
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
        case .advertisement: 
            let urlString = "https://www.instagram.com/terning_official?igsh=NnNma245bnUzbWNm&utm_source=qr"
            guard let url = URL(string: urlString) else { return }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        case .viewsNum:
            guard let viewsNum = rootView.viewsNum else { return }
            
            let selectedItem = viewsNum[indexPath.item].internshipAnnouncementId
            
            let jobDetailVC = JobDetailViewController(
                viewModel: JobDetailViewModel(
                    jobDetailRepository: JobDetailRepository(
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
            guard let scrapsNum = rootView.scrapsNum else { return }
            
            let selectedItem = scrapsNum[indexPath.item].internshipAnnouncementId
            
            let jobDetailVC = JobDetailViewController(
                viewModel: JobDetailViewModel(
                    jobDetailRepository: JobDetailRepository(
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
            rootView.pageControl.currentPage = indexPath.item
        }
        
    }
}
