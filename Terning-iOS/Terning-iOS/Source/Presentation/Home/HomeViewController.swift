//
//  HomeViewController.swift
//  Terning-iOS
//
//  Created by 이명진 on 7/19/24.
//

import Foundation

import UIKit
import Then

enum HomeMainSection: Int, CaseIterable {
    case todayDeadlineUserInfo
    case todayDeadline
    case jobCard
    
    var numberOfItemsInSection: Int {
        switch self {
        case .todayDeadlineUserInfo:
            return 1
        case .todayDeadline, .jobCard:
            return 0
        }
    }
}

final class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    private let myPageProvider = Providers.myPageProvider
    private let homeProviders = Providers.homeProvider
    private let filterProviders = Providers.filtersProvider
    private let scrapProviders = Providers.scrapsProvider
    
    var apiParameter: String = "deadlineSoon"
    
    var userName: String = ""
    var hasScrapped: Bool = false
    var upcomingCardLists: [AnnouncementModel] = [] {
        didSet {
            rootView.collectionView.reloadData()
        }
    }
    
    var filterInfos: UserFilteringInfoModel = UserFilteringInfoModel(
        grade: nil, // 기본값 설정
        workingPeriod: nil, // 기본값 설정
        startYear: nil, // 기본값 설정
        startMonth: nil // 기본값 설정
    )
    
    private var jobCardTotalCount: JobCardModel = JobCardModel(totalCount: 0, result: [])
    
    private var jobCardLists: [AnnouncementModel] = [] {
        didSet {
            print("📋\(jobCardLists)📋")
            rootView.collectionView.reloadData()
        }
    }
    
    private var isNoneData: Bool {
        return filterInfos.grade == nil || filterInfos.workingPeriod == nil ||
        filterInfos.startYear == nil || filterInfos.startMonth == nil
    }
    
    // MARK: - UIComponents
    
    private lazy var rootView = HomeView(frame: .zero, homeViewController: self)
    
    // MARK: - Life Cycles
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setDelegate()
        setRegister()
        fetchFilterInfos()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        getMyPageInfo()
        fetchFilterInfos()
        resetSortOption()
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
        // 마감 공고 타이틀
        rootView.collectionView.register(ScrapInfoHeaderCell.self, forCellWithReuseIdentifier: ScrapInfoHeaderCell.className)
        
        // 곧 마감인 공고 카드 셀
        rootView.collectionView.register(NonScrapInfoCell.self, forCellWithReuseIdentifier: NonScrapInfoCell.className)
        rootView.collectionView.register(CheckDeadlineCell.self, forCellWithReuseIdentifier: CheckDeadlineCell.className)
        rootView.collectionView.register(IsScrapInfoViewCell.self, forCellWithReuseIdentifier: IsScrapInfoViewCell.className)
        
        // 필터링 셀
        rootView.collectionView.register(FilterInfoCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: FilterInfoCell.className)
        
        // 딱 맞는 대학생 인턴공고 셀
        rootView.collectionView.register(JobCardCell.self, forCellWithReuseIdentifier: JobCardCell.className) // 맞춤 공고가 있는 경우
        rootView.collectionView.register(NonJobCardCell.self, forCellWithReuseIdentifier: NonJobCardCell.className)
        rootView.collectionView.register(InavailableFilterView.self, forCellWithReuseIdentifier: InavailableFilterView.className)
    }
    
    // MARK: - private func
    
    private func resetSortOption() {
        UserDefaults.standard.removeObject(forKey: "SelectedSortOption")
        UserDefaults.standard.set(SortingOptions.deadlineSoon.rawValue, forKey: "SelectedSortOption")
    }
}

// MARK: - Extensions

