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

final class SearchViewController: UIViewController {
    
    // MARK: - Properties
    
    private let searchButtonDidTapSubject = PublishSubject<Void>()
    
    private var timer: Timer?
    private let viewModel: SearchViewModel
    private let disposeBag = DisposeBag()
    
    private let screenWidth = UIScreen.main.bounds.width
    
    // MARK: - UI Components
    
    private let rootView = SearchView()
    
    // MARK: - Init
    
    init(viewModel: SearchViewModel) {
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
        setHierachy()
        setLayout()
        setRegister()
        setDelegate()
        setAddTarget()
        bindViewModel()
        setAdvertisements()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        startTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        stopTimer()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setInfinityCarousel()
    }
    
}

// MARK: - UI & Layout

extension SearchViewController {
    private func setUI() {
        view.backgroundColor = .white
    }
    
    private func setHierachy() {
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
        rootView.advertisementCollectionView.dataSource = self
        rootView.advertisementCollectionView.delegate = self
        
        rootView.recommendedCollectionView.dataSource = self
        rootView.recommendedCollectionView.delegate = self
    }
    
    private func setAddTarget() {
        rootView.searchBar.textField.isUserInteractionEnabled = false
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleSearchViewTap))
        rootView.searchBar.addGestureRecognizer(tapGestureRecognizer)
        rootView.pageControl.isUserInteractionEnabled = false
    }
    
    private func setRegister() {
        rootView.advertisementCollectionView.register(AdvertisementCollectionViewCell.self,
                                                      forCellWithReuseIdentifier: AdvertisementCollectionViewCell.className)
        rootView.recommendedCollectionView.register(RecommendCollectionViewCell.self,
                                                    forCellWithReuseIdentifier: RecommendCollectionViewCell.className)
        rootView.recommendedCollectionView.register(SearchCollectionViewHeaderCell.self,
                                                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                                    withReuseIdentifier: SearchCollectionViewHeaderCell.className)
    }
    
    private func startTimer() {
        if timer == nil { // 타이머가 없을때만 실행 (중복 타이머 문제 해결)
            timer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(autoScroll), userInfo: nil, repeats: true)
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func pushToSearchResultView() {
        track(eventName: .clickQuestSearch)
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
    
    private func setAdvertisements() {
        // 원래 광고 배열을 복사하여 처음과 끝에 추가 (infite carousel)
        if let firstAd = viewModel.advertisements.first, let lastAd = viewModel.advertisements.last {
            viewModel.advertisements.insert(lastAd, at: 0)
            viewModel.advertisements.append(firstAd)
        }
    }
    
    private func setInfinityCarousel() {
        rootView.advertisementCollectionView.setContentOffset(
            .init(x: screenWidth, y: rootView.advertisementCollectionView.contentOffset.y), animated: false)
    }
    
    private func pushToJobDetailVC(internshipId: Int) {
        let jobDetailVC = JobDetailViewController(
            viewModel: JobDetailViewModel(
                jobDetailRepository: JobDetailRepository(
                    scrapService: ScrapsService(provider: Providers.scrapsProvider)
                )
            )
        )
        jobDetailVC.hidesBottomBarWhenPushed = true
        jobDetailVC.internshipAnnouncementId.accept(internshipId)
        navigationController?.pushViewController(jobDetailVC, animated: true)
    }
}

// MARK: - @objc func

extension SearchViewController {
    @objc
    private func handleSearchViewTap() {
        searchButtonDidTapSubject.onNext(())
    }
    
    @objc
    private func autoScroll() {
        let collectionView = rootView.advertisementCollectionView
        let visibleItem = collectionView.indexPathsForVisibleItems[0].item
        let nextItem = visibleItem + 1
        let initialAdCounts = viewModel.advertisements.count - 2
        
        collectionView.scrollToItem(at: IndexPath(item: nextItem, section: 0), at: .centeredHorizontally, animated: true)
        
        if visibleItem == initialAdCounts {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                collectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: .centeredHorizontally, animated: false)
            }
        }
        
        rootView.pageControl.currentPage = visibleItem % initialAdCounts
    }
}

// MARK: - Bind

