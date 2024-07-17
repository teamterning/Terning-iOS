//
//  MainHomeView.swift
//  Terning-iOS
//
//  Created by 김민성 on 7/15/24.
//

import UIKit

import SnapKit
import Then

final class MainHomeView: UIView {
    
    // MARK: - Properties
    
    // Section 0에서의 아이템들을 분기 처리하기 위한 테스트 데이터 입니다.
    var hasAnyScrap = true
    var hasDueToday = true
    
    // Section 1에서의 아이템들을 분기 처리하기 위한 테스트 데이터 입니다.
    var testDataForNonJobCard = false
    var testDataForInavailable = false
    
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
    
    private let homeLogo = UIImageView().then {
        $0.image = UIImage(resource: .homeLogo)
    }
    
    let gradientView = UIImageView().then {
        $0.image = UIImage(resource: .gradationBar)
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

extension MainHomeView {
    private func setUI() {
        backgroundColor = .white
        gradientView.isHidden = true
    }
    
    private func setHierarchy() {
        addSubviews(homeLogo, collectionView, gradientView)
    }
    
    private func setLayout() {
        homeLogo.snp.makeConstraints {
            $0.top.equalToSuperview().offset(65)
            $0.leading.equalToSuperview().offset(21)
            $0.width.equalTo(113)
            $0.height.equalTo(27.12)
        }

        collectionView.snp.makeConstraints {
            $0.top.equalTo(homeLogo.snp.bottom).offset(23)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide)
        }
        
        gradientView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(268)
            $0.horizontalEdges.equalToSuperview()
        }
    }
    
    // MARK: - CompositionalLayout
    
    private func makeCollectionViewLayout() -> UICollectionViewCompositionalLayout {
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
                        heightDimension: .absolute(131))
                    
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
                if self.testDataForNonJobCard {
                    let itemSize = NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .absolute(1.0))
                    
                    let item = NSCollectionLayoutItem(layoutSize: itemSize)
                    
                    // Group
                    let groupSize = NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .absolute(387)) // 헤더가 포함된 사이즈여야함.
                    
                    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                    
                    // Section
                    let section = NSCollectionLayoutSection(group: group)
                    
                    let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(104))
                    let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                        layoutSize: headerSize,
                        elementKind: UICollectionView.elementKindSectionHeader,
                        alignment: .top
                    )
                    
                    section.boundarySupplementaryItems = [sectionHeader]
                    section.interGroupSpacing = 12
                    
                    return section
                } else if self.testDataForInavailable {
                    // Item
                    let itemSize = NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .absolute(1.0))
                    
                    let item = NSCollectionLayoutItem(layoutSize: itemSize)
                    
                    // Group
                    let groupSize = NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .absolute(387)) // 헤더가 포함된 사이즈여야함.
                    
                    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                    
                    // Section
                    let section = NSCollectionLayoutSection(group: group)
                    
                    let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(104))
                    let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                        layoutSize: headerSize,
                        elementKind: UICollectionView.elementKindSectionHeader,
                        alignment: .top
                    )
                    
                    section.boundarySupplementaryItems = [sectionHeader]
                    section.interGroupSpacing = 12
                    
                    return section
                } else {
                    // Item
                    let itemSize = NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .absolute(100))
                    
                    let item = NSCollectionLayoutItem(layoutSize: itemSize)
                    
                    // Group
                    let groupSize = NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .absolute(100)) // 헤더가 포함된 사이즈여야함.
                    
                    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                    
                    // Section
                    let section = NSCollectionLayoutSection(group: group)
                    
                    let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(130))
                    let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                        layoutSize: headerSize,
                        elementKind: UICollectionView.elementKindSectionHeader,
                        alignment: .top
                    )
                    
                    sectionHeader.pinToVisibleBounds = true
                    section.boundarySupplementaryItems = [sectionHeader]
                    section.interGroupSpacing = 12
                    section.contentInsets = .init(top: 10, leading: 0, bottom: 0, trailing: 0)
                    
                    return section
                }
            } else {
                return nil
            }
        }
    }
}
