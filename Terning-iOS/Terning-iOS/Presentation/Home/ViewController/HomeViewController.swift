//
//  HomeViewController.swift
//  Terning-iOS
//
//  Created by 이명진 on 12/19/24.
//

import UIKit

import SnapKit
import Then

import RxSwift

enum MainSection: Int, CaseIterable {
    case title
    case soonDeadlineCard
    case jobCard
}

struct JobMainModel: Codable {
    let totalPages: Int
    let totalCount: Int
    let hasNext: Bool
    let result: [AnnouncementModel]
}

final class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    private let myPageProvider = Providers.myPageProvider
    private let filterProviders = Providers.filtersProvider
    
    private let viewModel: HomeViewModel
    
    private var disposeBag = DisposeBag()
    
    private let sortAndPageSubject = BehaviorSubject<(String, Int)>(value: ("deadlineSoon", 0))
    private let soonDeadlineSubject = BehaviorSubject<Void>(value: ())
    
    private let addScrapSubject = PublishSubject<(Int, String)>()
    private let patchScrapSubject = PublishSubject<(Int, String)>()
    private let cancelScrapSubject = PublishSubject<Int>()
    
    private var mainHomeDatas: [AnnouncementModel] = []
    private var isLoading: Bool = false
    private var hasNext: Bool = true
    private var currentPage: Int = 0
    private var totalCount: Int = 0
    private var apiParameter: String = "deadlineSoon"
    
    private let sortDictionary: [String: SortingOptions] = [
        "deadlineSoon": .deadlineSoon,
        "shortestDuration": .shortestDuration,
        "longestDuration": .longestDuration,
        "mostScrapped": .mostScrapped,
        "mostViewed": .mostViewed
    ]
    
    var filterInfos: UserFilteringInfoModel = UserFilteringInfoModel(
        grade: nil, // 기본값 설정
        workingPeriod: nil, // 기본값 설정
        startYear: 0, // 기본값 설정
        startMonth: 0, // 기본값 설정
        jobType: nil
    )
    
    // MARK: - UIComponents
    
    private var hasScrapped: Bool = false {
        didSet {
            rootView.updateLayout(hasScrapped: hasScrapped, soonData: sectionTwoData, userName: userName)
        }
    }
    
    private var sectionTwoData: [AnnouncementModel] = [] {
        didSet {
            rootView.updateLayout(hasScrapped: hasScrapped, soonData: sectionTwoData, userName: userName)
        }
    }
    
    private var userName: String = "" {
        didSet {
            rootView.updateLayout(hasScrapped: hasScrapped, soonData: sectionTwoData, userName: userName)
        }
    }
    
    private lazy var rootView = HomeView(hasScrapped: hasScrapped, soonData: sectionTwoData, userName: userName)
    
    // MARK: - Life Cycles
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setDelegate()
        setRegister()
        getMyPageInfo()
        bindViewModel()
        bindScrollPagination()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        resetSortOption()
        fetchFilterInfos()
        soonDeadlineSubject.onNext(())
    }
    
    // MARK: - UI & Layout
    
    private func setUI() {
        view.backgroundColor = .white
    }
    
    private func setDelegate() {
        rootView.collectionView.delegate = self
        rootView.collectionView.dataSource = self
    }
    
    private func setRegister() {
        rootView.collectionView.register(HomeTopCell.self, forCellWithReuseIdentifier: HomeTopCell.className)
        
        rootView.collectionView.register(ClosingJobAnnouncementCell.self, forCellWithReuseIdentifier: ClosingJobAnnouncementCell.className)
        rootView.collectionView.register(CheckDeadlineCell.self, forCellWithReuseIdentifier: CheckDeadlineCell.className)
        rootView.collectionView.register(NonScrapInfoCell.self, forCellWithReuseIdentifier: NonScrapInfoCell.className)
        
        rootView.collectionView.register(StickyHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: StickyHeaderCell.className)
        
        rootView.collectionView.register(JobCardCell.self, forCellWithReuseIdentifier: JobCardCell.className)
    }
    
    // MARK: - Bind
    
    private func bindViewModel() {
        
        let input = HomeViewModel.Input(
            sortAndPage: sortAndPageSubject,
            soonDeadlineAnnouncementSubject: soonDeadlineSubject,
            addScrap: addScrapSubject,
            patchScrap: patchScrapSubject,
            cancelScrap: cancelScrapSubject
        )
        
        let output = viewModel.transform(input: input, disposeBag: disposeBag)
        
        output.jobModel
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] jobDatas in
                guard let self = self else { return }
                
                self.mainHomeDatas.append(contentsOf: jobDatas)
                
                rootView.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        output.hasNext
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] hasNext in
                guard let self = self else { return }
                
                self.hasNext = hasNext
            })
            .disposed(by: disposeBag)
        
        output.announcementCount
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] totalCount in
                guard let self = self else { return }
                
                self.totalCount = totalCount
                rootView.collectionView.isScrollEnabled = totalCount != 0
                rootView.emptyViewHidden(hidden: totalCount != 0)
                rootView.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        output.hasScrap
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] hasScrapped in
                guard let self = self else { return }
                
                self.hasScrapped = hasScrapped
            })
            .disposed(by: disposeBag)
        
        output.soonDeadlineAnnouncementModel
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] soonDeadlineCard in
                guard let self = self else { return }
                
                self.sectionTwoData = soonDeadlineCard
            })
            .disposed(by: disposeBag)
        
        output.successMessage
            .drive(onNext: { [weak self] successMessage in
                guard let self = self else { return }
                
                self.showToast(message: successMessage, heightOffset: 12)
                self.soonDeadlineSubject.onNext(())
            })
            .disposed(by: disposeBag)
        
        output.error
            .drive(onNext: { error in
                print("Error: \(error)")
            })
            .disposed(by: disposeBag)
        
    }
    
    private func bindScrollPagination() {
        rootView.collectionView.rx.contentOffset
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] offset in
                guard let self = self else { return }
                
                self.handlePagination(offset: offset)
                self.isLoading = false
            })
            .disposed(by: disposeBag)
        
        rootView.collectionView.rx.contentOffset
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] offset in
                guard let self = self else { return }
                
                if offset.y > 200 {
                    self.rootView.gradientLayerView.isHidden = false
                } else {
                    self.rootView.gradientLayerView.isHidden = true
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func handlePagination(offset: CGPoint) {
        
        let contentOffsetY = offset.y
        let collectionViewHeight = rootView.collectionView.contentSize.height
        let paginationY = rootView.collectionView.bounds.size.height
        
        if contentOffsetY > collectionViewHeight - paginationY {
            guard !isLoading, hasNext else { return }
            
            isLoading = true
            currentPage += 1
            sortAndPageSubject.onNext((apiParameter, currentPage))
        }
    }
    
    private func resetSortOption() {
        UserDefaults.standard.removeObject(forKey: "SelectedSortOption")
        UserDefaults.standard.set(SortingOptions.deadlineSoon.rawValue, forKey: "SelectedSortOption")
    }
}

