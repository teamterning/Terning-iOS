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
    case homeHeader
    case filterInfo
    case sortButton
    case jobCard
    
    var numberOfItemsInSection: Int {
        switch self {
        case .todayDeadlineUserInfo, .homeHeader, .filterInfo, .sortButton:
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
    
    var todayDeadlineLists: [ScrapedAndDeadlineModel] = [] {
        didSet {
            rootView.collectionView.reloadData()
        }
    }
    
    var filterInfos: UserFilteringInfoModel = UserFilteringInfoModel(
        grade: 0, // 기본값 설정
        workingPeriod: 0, // 기본값 설정
        startYear: 2020, // 기본값 설정
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
        
        rootView.collectionView.register(HomeInfoCell.self, forCellWithReuseIdentifier: HomeInfoCell.className)
        
        rootView.collectionView.register(FilterInfoCell.self, forCellWithReuseIdentifier: FilterInfoCell.className)
        
        rootView.collectionView.register(SortInfoCell.self, forCellWithReuseIdentifier: SortInfoCell.className)
        
        rootView.collectionView.register(JobCardScrapedCell.self, forCellWithReuseIdentifier: JobCardScrapedCell.className) // 맞춤 공고가 있는 경우
        rootView.collectionView.register(NonJobCardCell.self, forCellWithReuseIdentifier: NonJobCardCell.className)
        rootView.collectionView.register(InavailableFilterView.self, forCellWithReuseIdentifier: InavailableFilterView.className)
    }
    
}

extension NewHomeViewController: UICollectionViewDelegate {
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = HomeMainSection(rawValue: section) else {
            return 0
        }
        
        switch section {
        case .todayDeadlineUserInfo, .homeHeader, .filterInfo, .sortButton:
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
            
        case .homeHeader:
            guard let cell = rootView.collectionView.dequeueReusableCell(withReuseIdentifier: HomeInfoCell.className, for: indexPath) as? HomeInfoCell else { return UICollectionViewCell() }
            
            return cell
        case .filterInfo:
            guard let cell = rootView.collectionView.dequeueReusableCell(withReuseIdentifier: FilterInfoCell.className, for: indexPath) as? FilterInfoCell else { return UICollectionViewCell() }
            cell.delegate = self
            cell.bind(model: self.filterInfos)
            
            return cell
        case .sortButton:
            guard let cell = rootView.collectionView.dequeueReusableCell(withReuseIdentifier: SortInfoCell.className, for: indexPath) as? SortInfoCell else { return UICollectionViewCell() }
            
            return cell
            
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
                        
                        self.filterInfos = data
                        
                        // 0.5초 뒤에 fetchJobCardDatas 호출
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.fetchJobCardDatas()
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
    
    private func fetchJobCardDatas() {
        homeProviders.request(.getHome(sortBy: "", startYear: filterInfos.startYear ?? 0, startMonth: filterInfos.startMonth ?? 0)) { [weak self] response in
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
}

extension NewHomeViewController: FilterButtonProtocol {
    func filterButtonDidTap() {
        
        let filterSettingVC = FilteringSettingViewController(data: filterInfos)
        
        let fraction = UISheetPresentationController.Detent.custom { _ in self.view.frame.height * 0.8 }
        
        if let sheet = filterSettingVC.sheetPresentationController {
            sheet.detents = [fraction, .large()]
        }
        
        self.present(filterSettingVC, animated: true)
        
        //        filterSettingVC.hidesBottomBarWhenPushed = true
        //        self.navigationController?.pushViewController(filterSettingVC, animated: true)
        //        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
}

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
}

// MARK: - Network

extension NewHomeViewController {
    func getMyPageInfo() {
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
