//
//  NewHomeViewController.swift
//  Terning-iOS
//
//  Created by 이명진 on 7/19/24.
//

import Foundation

import UIKit
import Then

enum HomaMainSection: Int, CaseIterable {
    case TodayDeadlineUserInfo
    case TodayDeadline
    case homeHeader
    case filterInfo
    
    var numberOfItemsInSection: Int {
        switch self {
        case .TodayDeadlineUserInfo, .homeHeader, .filterInfo:
            return 1
        case .TodayDeadline:
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
        grade: 0,
        workingPeriod: 0,
        startYear: 0,
        startMonth: 0
    ) {
        didSet {
            rootView.collectionView.reloadData()
        }
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
    }
    
}

extension NewHomeViewController: UICollectionViewDelegate {
    
}

extension NewHomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return HomaMainSection.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = HomaMainSection(rawValue: section) else {
            return 0
        }
        
        switch section {
        case .TodayDeadlineUserInfo, .homeHeader, .filterInfo:
            return section.numberOfItemsInSection
        case .TodayDeadline:
            return todayDeadlineLists.isEmpty ? 1 : todayDeadlineLists.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = HomaMainSection(rawValue: indexPath.section) else {
            fatalError("Section 오류")
        }
        
        switch section {
        case .TodayDeadlineUserInfo:
            guard let cell = rootView.collectionView.dequeueReusableCell(withReuseIdentifier: ScrapInfoHeaderCell.className, for: indexPath) as? ScrapInfoHeaderCell else { return UICollectionViewCell() }
            return cell
            
        case .TodayDeadline:
            if todayDeadlineLists.isEmpty {
                guard let cell = rootView.collectionView.dequeueReusableCell(withReuseIdentifier: NonScrapInfoCell.className, for: indexPath) as? NonScrapInfoCell else { return UICollectionViewCell() }
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
            
            cell.bind(model: self.filterInfos)
            return cell
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
