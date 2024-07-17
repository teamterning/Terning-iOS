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
    
    private let scrollView = UIScrollView()
    
    private let providers = Providers.scrapsProvider
    
    private let numberOfSections: Int = 2
    private var cardModelItems: [JobCardModel] = JobCardModel.getJobCardData()
    private var scrapedAndDeadlineItems: [ScrapedAndDeadlineModel] = ScrapedAndDeadlineModel.getScrapedData()
    private var UserFilteringInfoModelItems: [UserFilteringInfoModel] = UserFilteringInfoModel.getUserFilteringInfo()
    
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
        
        print(UserManager.shared.accessToken)
        
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
                let model = UserFilteringInfoModelItems[indexPath.row]
                headerView.bindData(
                    model: UserFilteringInfoModel(
                        grade: model.grade,
                        workingPeriod: model.workingPeriod,
                        startYear: model.startYear,
                        startMonth: model.startMonth
                    )
                )
                
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
                cell.bindData(
                    model: ScrapedAndDeadlineModel(
                        scrapId: model.scrapId,
                        internshipAnnouncementId: model.internshipAnnouncementId,
                        companyImage: model.companyImage,
                        title: model.title,
                        dDay: model.dDay,
                        deadLine: model.deadLine,
                        workingPeriod: model.workingPeriod,
                        startYearMonth: model.startYearMonth,
                        color: model.color
                    )
                )
                
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
                guard let cell = rootView.collectionView.dequeueReusableCell(withReuseIdentifier: NonJobCardCell.className, for: indexPath) as? NonJobCardCell else {
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
                
                cell.delegate = self
                
                let model = cardModelItems[indexPath.row]
                cell.bindData(
                    model: JobCardModel(
                        internshipAnnouncementId: model.internshipAnnouncementId,
                        title: model.title,
                        dDay: model.dDay,
                        workingPeriod: model.workingPeriod,
                        companyImage: model.companyImage,
                        isScraped: model.isScraped
                    )
                )
                
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

// MARK: - Methods

extension MainHomeViewController: ScrapDidTapDelegate {
    
    func scrapButtonDidTap(id: Double) {
        guard let indexPath = self.indexPath(forInternshipAnnouncementId: id),
              let cell = self.rootView.collectionView.cellForItem(at: indexPath) as? JobCardScrapedCell else {
            return
        }
        
        if cell.scrapButton.isSelected {
            showScrapAlert(id: id, alertType: .normal, cell: cell)
        } else {
            showScrapAlert(id: id, alertType: .custom, cell: cell)
        }
    }
    
    private func showScrapAlert(id: Double, alertType: AlertType, cell: JobCardScrapedCell) {
        let customAlertVC = CustomAlertViewController(alertType: alertType)
        
        if alertType == .custom {
            customAlertVC.centerButtonTapAction = { [weak self] in
                guard let self = self else { return }
                let colorIndex = customAlertVC.selectedColorIndexRelay.value
                self.scrapAnnouncement(internshipAnnouncementId: id, color: colorIndex, cell: cell)
                self.dismiss(animated: false)
            }
        } else if alertType == .normal {
            customAlertVC.setComponentDatas(mainLabel: "관심 공고가 캘린더에서 사라져요!", subLabel: "스크랩을 취소하시겠어요?", buttonLabel: "스크랩 취소하기")
            customAlertVC.centerButtonTapAction = { [weak self] in
                guard let self = self else { return }
                self.cancelScrapAnnouncement(internshipAnnouncementId: id, cell: cell)
                self.dismiss(animated: false)
            }
        }
        
        customAlertVC.modalPresentationStyle = .overFullScreen
        customAlertVC.modalTransitionStyle = .crossDissolve
        
        self.present(customAlertVC, animated: false)
    }
    
    private func scrapAnnouncement(internshipAnnouncementId: Double, color: Int, cell: JobCardScrapedCell) {
        providers.request(.addScrap(internshipAnnouncementId: internshipAnnouncementId, color: color)) { [weak self] result in
            LoadingIndicator.hideLoading()
            guard let self = self else { return }
            switch result {
            case .success(let response):
                let status = response.statusCode
                if 200..<300 ~= status {
                    print("스크랩 성공")
                    cell.updateScrapButton(isSelected: true)
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
    
    private func cancelScrapAnnouncement(internshipAnnouncementId: Double, cell: JobCardScrapedCell) {
        providers.request(.removeScrap(scrapId: internshipAnnouncementId)) { [weak self] result in
            LoadingIndicator.hideLoading()
            guard let self = self else { return }
            switch result {
            case .success(let response):
                let status = response.statusCode
                if 200..<300 ~= status {
                    print("스크랩 취소 성공")
                    cell.updateScrapButton(isSelected: false)
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
    
    private func indexPath(forInternshipAnnouncementId id: Double) -> IndexPath? {
        for (index, model) in cardModelItems.enumerated() where model.internshipAnnouncementId == id {
            return IndexPath(row: index, section: HomeSection.jobCard.rawValue)
        }
        return nil
    }
}