// MARK: - StickyHeaderCellDelegate

extension HomeViewController: StickyHeaderCellDelegate {
    func didTapSortButton() {
        let sortSettingVC = SortSettingViewController()
        sortSettingVC.sortSettingDelegate = self
        
        let fraction = UISheetPresentationController.Detent.custom { _ in self.view.frame.height * ((380-32)/812) }
        
        if let sheet = sortSettingVC.sheetPresentationController {
            sheet.detents = [fraction]
            sheet.largestUndimmedDetentIdentifier = nil
            sortSettingVC.modalPresentationStyle = .custom
            
            // 바텀시트 뒷 배경 색을 설정
            if let presentingView = self.view {
                let dimmedBackgroundView = UIView(frame: presentingView.bounds)
                dimmedBackgroundView.backgroundColor = UIColor(white: 0, alpha: 0.3)
                dimmedBackgroundView.tag = 999 // 나중에 쉽게 찾기 위해 태그 설정
                presentingView.addSubview(dimmedBackgroundView)
                presentingView.bringSubviewToFront(sortSettingVC.view)
            }
            
            // 바텀시트가 사라질 때 배경을 제거하는 코드 추가
            sortSettingVC.presentationController?.delegate = self
        }
        
        self.present(sortSettingVC, animated: true)
    }
    
