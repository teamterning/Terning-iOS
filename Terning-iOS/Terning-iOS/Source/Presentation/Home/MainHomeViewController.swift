//
//  MainHomeViewController.swift
//  Terning-iOS
//
//  Created by 김민성 on 7/15/24.
//

import UIKit

import SnapKit
import Then

enum HomeSection: Int, CaseIterable {
    case scrap = 0
    case jobCard
}

protocol bindFilterSettingDataProtocol {
    func bindFilterSettingData(grade: String?, period: String?, month: String?)
}

final class MainHomeViewController: UIViewController, UICollectionViewDelegate {
    
    // MARK: - Properties
    
    private let scrollView = UIScrollView()
    
    private let numberOfSections: Int = 2
    private var cardModelItems: [JobCardModel] = JobCardModel.getJobCardData()
    private var scrapedAndDeadlineItems: [ScrapedAndDeadlineModel] = ScrapedAndDeadlineModel.getScrapedData()
    
    // MARK: - UIComponents
    
    private let rootView = MainHomeView()
    
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

extension MainHomeViewController: UICollectionViewDataSource {
    
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
            
        case .jobCard:
            if rootView.testDataForNonJobCard {
                guard let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: NonJobCardHeaderCell.className,
                    for: indexPath) as? NonJobCardHeaderCell else {
                    return UICollectionReusableView()
                }
                
                headerView.backgroundColor = .white
                headerView.filtetButtonDelegate = self

                return headerView
            } else if rootView.testDataForInavailable {
                guard let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: NonJobCardHeaderCell.className,
                    for: indexPath) as? NonJobCardHeaderCell else {
                    return UICollectionReusableView()
                }
                
                headerView.backgroundColor = .white
                headerView.filtetButtonDelegate = self
                
                return headerView
            } else {
                guard let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: FilterHeaderCell.className,
                    for: indexPath) as? FilterHeaderCell else {
                    return UICollectionReusableView()
                }
                
                headerView.backgroundColor = .white
                headerView.filtetButtonDelegate = self

                return headerView
                
            }
        
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
            if rootView.testDataForNonJobCard || rootView.testDataForInavailable {
                return 1
                
            } else {
                return 10
            }
            
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = HomeSection(rawValue: indexPath.section)
        
        switch section {
        case .scrap:
            if !rootView.hasAnyScrap && !rootView.hasDueToday {
                guard let cell = rootView.collectionView.dequeueReusableCell(
                    withReuseIdentifier: NonScrapInfoCell.className,
                    for: indexPath
                ) as? NonScrapInfoCell else {
                    return UICollectionViewCell()
                }
                
                return cell
                
            } else if rootView.hasAnyScrap && rootView.hasDueToday {
                guard let cell = rootView.collectionView.dequeueReusableCell(
                    withReuseIdentifier: IsScrapInfoViewCell.className,
                    for: indexPath
                ) as? IsScrapInfoViewCell else {
                    return UICollectionViewCell()
                }
                let model = scrapedAndDeadlineItems[indexPath.row]
                cell.bindData(color: model.color, title: model.title)
                
                return cell
                
            } else if rootView.hasAnyScrap && !rootView.hasDueToday {
                guard let cell = rootView.collectionView.dequeueReusableCell(
                    withReuseIdentifier: CheckDeadlineCell.className,
                    for: indexPath
                ) as? CheckDeadlineCell else {
                    return UICollectionViewCell()
                }
                
                return cell
            }
            
        case .jobCard:
            if rootView.testDataForNonJobCard {
                guard let cell = rootView.collectionView.dequeueReusableCell(
                    withReuseIdentifier: NonJobCardCell.className,
                    for: indexPath
                ) as? NonJobCardCell else {
                    return UICollectionViewCell()
                }
                
                return cell
                
            } else if rootView.testDataForInavailable {
                guard let cell = rootView.collectionView.dequeueReusableCell(
                    withReuseIdentifier: InavailableFilterView.className,
                    for: indexPath
                ) as? InavailableFilterView else {
                    return UICollectionViewCell()
                }
                
                return cell
            
            } else {
                guard let cell = rootView.collectionView.dequeueReusableCell(
                    withReuseIdentifier: JobCardScrapedCell.className,
                    for: indexPath
                ) as? JobCardScrapedCell else {
                    return UICollectionViewCell()
                }
                
                let model = cardModelItems[indexPath.row]
                cell.bindData(coverImage: model.coverImage, daysRemaining: model.daysRemaining, title: model.title, period: model.period)
                
                return cell
            }
            
        case .none:
            return UICollectionViewCell()
        }
        return UICollectionViewCell()
    }
    
    // MARK: - register()
    
    private func setRegister() {
        // HeaderCells
        rootView.collectionView.register(
            ScrapInfoHeaderCell.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: ScrapInfoHeaderCell.className
        )
        
        if rootView.testDataForNonJobCard {
            rootView.collectionView.register(
                NonJobCardHeaderCell.self,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: NonJobCardHeaderCell.className
            )
        } else if rootView.testDataForInavailable {
            rootView.collectionView.register(
                NonJobCardHeaderCell.self,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: NonJobCardHeaderCell.className
            )
        } else {
            rootView.collectionView.register(
                FilterHeaderCell.self,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: FilterHeaderCell.className
            )
        }
        
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
            rootView.collectionView.register(
                CheckDeadlineCell.self,
                forCellWithReuseIdentifier: CheckDeadlineCell.className
            )
        }
        
        if rootView.testDataForNonJobCard {
            rootView.collectionView.register(
                NonJobCardCell.self,
                forCellWithReuseIdentifier: NonJobCardCell.className
            )
        } else if rootView.testDataForInavailable {
            rootView.collectionView.register(
                InavailableFilterView.self,
                forCellWithReuseIdentifier: InavailableFilterView.className
            )
        } else {
            rootView.collectionView.register(
                JobCardScrapedCell.self,
                forCellWithReuseIdentifier: JobCardScrapedCell.className
            )
        }
    }
    
    // MARK: - setDelegate()
    
    private func setDelegate() {
        rootView.collectionView.delegate = self
        rootView.collectionView.dataSource = self
    }
}

// MARK: - Methods

extension MainHomeViewController: FilteringButtonDidTapProtocol {
    func filteringButtonTapped() {
        let filteringSettingView = FilteringSettingViewController()
        filteringSettingView.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(filteringSettingView, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let cellIndexPath = IndexPath(item: 0, section: 1)
        if let cell = rootView.collectionView.cellForItem(at: cellIndexPath) {
            let cellFrameInSuperview = rootView.collectionView.convert(cell.frame, to: rootView.collectionView.superview)
            
            if cellFrameInSuperview.origin.y <= view.safeAreaInsets.top + 210 {
                rootView.gradientView.isHidden = false
            } else {
                rootView.gradientView.isHidden = true
            }
        }
    }
}