extension HomeViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = rootView.collectionView.contentOffset.y
        let stickyAttributes = 220.6
        
        if offsetY >= stickyAttributes {
            rootView.gradientLayerView.isHidden = false
        } else {
            rootView.gradientLayerView.isHidden = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let section = HomeMainSection(rawValue: indexPath.section) else {
            return
        }
        
        switch section {
        case .jobCard:
            print(indexPath)
            let jobDetailVC = JobDetailViewController(
                viewModel: JobDetailViewModel(
                    jobDetailRepository: JobDetailRepository(
                        scrapService: ScrapsService(
                            provider: Providers.scrapsProvider
                        )
                    )
                )
            )
            let index = jobCardLists[indexPath.row].internshipAnnouncementId
            jobDetailVC.internshipAnnouncementId.accept(index)
            jobDetailVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(jobDetailVC, animated: true)
        default:
            return
        }
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return HomeMainSection.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let section = HomeMainSection(rawValue: indexPath.section)
        
        switch section {
        case .jobCard:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: FilterInfoCell.className,
                for: indexPath
            ) as? FilterInfoCell else {
                return UICollectionReusableView()
            }
            
            headerView.backgroundColor = .white
            headerView.filterDelegate = self
            headerView.sortDelegate = self
            headerView.bind(model: filterInfos)
            headerView.countBind(model: jobCardTotalCount)
            
            return headerView
            
        default:
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = HomeMainSection(rawValue: section) else {
            return 0
        }
        
        switch section {
        case .todayDeadlineUserInfo:
            return section.numberOfItemsInSection
        case .todayDeadline:
            return upcomingCardLists.isEmpty ? 1 : upcomingCardLists.count
        case .jobCard:
            return (isNoneData || jobCardLists.isEmpty) ? 1 : jobCardLists.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = HomeMainSection(rawValue: indexPath.section) else {
            fatalError("Section 오류")
        }
        
        switch section {
        case .todayDeadlineUserInfo:
            guard let cell = rootView.collectionView.dequeueReusableCell(withReuseIdentifier: ScrapInfoHeaderCell.className, for: indexPath) as? ScrapInfoHeaderCell else { return UICollectionViewCell() }
            cell.bind(name: userName)
            return cell
            
        case .todayDeadline:
            if hasScrapped {
                if upcomingCardLists.isEmpty {
                    guard let cell = rootView.collectionView.dequeueReusableCell(withReuseIdentifier: CheckDeadlineCell.className, for: indexPath) as? CheckDeadlineCell  else { return UICollectionViewCell() }
                    cell.checkDeadlineDelegate = self
                    return cell
                } else {
                    guard let cell = rootView.collectionView.dequeueReusableCell(withReuseIdentifier: IsScrapInfoViewCell.className, for: indexPath) as? IsScrapInfoViewCell else { return UICollectionViewCell() }
                    cell.upcomingCardDelegate = self
                    cell.bindData(model: upcomingCardLists[indexPath.item], indexPath: indexPath)
                    return cell
                }
            } else {
                guard let cell = rootView.collectionView.dequeueReusableCell(withReuseIdentifier: NonScrapInfoCell.className, for: indexPath) as? NonScrapInfoCell else { return UICollectionViewCell() } // 오늘 마감인 공고가 없어요
                return cell
            }
            
        case .jobCard:
            if isNoneData && jobCardLists.isEmpty {
                guard let cell = rootView.collectionView.dequeueReusableCell(withReuseIdentifier: NonJobCardCell.className, for: indexPath) as? NonJobCardCell else { return UICollectionViewCell() }
                return cell
                
            } else if !isNoneData && jobCardLists.isEmpty {
                guard let cell = rootView.collectionView.dequeueReusableCell(withReuseIdentifier: InavailableFilterView.className, for: indexPath) as? InavailableFilterView else { return UICollectionViewCell() }
                return cell
                
            } else if !isNoneData && !jobCardLists.isEmpty {
                guard let cell = rootView.collectionView.dequeueReusableCell(withReuseIdentifier: JobCardCell.className, for: indexPath) as? JobCardCell else { return UICollectionViewCell() }
                cell.delegate = self
                cell.bind(model: jobCardLists[indexPath.row], indexPath: indexPath)
                return cell
            }
        }
        return UICollectionViewCell()
    }
}

// MARK: - FilterButtonProtocol

extension HomeViewController: FilterButtonProtocol {
    func filterButtonDidTap() {
        let filterSettingVC = FilteringSettingViewController(data: filterInfos)
        
        filterSettingVC.saveButtonDelegate = self
        
        let fraction = UISheetPresentationController.Detent.custom { _ in self.view.frame.height * ((658-32)/812) }
        
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
        
        self.present(filterSettingVC, animated: true)
    }
}