    func didTapFilterButton() {
        let filterSettingVC = FilteringViewController(
            viewModel: FilteringViewModel(
                filtersRepository: FiltersRepository(
                    filtersService: FiltersService(
                        provider: Providers.filtersProvider
                    )
                )
            ), data: filterInfos
        )
        
        let fraction = UISheetPresentationController.Detent.custom { _ in self.view.frame.height * ((637-32)/812) }
        
        if let sheet = filterSettingVC.sheetPresentationController {
            sheet.detents = [fraction]
            sheet.largestUndimmedDetentIdentifier = nil
            filterSettingVC.modalPresentationStyle = .custom
            
            // 바텀시트 뒷 배경 색을 설정
            if let presentingView = self.view {
                let dimmedBackgroundView = UIView(frame: presentingView.bounds)
                dimmedBackgroundView.backgroundColor = UIColor(white: 0, alpha: 0.3)
                dimmedBackgroundView.tag = 999 // 나중에 쉽게 찾기 위해 태그 설정
                presentingView.addSubview(dimmedBackgroundView)
                presentingView.bringSubviewToFront(filterSettingVC.view)
            }
            
            // 바텀시트가 사라질 때 배경을 제거하는 코드 추가
            filterSettingVC.presentationController?.delegate = self
        }
        
        filterSettingVC.removeModal
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.mainHomeDatas.removeAll()
                fetchFilterInfos()
                self.currentPage = 0
                self.sortAndPageSubject.onNext((apiParameter, currentPage))
            }.disposed(by: disposeBag)
        
        track(eventName: .clickHomeFilteringSave)
        
        self.present(filterSettingVC, animated: true)
    }
}

// MARK: - UICollectionViewDelegate

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let section = MainSection(rawValue: indexPath.section) else {
            return
        }
        
        switch section {
        case .jobCard:
            print(indexPath)
            track(eventName: .clickHomeInternCard)
            let jobDetailVC = JobDetailViewController(
                viewModel: JobDetailViewModel(
                    scrapUseCase: ScrapUseCase(
                        repository: ScrapRepository(
                            service: ScrapsService(
                                provider: Providers.scrapsProvider
                            )
                        )
                    )
                )
            )
            
            let index = indexPath.row
            let internshipId = mainHomeDatas[index].internshipAnnouncementId
            
            jobDetailVC.internshipAnnouncementId.accept(internshipId)
            
            /// 공고 상세에서 스크랩을 적용했을때, 스크랩 상태를 홈 공고 UI와 얼라인을 해주는 코드 입니다.
            jobDetailVC.didToggleScrap = { [weak self] internshipId, isScrapped in
                guard let self = self else { return }
                
                if let rowIndex = self.mainHomeDatas.firstIndex(where: { $0.internshipAnnouncementId == internshipId }) {
                    self.mainHomeDatas[rowIndex].isScrapped = isScrapped
                    
                    let indexPath = IndexPath(row: rowIndex, section: 2)
                    self.rootView.collectionView.reloadItems(at: [indexPath])
                }
            }
            
            jobDetailVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(jobDetailVC, animated: true)
        default:
            return
        }
    }
}

// MARK: - UICollectionViewDataSource

