//
//  HomeView.swift
//  Terning-iOS
//
//  Created by 김민성 on 7/10/24.
//

import UIKit

import SnapKit
import Then

class HomeView: UIView {
    
    // MARK: - Properties
    var jobCardDatas = JobCardModel.getJobCardData()
    lazy var jobCardDataCount = jobCardDatas.count
    
    var scrapAndDeadlineCardDatas = ScrapedAndDeadlineModel.getScrapedData()
    lazy var scrapDataCount = scrapAndDeadlineCardDatas.count
    
    var hasAnyScrap = true
    var hasDueToday = false
    
    lazy var layoutForNonScrapCell: Bool = !hasAnyScrap && !hasDueToday
    lazy var layoutForCheckDeadlineCell: Bool = hasAnyScrap && !hasDueToday
    lazy var layoutForIsScrapInfoCell: Bool = hasAnyScrap && hasDueToday
    
    // MARK: - UIComponents
    
    lazy var collectionView: UICollectionView = {
        let layout = makeCollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.isScrollEnabled = true
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        
        return collectionView
    }()
    
    let homeLogo = UILabel().then {
        $0.text = "LOGO"
        $0.textAlignment = .center
        $0.layer.borderColor = UIColor.black.cgColor
        $0.layer.borderWidth = 1
    }
    
    // MARK: - LifeCycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierarchy()
        setLayout()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension HomeView {
    func setUI() {
        backgroundColor = .white
    }
    
    func setHierarchy() {
        addSubviews(homeLogo, collectionView)
    }
    
    func setLayout() {
        homeLogo.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.equalToSuperview().offset(23)
            $0.height.equalTo(36)
            $0.width.equalTo(160)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(homeLogo.snp.bottom).offset(23)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
    // MARK: - CompositionalLayout
    
    func makeCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionNumber, _) -> NSCollectionLayoutSection? in
            if sectionNumber == 0 {
                // Item
                if self.layoutForNonScrapCell || self.layoutForCheckDeadlineCell {
                    let itemSize = NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .fractionalHeight(1.0))
                    
                    let item = NSCollectionLayoutItem(layoutSize: itemSize)
                    
                    // Group
                    let groupSize = NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .absolute(139))
                    
                    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                    
                    group.contentInsets.top = 11
                    
                    // Section
                    let section = NSCollectionLayoutSection(group: group)

                    section.contentInsets.top = 40
                    section.contentInsets.bottom = 25
            
                    section.boundarySupplementaryItems = [
                        NSCollectionLayoutBoundarySupplementaryItem(
                            layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(24)),
                            elementKind: UICollectionView.elementKindSectionHeader,
                            alignment: .none)
                    ]
                    
                    return section
                } else if self.layoutForIsScrapInfoCell {
                    let itemSize = NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(0.5),
                        heightDimension: .fractionalHeight(1.0))
                    
                    let item = NSCollectionLayoutItem(layoutSize: itemSize)
                    
                    item.contentInsets.leading = 12
                    
                    // Group
                    let groupSize = NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(0.8),
                        heightDimension: .absolute(159))
                    
                    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                    
                    group.contentInsets.top = 11
                    
                    // Section
                    let section = NSCollectionLayoutSection(group: group)
                    section.orthogonalScrollingBehavior = .continuous
                    section.contentInsets.top = 23
                    section.contentInsets.bottom = 25
                    
                    section.boundarySupplementaryItems = [
                        NSCollectionLayoutBoundarySupplementaryItem(
                            layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(24)),
                            elementKind: UICollectionView.elementKindSectionHeader,
                            alignment: .none)
                    ]
                    
                    section.contentInsets.leading = 8
                    
                    return section
                }

                return nil
            } else if sectionNumber == 1 { // 필터링하는 부분
                // Item
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0))
                
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                // Group
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(83)) // 헤더가 포함된 사이즈여야함.
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                // Section
                let section = NSCollectionLayoutSection(group: group)
                
                section.contentInsets.bottom = 15
                
                section.boundarySupplementaryItems = [
                    NSCollectionLayoutBoundarySupplementaryItem(
                        layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(42)),
                        elementKind: UICollectionView.elementKindSectionHeader,
                        alignment: .none)
                    ]

                return section
            } else if sectionNumber == 2 { // 화면의 회색 바
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(1.0))
                
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                // Group
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(4))
                
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                
                // Section
                let section = NSCollectionLayoutSection(group: group)
            
                return section
            } else if sectionNumber == 3 { // 정렬 설정하는 버튼
                // Item
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0))
                
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                // Group
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(45))
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                // Section
                let section = NSCollectionLayoutSection(group: group)
                
                return section
            } else if sectionNumber == 4 { // 공고 카드
                // Item
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(2.0/CGFloat(self.jobCardDataCount)))
                
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                // Group
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0))
                
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                
                group.interItemSpacing = .fixed(20)
                
                // Section
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = -28
                return section
            } else {
                return nil
            }
        }
    }
}