extension SearchViewController {
    private func bindViewModel() {
        let input = SearchViewModel.Input(
            viewDidLoad: Observable.just(()),
            searchButtonTapped: searchButtonDidTapSubject.asObservable()
        )
        
        let output = viewModel.transform(input: input, disposeBag: disposeBag)
        
        output.announcements
            .drive(onNext: { [weak self] advertisements in
                self?.rootView.pageControl.numberOfPages = advertisements.count
            })
            .disposed(by: disposeBag)
        
        output.recommendedByViews
            .drive(onNext: { [weak self] viewsNum in
                self?.rootView.viewsNum = viewsNum
                self?.rootView.recommendedCollectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        output.recommendedByScraps
            .drive(onNext: { [weak self] scrapsNum in
                self?.rootView.scrapsNum = scrapsNum
                self?.rootView.recommendedCollectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        output.searchTapped
            .drive(onNext: { [weak self] in
                self?.pushToSearchResultView()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - UICollectionViewDataSource

extension SearchViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == rootView.advertisementCollectionView {
            return 1
        } else if collectionView == rootView.recommendedCollectionView {
            return 2
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == rootView.advertisementCollectionView {
            return viewModel.advertisements.count
        } else if collectionView == rootView.recommendedCollectionView {
            if section == 0 {
                return rootView.viewsNum?.count ?? 0
            } else if section == 1 {
                return rootView.scrapsNum?.count ?? 0
            }
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == rootView.advertisementCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdvertisementCollectionViewCell.className, for: indexPath) as? AdvertisementCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.bind(with: viewModel.advertisements[indexPath.row].image)
            return cell
        } else {
            if indexPath.section == 0 {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendCollectionViewCell.className, for: indexPath) as? RecommendCollectionViewCell,
                      let viewsNum = rootView.viewsNum else {
                    return UICollectionViewCell()
                }
                
                cell.bind(with: viewsNum[indexPath.row])
                return cell
            } else if indexPath.section == 1 {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendCollectionViewCell.className, for: indexPath) as? RecommendCollectionViewCell,
                      let scrapsNum = rootView.scrapsNum else {
                    return UICollectionViewCell()
                }
                
                cell.bind(with: scrapsNum[indexPath.row])
                return cell
            } else {
                return UICollectionViewCell()
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        stopTimer()
        startTimer()
        
        if scrollView.contentOffset.x == 0 { // 첫번째(3)가 보이면 3번째 index의 3으로 이동시키기
            scrollView.setContentOffset(.init(x: screenWidth * 3, y: scrollView.contentOffset.y), animated: false)
        } else if scrollView.contentOffset.x == screenWidth * 4 { //마지막 1이 보이면 1번째 index의 1로 이동
            scrollView.setContentOffset(.init(x: screenWidth, y: scrollView.contentOffset.y), animated: false)
        }
        rootView.pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.maxX) - 1
    }
}

// MARK: - UICollectionViewDelegate

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if collectionView == rootView.recommendedCollectionView {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SearchCollectionViewHeaderCell.className, for: indexPath) as? SearchCollectionViewHeaderCell else {
                return UICollectionReusableView()
            }
            
            if indexPath.section == 0 {
                headerView.bind(
                    title: "요즘 대학생들에게 인기 있는 공고",
                    subTitle: "이번 주 가장 많이 조회한 공고에요",
                    type: .main
                )
                return headerView
                
            } else if indexPath.section == 1 {
                headerView.bind(
                    title: nil,
                    subTitle: "이번 주 가장 많이 스크랩 한 공고에요",
                    type: .sub
                )
                return headerView
            }
            
        }
        
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == rootView.advertisementCollectionView {
            let advertisement = viewModel.advertisements[indexPath.item]
            if let url = URL(string: advertisement.url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        } else {
            if indexPath.section == 0 {
                guard let viewsNum = rootView.viewsNum else { return }
                
                let selectedItem = viewsNum[indexPath.item].internshipAnnouncementId
                
                pushToJobDetailVC(internshipId: selectedItem)
            } else if indexPath.section == 1 {
                guard let scrapsNum = rootView.scrapsNum else { return }
                
                let selectedItem = scrapsNum[indexPath.item].internshipAnnouncementId
                
                pushToJobDetailVC(internshipId: selectedItem)
            } else {
                return
            }
        }
    }
}