extension HomeViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return MainSection.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let section = MainSection(rawValue: indexPath.section)
        
        switch section {
        case .jobCard:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: StickyHeaderCell.className,
                for: indexPath
            ) as? StickyHeaderCell else {
                return UICollectionReusableView()
            }
            
            headerView.sortButton.changeTitle(name: sortDictionary[apiParameter]?.rawValue ?? "")
            headerView.bind(totalCount: totalCount, name: userName)
            headerView.delegate = self
            headerView.backgroundColor = .white
            
            return headerView
            
        default:
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let mainSection = MainSection(rawValue: section) else { return 0 }
        
        switch mainSection {
        case .title:
            return 1
        case .soonDeadlineCard:
            if self.hasScrapped && !sectionTwoData.isEmpty {
                return sectionTwoData.count
            }
            return 1
        case .jobCard:
            return mainHomeDatas.count
        }
    }
    
    // 섹션별 셀 배치
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let mainSection = MainSection(rawValue: indexPath.section) else {
            return UICollectionViewCell()
        }
        
        switch mainSection {
        case .title:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeTopCell.className, for: indexPath) as? HomeTopCell else {
                return UICollectionViewCell()
            }
            
            return cell
            
        case .soonDeadlineCard:
            if hasScrapped {
                if sectionTwoData.isEmpty {
                    // 스크랩 상태가 true이고 데이터가 없을 경우, 일주일 내에 마감인 공고가 없어요
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CheckDeadlineCell.className, for: indexPath) as? CheckDeadlineCell else {
                        return UICollectionViewCell()
                    }
                    
                    cell.checkDeadlineDelegate = self
                    return cell
                } else {
                    // 스크랩 상태가 true이고 데이터가 있을 경우
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ClosingJobAnnouncementCell.className, for: indexPath) as? ClosingJobAnnouncementCell else {
                        return UICollectionViewCell()
                    }
                    cell.delegate = self
                    cell.bindData(model: sectionTwoData[indexPath.row], indexPath: indexPath)
                    return cell
                }
            } else {
                // 스크랩 상태가 false일 경우, 아직 스크랩된 인턴 공고가 없어요!
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NonScrapInfoCell.className, for: indexPath) as? NonScrapInfoCell else {
                    return UICollectionViewCell()
                }
                return cell
            }
        case .jobCard:
            guard let cell = rootView.collectionView.dequeueReusableCell(withReuseIdentifier: JobCardCell.className, for: indexPath) as? JobCardCell else { return UICollectionViewCell() }
            
            cell.bind(model: mainHomeDatas[indexPath.row], indexPath: indexPath)
            cell.delegate = self
            return cell
        }
    }
}

// MARK: - SortSettingButtonProtocol

extension HomeViewController: SortSettingButtonProtocol {
    func didSelectSortingOption(_ option: SortingOptions) {
        guard let headerView = rootView.collectionView.supplementaryView(
            forElementKind: UICollectionView.elementKindSectionHeader,
            at: IndexPath(row: 0, section: MainSection.jobCard.rawValue)
        ) as? StickyHeaderCell else { return }
        
        switch option {
        case .deadlineSoon:
            apiParameter = "deadlineSoon"
            track(eventName: .clickInOrderOfDeadline)
        case .shortestDuration:
            apiParameter = "shortestDuration"
            track(eventName: .clickInOrderOfShortTerm)
        case .longestDuration:
            apiParameter = "longestDuration"
            track(eventName: .clickInOrderOfLongTerm)
        case .mostScrapped:
            apiParameter = "mostScrapped"
            track(eventName: .clickInOrderOfScraps)
        case .mostViewed:
            apiParameter = "mostViewed"
            track(eventName: .clickInOrderOfHits)
        }
        
        headerView.sortButton.changeTitle(name: option.title)
        
        self.mainHomeDatas.removeAll()
        self.sortAndPageSubject.onNext((apiParameter, 0))
        
        removeDimmedBackgroundView()
    }
}

extension HomeViewController: JobCardScrapedCellProtocol {
    func scrapButtonDidTap(index: Int) {
        
        track(eventName: .clickHomeScrap)
        
        let model = mainHomeDatas[index]
        
        if model.isScrapped {
            let alertSheet = CustomAlertViewController(alertViewType: .info)
            
            alertSheet.modalTransitionStyle = .crossDissolve
            alertSheet.modalPresentationStyle = .overFullScreen
            
            alertSheet.centerButtonDidTapAction = { [weak self] in
                guard let self = self else { return }
                
                self.cancelScrapSubject.onNext(model.internshipAnnouncementId)
                
                mainHomeDatas[index].isScrapped = false
                
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
                
                self.addScrapSubject.onNext((model.internshipAnnouncementId, selectedColorNameRelay))
                
                mainHomeDatas[index].isScrapped = true
                
                self.dismiss(animated: false)
            }
            
            self.present(alertSheet, animated: false)
        }
    }
}

