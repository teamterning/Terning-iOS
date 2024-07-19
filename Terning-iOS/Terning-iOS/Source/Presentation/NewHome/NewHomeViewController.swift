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
    case TodayDeadlineUserInfo
    case TodayDeadline
    case homeHeader
    case filterInfo
    case sortButton
    case jobCard
    
    var numberOfItemsInSection: Int {
        switch self {
        case .TodayDeadlineUserInfo, .homeHeader, .filterInfo, .sortButton:
            return 1
        case .TodayDeadline, .jobCard:
            return 0
        }
    }
}

final class NewHomeViewController: UIViewController {
    
    // MARK: - Properties
    
    private let homeProviders = Providers.homeProvider
    private let filterProviders = Providers.filtersProvider
    
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
        case .TodayDeadlineUserInfo, .homeHeader, .filterInfo, .sortButton:
            return section.numberOfItemsInSection
        case .TodayDeadline:
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
        case .TodayDeadlineUserInfo:
            guard let cell = rootView.collectionView.dequeueReusableCell(withReuseIdentifier: ScrapInfoHeaderCell.className, for: indexPath) as? ScrapInfoHeaderCell else { return UICollectionViewCell() } // 오늘 마감되는 남지우님의 마감공고
            return cell
            
        case .TodayDeadline:
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
            if isNoneData {
                guard let cell = rootView.collectionView.dequeueReusableCell(withReuseIdentifier: InavailableFilterView.className, for: indexPath) as? InavailableFilterView else { return UICollectionViewCell() }
                return cell
            } else if jobCardLists.isEmpty {
                guard let cell = rootView.collectionView.dequeueReusableCell(withReuseIdentifier: NonJobCardCell.className, for: indexPath) as? NonJobCardCell else { return UICollectionViewCell() }
                return cell
            } else {
                guard let cell = rootView.collectionView.dequeueReusableCell(withReuseIdentifier: JobCardScrapedCell.className, for: indexPath) as? JobCardScrapedCell else { return UICollectionViewCell() }
                cell.bindData(model: jobCardLists[indexPath.row])
                return cell
            }
        }
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
                        self.fetchJobCardDatas()
                        
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
        
        filterSettingVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(filterSettingVC, animated: true)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
}
