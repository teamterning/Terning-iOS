//
//  NewHomeViewController.swift
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

final class NewHomeViewController: UIViewController {
    
    // MARK: - Properties
    
    private let myPageProvider = Providers.myPageProvider
    private let homeProviders = Providers.homeProvider
    private let filterProviders = Providers.filtersProvider
    private let scrapProviders = Providers.scrapsProvider
    
    private var userName: String = ""
    private var selectedOption: String = ""
    
    var todayDeadlineLists: [ScrapedAndDeadlineModel] = [] {
        didSet {
            rootView.collectionView.reloadData()
        }
    }
    
    var filterInfos: UserFilteringInfoModel = UserFilteringInfoModel(
        grade: 0, // 기본값 설정
        workingPeriod: 0, // 기본값 설정
        startYear: 2023, // 기본값 설정
        startMonth: 1 // 기본값 설정
    )
    
    var jobCardLists: [JobCardModel] = [] {
        didSet {
            rootView.collectionView.reloadData()
        }
    }
    
    var isNoneData: Bool {
        return filterInfos.grade == nil || filterInfos.workingPeriod == nil ||
        filterInfos.startYear == nil || filterInfos.startMonth == nil
    }
    
    // MARK: - UIComponents
    
    private let rootView = NewHomeView()
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setDelegate()
        setRegister()
        fetchTodayDeadlineDatas()
        fetchFilterInfos()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        getMyPageInfo()
        fetchTodayDeadlineDatas()
        fetchFilterInfos()
    }
    
    override func loadView() {
        self.view = rootView
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
        rootView.collectionView.register(ScrapInfoHeaderCell.self, forCellWithReuseIdentifier: ScrapInfoHeaderCell.className)
        
        rootView.collectionView.register(NonScrapInfoCell.self, forCellWithReuseIdentifier: NonScrapInfoCell.className)
        rootView.collectionView.register(IsScrapInfoViewCell.self, forCellWithReuseIdentifier: IsScrapInfoViewCell.className)
        
        rootView.collectionView.register(FilterInfoCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: FilterInfoCell.className)
        
        rootView.collectionView.register(JobCardScrapedCell.self, forCellWithReuseIdentifier: JobCardScrapedCell.className) // 맞춤 공고가 있는 경우
        rootView.collectionView.register(NonJobCardCell.self, forCellWithReuseIdentifier: NonJobCardCell.className)
        rootView.collectionView.register(InavailableFilterView.self, forCellWithReuseIdentifier: InavailableFilterView.className)
    }
}

// MARK: - Extensions

extension NewHomeViewController: UICollectionViewDelegate {
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
            let jobDetailVC = JobDetailViewController()
            let index = jobCardLists[indexPath.row].intershipAnnouncementId
            jobDetailVC.internshipAnnouncementId.onNext(index)
            self.navigationController?.pushViewController(jobDetailVC, animated: true)
        default:
            return
        }
    }
}

extension NewHomeViewController: UICollectionViewDataSource {
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
            return todayDeadlineLists.isEmpty ? 1 : todayDeadlineLists.count
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
            if todayDeadlineLists.isEmpty {
                guard let cell = rootView.collectionView.dequeueReusableCell(withReuseIdentifier: NonScrapInfoCell.className, for: indexPath) as? NonScrapInfoCell else { return UICollectionViewCell() } // 오늘 마감인 공고가 없어요
                return cell
                
            } else {
                guard let cell = rootView.collectionView.dequeueReusableCell(withReuseIdentifier: IsScrapInfoViewCell.className, for: indexPath) as? IsScrapInfoViewCell else { return UICollectionViewCell() }
                cell.bindData(model: todayDeadlineLists[indexPath.item])
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
                guard let cell = rootView.collectionView.dequeueReusableCell(withReuseIdentifier: JobCardScrapedCell.className, for: indexPath) as? JobCardScrapedCell else { return UICollectionViewCell() }
                cell.delegate = self
                cell.bindData(model: jobCardLists[indexPath.row])
                return cell
            }
        }
        return UICollectionViewCell()
    }
}

// MARK: - FilterButtonProtocol