// MARK: - CheckDeadlineCellProtocol

extension HomeViewController: CheckDeadlineCellProtocol {
    func checkDeadlineButtonDidTap() {
        self.tabBarController?.selectedIndex = 1
    }
}

// MARK: - UIAdaptivePresentationControllerDelegate

extension HomeViewController: UIAdaptivePresentationControllerDelegate {
    func removeDimmedBackgroundView() {
        if let presentingView = self.view,
           let dimmedBackgroundView = presentingView.viewWithTag(999) {
            UIView.animate(withDuration: 0.3) {
                dimmedBackgroundView.alpha = 0
            } completion: { _ in
                dimmedBackgroundView.removeFromSuperview()
            }
        }
    }
    
    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        removeDimmedBackgroundView()
    }
}

// MARK: - UpcomingCardCellProtocol

extension HomeViewController: UpcomingCardCellProtocol {
    func upcomingCardDidTap(indexPath index: Int) {
        print(index)
        let jobDetailViewController = JobDetailViewController(
            viewModel: JobDetailViewModel(
                scrapUseCase: ScrapUseCase(
                    repository: ScrapRepository(
                        service: ScrapsService(
                            provider: Providers.scrapsProvider
                        )
                    )
                )
            )
        )
        
        let model = sectionTwoData[index]
        
        jobDetailViewController.internshipAnnouncementId.accept(model.internshipAnnouncementId)
        
        /// 공고 상세에서 스크랩을 적용했을때, 스크랩 상태를 홈 공고 UI와 얼라인을 해주는 코드 입니다.
        jobDetailViewController.didToggleScrap = { [weak self] internshipId, isScrapped in
            guard let self = self else { return }
            
            if let rowIndex = self.mainHomeDatas.firstIndex(where: { $0.internshipAnnouncementId == internshipId }) {
                self.mainHomeDatas[rowIndex].isScrapped = isScrapped
                
                let indexPath = IndexPath(row: rowIndex, section: 2)
                self.rootView.collectionView.reloadItems(at: [indexPath])
            }
        }
        
        jobDetailViewController.hidesBottomBarWhenPushed = true
        
        track(eventName: .clickRemindInternCard)
        
        self.navigationController?.pushViewController(jobDetailViewController, animated: true)
        
    }
}

// MARK: - Network

extension HomeViewController {
    private func getMyPageInfo() {
        myPageProvider.request(.getProfileInfo) { result in
            switch result {
            case .success(let response):
                let status = response.statusCode
                
                if 200..<300 ~= status {
                    do {
                        let responseDto = try response.map(BaseResponse<UserProfileInfoModel>.self)
                        guard let data = responseDto.result else { return }
                        
                        UserManager.shared.userName = data.name
                        
                    } catch {
                        print("사용자 정보를 불러올 수 없어요.")
                        print(error.localizedDescription)
                    }
                    
                } else {
                    print("404 error")
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func fetchFilterInfos() {
        filterProviders.request(.getFilterDatas) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let result):
                let status = result.statusCode
                if 200..<300 ~= status {
                    do {
                        let responseDto = try result.map(BaseResponse<UserFilteringInfoModel>.self)
                        guard let data = responseDto.result else { return }
                        
                        self.filterInfos = data
                        self.userName = UserManager.shared.userName ?? "" // 유저 네임 viewWillAppear 시 매번 접근
                        
                    } catch {
                        print(error.localizedDescription)
                    }
                }
                if status >= 400 {
                    print("400 error")
                    self.showNetworkFailureToast()
                }
            case .failure(let error):
                print(error.localizedDescription)
                self.showNetworkFailureToast()
            }
        }
    }
}
