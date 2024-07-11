//
//  HomeViewController.swift
//  Terning-iOS
//
//  Created by 김민성 on 7/10/24.
//

import UIKit

import SnapKit
import Then

enum HomeSection: Int, CaseIterable {
    case scrap = 0
    case filtering
    case decoration
    case sort
    case jobCard
}

protocol bindFilterSettingDataProtocol {
    func bindFilterSettingData(grade: String?, period: String?, month: String?)
}

class HomeViewController: UIViewController, UICollectionViewDelegate {
    
    // MARK: - Properties
    
    let numberOfSections: Int = 14
    var cardModelItems: [JobCardModel] = JobCardModel.getJobCardData()
    var scrapedAndDeadlineItems: [ScrapedAndDeadlineModel] = ScrapedAndDeadlineModel.getScrapedData()
    
    // MARK: - UIComponents
    
    var rootView = HomeView()
    
    // MARK: - LifeCycles
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegate()
        setRegister()
        
        navigationItem.hidesBackButton = true
    }
}

// MARK: - UI & Layout

extension HomeViewController: UICollectionViewDataSource {
    
    // Section 수 정하기
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numberOfSections
    }
    
    // Header 설정하는 부분
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let section = HomeSection(rawValue: indexPath.section)
        
        switch section {
        case .scrap:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "ScrapInfoHeaderCell",
                for: indexPath) as? ScrapInfoHeaderCell else {
                
                return UICollectionReusableView()
            }
            
            return headerView
            
        case .filtering:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "FilteringHeaderCell",
                for: indexPath) as? FilteringHeaderCell else {
                
                return UICollectionReusableView()
            }
            
            return headerView
            
        default:
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            if rootView.layoutForCheckDeadlineCell || rootView.layoutForNonScrapCell {
                return 1
                
            } else if rootView.hasDueToday {
                return 4
            }
            
            return 0
            
        } else if section == 1 {
            return 1
            
        } else if section == 2 {
            return 1
            
        } else if section == 3 {
            return 1
            
        } else if section == 4 {
            return 10 // 이것도 서버에서 받아오는 데이터에 따라 달라지는 값이므로 magic number는 수정해야함.
            
        } else {
            return 0
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = HomeSection(rawValue: indexPath.section)
        
        switch section {
        case .scrap:
            if !rootView.hasAnyScrap && !rootView.hasDueToday {
                let cell = rootView.collectionView.dequeueReusableCell(withReuseIdentifier: NonScrapInfoCell.className, for: indexPath) as! NonScrapInfoCell
                
                return cell
                
            } else if rootView.hasAnyScrap && rootView.hasDueToday {
                let cell = rootView.collectionView.dequeueReusableCell(withReuseIdentifier: IsScrapInfoViewCell.className, for: indexPath) as! IsScrapInfoViewCell
                
                let model = scrapedAndDeadlineItems[indexPath.row]
                
                cell.bindData(color: model.color, title: model.title)
                
                return cell
                
            } else if rootView.hasAnyScrap && !rootView.hasDueToday {
                let cell = rootView.collectionView.dequeueReusableCell(withReuseIdentifier: CheckDeadlineCell.className, for: indexPath) as! CheckDeadlineCell
                
                return cell
            }
            
            return UICollectionViewCell()
            
        case .filtering:
            let cell = rootView.collectionView.dequeueReusableCell(withReuseIdentifier: FilteringCell.className, for: indexPath) as! FilteringCell
            return cell
            
        case .sort:
            let cell = rootView.collectionView.dequeueReusableCell(withReuseIdentifier: SortButtonCell.className, for: indexPath) as! SortButtonCell
            return cell
            
        case .decoration:
            let cell = rootView.collectionView.dequeueReusableCell(withReuseIdentifier: DecorationCell.className, for: indexPath) as! DecorationCell
            return cell
            
        case .jobCard:
            let cell = rootView.collectionView.dequeueReusableCell(withReuseIdentifier: JobCardScrapedCell.className, for: indexPath) as! JobCardScrapedCell
            
            let model = cardModelItems[indexPath.row]
            
            cell.bindData(coverImage: model.coverImage, daysRemaining: model.daysRemaining, title: model.title, period: model.period)
            
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
    
    // MARK: - register()
    
    private func setRegister() {
        // HeaderCells
        rootView.collectionView.register(
            ScrapInfoHeaderCell.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: ScrapInfoHeaderCell.className
        )
        
        rootView.collectionView.register(
            FilteringHeaderCell.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: FilteringHeaderCell.className
        )
        
        // Cells
        if !rootView.hasAnyScrap {
            rootView.collectionView.register(
                NonScrapInfoCell.self,
                forCellWithReuseIdentifier: NonScrapInfoCell.className
            )
            
        } else if rootView.hasDueToday {
            rootView.collectionView.register(
                IsScrapInfoViewCell.self,
                forCellWithReuseIdentifier: IsScrapInfoViewCell.className
            )
            
        } else if rootView.hasAnyScrap && !rootView.hasDueToday {
            rootView.collectionView.register(CheckDeadlineCell.self, forCellWithReuseIdentifier: CheckDeadlineCell.className)
        }
        
        rootView.collectionView.register(
            FilteringCell.self,
            forCellWithReuseIdentifier: FilteringCell.className
        )
        
        rootView.collectionView.register(
            SortButtonCell.self,
            forCellWithReuseIdentifier: SortButtonCell.className
        )
        
        rootView.collectionView.register(
            DecorationCell.self,
            forCellWithReuseIdentifier: DecorationCell.className
        )
        
        rootView.collectionView.register(
            JobCardScrapedCell.self,
            forCellWithReuseIdentifier: JobCardScrapedCell.className
        )
    }
    
    // MARK: - setDelegate()
    
    private func setDelegate() {
        rootView.collectionView.delegate = self
        rootView.collectionView.dataSource = self
    }
    
    // MARK: - setTarget()
    
    private func setTarget() {
        
    }
    
    // MARK: - button click event
    
    func pushToFilteringSettingView() {
        let filteringSettingView = FilteringSettingViewController()
        self.navigationController?.pushViewController(filteringSettingView, animated: true)
    }
    
    @objc
    func filteringButtonDidTap() {
        pushToFilteringSettingView()
    }
}