extension NewHomeViewController: FilterButtonProtocol {
    func filterButtonDidTap() {
        let filterSettingVC = FilteringSettingViewController(data: filterInfos)
        
        filterSettingVC.saveButtonDelegate = self
        
        let fraction = UISheetPresentationController.Detent.custom { _ in self.view.frame.height * ((658-32)/812) }
        
        if let sheet = filterSettingVC.sheetPresentationController {
            sheet.detents = [fraction, .large()]
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
extension NewHomeViewController: UIAdaptivePresentationControllerDelegate {
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

extension NewHomeViewController: SaveButtonProtocol {
    func didSaveSetting() {
        removeDimmedBackgroundView()
    }
}

// MARK: - SortButtonDelegate

extension NewHomeViewController: SortButtonProtocol {
    func sortButtonTap() {
        print("delegate func")
        let sortSettingVC = SortSettingViewController()
        sortSettingVC.sortSettingDelegate = self
        
        let fraction = UISheetPresentationController.Detent.custom { _ in self.view.frame.height * ((380-32)/812) }
        
        if let sheet = sortSettingVC.sheetPresentationController {
            sheet.detents = [fraction, .large()]
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

extension NewHomeViewController: SortSettingButtonProtocol {
    func didSelectSortingOption(_ option: SortingOptions) {
        print("dfdfdfd")
        guard let headerView = rootView.collectionView.supplementaryView(
            forElementKind: UICollectionView.elementKindSectionHeader,
            at: IndexPath(row: 0, section: HomeMainSection.jobCard.rawValue)
        ) as? FilterInfoCell else { return }
        headerView.sortButtonLabel.text = option.title
        rootView.collectionView.reloadData()
        
        // Fetch job card data with the selected option
        fetchJobCardDatas(option.rawValue)
    }
}

// MARK: - ScrapDidTapDelegate

extension NewHomeViewController: ScrapDidTapDelegate {
    func scrapButtonDidTap(id index: Int) {
        let model = jobCardLists[index]
        let alertSheet = CustomAlertViewController(alertType: .custom)
        
        alertSheet.setData3(model: model, deadline: model.deadline)
        
        alertSheet.modalTransitionStyle = .crossDissolve
        alertSheet.modalPresentationStyle = .overFullScreen
        
        alertSheet.centerButtonTapAction = { [weak self] in
            guard let self = self else { return }
            let colorIndex = alertSheet.selectedColorIndexRelay
            
            self.addScrapAnnouncement(scrapId: model.intershipAnnouncementId, color: colorIndex.value)
            self.dismiss(animated: false)
            
        }
        self.present(alertSheet, animated: false)
    }
}

// MARK: - Network

extension NewHomeViewController {
    private func fetchTodayDeadlineDatas() {
        homeProviders.request(.getHomeToday) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let result):
                let status = result.statusCode
                if 200..<300 ~= status {
                    do {
                        let responseDto = try result.map(BaseResponse<[ScrapedAndDeadlineModel]>.self)
                        guard let data = responseDto.result else { return }
                        
                        self.todayDeadlineLists = data
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
                        
                        print("🔥🔥🔥🔥🔥🔥🔥🔥🔥\(data)")
                        self.filterInfos = data
                        
                        // 0.5초 뒤에 fetchJobCardDatas 호출
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.fetchJobCardDatas(self.selectedOption)
                            self.fetchTodayDeadlineDatas()
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
    
    private func fetchJobCardDatas(_ option: String) {
        print("🔥🔥🔥Fetching job card data with sortBy: \(option)🔥🔥🔥")
        
        var sortingOption: String = ""
        
        if option == "채용 마감 이른순" {
            sortingOption = "deadlineSoon"
        } else if option == "짧은 근무 기간 순" {
            sortingOption = "shortestDuration"
        } else if option == "긴 근무 기간 순" {
            sortingOption = "longestDuration"
        } else if option == "스크랩 많은 순" {
            sortingOption = "mostScrapped"
        } else if option == "조회수 많은 순" {
            sortingOption = "mostViewed"
        }
         
        homeProviders.request(.getHome(sortBy: sortingOption, startYear: filterInfos.startYear ?? 0, startMonth: filterInfos.startMonth ?? 0)) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let result):
                let status = result.statusCode
                if 200..<300 ~= status {
                    do {
                        let responseDto = try result.map(BaseResponse<[JobCardModel]>.self)
                        guard let data = responseDto.result else { return }
                        
                        self.jobCardLists = data
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
    
    private func patchScrapAnnouncement(scrapId: Int?, color: Int) {
        guard let scrapId = scrapId else { return }
        Providers.scrapsProvider.request(.patchScrap(scrapId: scrapId, color: color)) { [weak self] result in
            LoadingIndicator.hideLoading()
            guard let self = self else { return }
            switch result {
            case .success(let response):
                let status = response.statusCode
                if 200..<300 ~= status {
                    print("스크랩 수정 성공")
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
    
    private func addScrapAnnouncement(scrapId: Int, color: Int) {
        Providers.scrapsProvider.request(.addScrap(internshipAnnouncementId: scrapId, color: color)) { [weak self] result in
            LoadingIndicator.hideLoading()
            guard let self = self else { return }
            switch result {
            case .success(let response):
                let status = response.statusCode
                if 200..<300 ~= status {
                    print("스크랩 수정 성공")
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
                        self.userName = data.name
                        
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
