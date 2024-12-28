//
//  NewHomeViewController.swift
//  Terning-iOS
//
//  Created by 이명진 on 12/19/24.
//

import UIKit

import SnapKit
import Then

enum MainSection: Int, CaseIterable {
    case title
    case soonDeadlineCard
    case jobCard
}

final class NewHomeViewController: UIViewController {
    
    // MARK: - UIComponents
    
    private var hasScrapped: Bool = true {
        didSet {
            rootView.updateLayout(hasScrapped: hasScrapped, soonData: sectionTwoData, userName: userName)
        }
    }
    
    private var sectionTwoData: [AnnouncementModel] = UpcomingCardModel.mockDataHasScrappedYesAnnouncement() {
        didSet {
            rootView.updateLayout(hasScrapped: hasScrapped, soonData: sectionTwoData, userName: userName)
        }
    }
    
    private var userName: String = "여섯글자넘음ㅋ" {
        didSet {
            rootView.updateLayout(hasScrapped: hasScrapped, soonData: sectionTwoData, userName: userName)
        }
    }
    
    private lazy var rootView = NewHomeView(hasScrapped: hasScrapped, soonData: sectionTwoData, userName: userName)
    
    // MARK: - Life Cycles
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setDelegate()
        setRegister()
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
        
        rootView.collectionView.register(ScrapInfoHeaderCell.self, forCellWithReuseIdentifier: ScrapInfoHeaderCell.className)
        
        rootView.collectionView.register(StickyHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: StickyHeaderCell.className)
        
        rootView.collectionView.register(JobCardCell.self, forCellWithReuseIdentifier: JobCardCell.className)
    }
}

// MARK: - UICollectionViewDelegate

extension NewHomeViewController: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDataSource

extension NewHomeViewController: UICollectionViewDataSource {
    
    // 섹션 수 설정
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
            
            headerView.bind(name: self.userName)
            headerView.backgroundColor = .white
            
            return headerView
            
        default:
            return UICollectionReusableView()
        }
    }
    
    // 섹션별 아이템 수 설정
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
            return 10
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
                    return cell
                } else {
                    // 스크랩 상태가 true이고 데이터가 있을 경우
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ClosingJobAnnouncementCell.className, for: indexPath) as? ClosingJobAnnouncementCell else {
                        return UICollectionViewCell()
                    }
                    cell.bindData(model: sectionTwoData[indexPath.row])
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
            return cell
        }
    }
}