// UIAdaptivePresentationControllerDelegate를 구현하여 바텀시트가 사라질 때 호출되는 메서드 추가
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

// MARK: - SaveButtonDelegate

extension HomeViewController: SaveButtonProtocol {
    func didSaveSetting() {
        removeDimmedBackgroundView()
        fetchFilterInfos()
    }
}

// MARK: - SortButtonDelegate

extension HomeViewController: SortButtonProtocol {
    func sortButtonTap() {
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
}

// MARK: - SortSettingButtonDelegate

extension HomeViewController: SortSettingButtonProtocol {
    func didSelectSortingOption(_ option: SortingOptions) {
        guard let headerView = rootView.collectionView.supplementaryView(
            forElementKind: UICollectionView.elementKindSectionHeader,
            at: IndexPath(row: 0, section: HomeMainSection.jobCard.rawValue)
        ) as? FilterInfoCell else { return }
        headerView.sortButtonLabel.text = option.title
        rootView.collectionView.reloadData()
        
        switch option {
        case .deadlineSoon:
            apiParameter =  "deadlineSoon"
        case .shortestDuration:
            apiParameter =  "shortestDuration"
        case .longestDuration:
            apiParameter = "longestDuration"
        case .mostScrapped:
            apiParameter = "mostScrapped"
        case .mostViewed:
            apiParameter = "mostViewed"
        }
        
        fetchJobCardDatas(apiParameter)
        removeDimmedBackgroundView()
    }
}

// MARK: - CheckDeadlineButtonDidTapDelegate

extension HomeViewController: CheckDeadlineCellProtocol {
    func checkDeadlineButtonDidTap() {
        self.tabBarController?.selectedIndex = 1
    }
}

// MARK: - ScrapButtonDidTapDelegate

extension HomeViewController: JobCardScrapedCellProtocol {
    func scrapButtonDidTap(index: Int) {
        
        let model = jobCardLists[index]
        
        if model.isScrapped {
            let alertSheet = CustomAlertViewController(alertViewType: .info)
            
            alertSheet.modalTransitionStyle = .crossDissolve
            alertSheet.modalPresentationStyle = .overFullScreen
            
            alertSheet.centerButtonDidTapAction = { [weak self] in
                guard let self = self else { return }
                
                self.cancelScrapAnnouncement(internshipAnnouncementId: model.internshipAnnouncementId)
                
                jobCardLists[index].isScrapped = false
                
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
                
                self.addScrapAnnouncement(internshipAnnouncementId: model.internshipAnnouncementId, color: selectedColorNameRelay)
                
                jobCardLists[index].isScrapped = true
                
                self.dismiss(animated: false)
            }
            
            self.present(alertSheet, animated: false)
        }
    }
}

// MARK: - UpcomingCardCellDidTapDelegate

extension HomeViewController: UpcomingCardCellProtocol {
    func upcomingCardDidTap(index: Int) {
        let jobDetailViewController = JobDetailViewController(
            viewModel: JobDetailViewModel(
                jobDetailRepository: JobDetailRepository(
                    scrapService: ScrapsService(
                        provider: Providers.scrapsProvider
                    )
                )
            )
        )
        
        let model = upcomingCardLists[index]
        
        let alertSheet = CustomAlertViewController(alertViewType: .changeColorAndPushJobDetail)
        
        jobDetailViewController.internshipAnnouncementId.accept(model.internshipAnnouncementId)
        jobDetailViewController.hidesBottomBarWhenPushed = true
        alertSheet.setAnnouncementData(model: model)
        
        alertSheet.modalTransitionStyle = .crossDissolve
        alertSheet.modalPresentationStyle = .overFullScreen
        
        alertSheet.leftButtonDidTapAction = {
            let selectedColorNameRelay = alertSheet.selectedColorNameRelay.value
            
            self.patchScrapAnnouncement(internshipAnnouncementId: model.internshipAnnouncementId, color: selectedColorNameRelay)
            self.dismiss(animated: true)
        }
        
        alertSheet.rightButtonDidTapAction = {
            self.dismiss(animated: true)
            self.navigationController?.pushViewController(jobDetailViewController, animated: true)
            
        }
        
        self.present(alertSheet, animated: false)
    }
}

// MARK: - Network

extension HomeViewController {
    func fetchTodayDeadlineDatas() {
        homeProviders.request(.getHomeToday) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let result):
                let status = result.statusCode
                if 200..<300 ~= status {
                    do {
                        let responseDto = try result.map(BaseResponse<UpcomingCardModel>.self)
                        guard let data = responseDto.result else { return }
                        
                        print("🔥 fetchTodayDeadlineDatas: \(data.scraps)")
                        upcomingCardLists = data.scraps
                        hasScrapped = data.hasScrapped
                        rootView.collectionView.reloadData()
                        
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
                        
                        // 0.5초 뒤에 fetchJobCardDatas 호출
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            self.fetchJobCardDatas(self.apiParameter)
                            self.fetchTodayDeadlineDatas()
                            self.rootView.collectionView.reloadData()
                        }
                        
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
    
    private func fetchJobCardDatas(_ apiParameter: String) {
        print("🔥🔥🔥Fetching job card data with sortBy: \(apiParameter)🔥🔥🔥")
        homeProviders.request(.getHome(sortBy: apiParameter, startYear: filterInfos.startYear ?? 2024, startMonth: filterInfos.startMonth ?? 9)) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let result):
                let status = result.statusCode
                if 200..<300 ~= status {
                    do {
                        let responseDto = try result.map(BaseResponse<JobCardModel>.self)
                        guard let data = responseDto.result else { return }
                        
                        self.jobCardLists = data.result
                        self.jobCardTotalCount = data
                        
                        if !jobCardLists.isEmpty {
                            if data.result.contains(where: { $0.isScrapped }) {
                                self.hasScrapped = true
                            }
                        }
                        
                        self.rootView.collectionView.reloadData()
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
    
    private func patchScrapAnnouncement(internshipAnnouncementId: Int?, color: String) {
        guard let scrapId = internshipAnnouncementId else { return }
        
        Providers.scrapsProvider.request(.patchScrap(internshipAnnouncementId: scrapId, color: color)) { [weak self] result in
            LoadingIndicator.hideLoading()
            guard let self = self else { return }
            switch result {
            case .success(let response):
                let status = response.statusCode
                if 200..<300 ~= status {
                    showToast(message: "스크랩 수정 성공", heightOffset: 20)
                    self.fetchTodayDeadlineDatas()
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
    
    private func addScrapAnnouncement(internshipAnnouncementId: Int, color: String) {
        Providers.scrapsProvider.request(.addScrap(internshipAnnouncementId: internshipAnnouncementId, color: color)) { [weak self] result in
            LoadingIndicator.hideLoading()
            guard let self = self else { return }
            switch result {
            case .success(let response):
                let status = response.statusCode
                if 200..<300 ~= status {
                    self.showToast(message: "관심 공고가 캘린더에 스크랩 되었어요!", heightOffset: 20)
                    self.fetchTodayDeadlineDatas()
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
    
    private func cancelScrapAnnouncement(internshipAnnouncementId: Int) {
        Providers.scrapsProvider.request(.removeScrap(internshipAnnouncementId: internshipAnnouncementId)) { [weak self] result in
            LoadingIndicator.hideLoading()
            guard let self = self else { return }
            switch result {
            case .success(let response):
                let status = response.statusCode
                if 200..<300 ~= status {
                    self.showToast(message: "관심 공고가 캘린더에서 사라졌어요!", heightOffset: 20)
                    self.fetchTodayDeadlineDatas()
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
    
    private func getMyPageInfo() {
        myPageProvider.request(.getProfileInfo) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                let status = response.statusCode
                
                if 200..<300 ~= status {
                    do {
                        let responseDto = try response.map(BaseResponse<UserProfileInfoModel>.self)
                        guard let data = responseDto.result else { return }
                        
                        userName = data.name
                        
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
}
