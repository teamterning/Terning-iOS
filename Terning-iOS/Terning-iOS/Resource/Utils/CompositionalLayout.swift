//
//  CompositionalLayout.swift
//  Terning-iOS
//
//  Created by 이명진 on 7/13/24.
//

import UIKit

struct CompositionalLayout {
    
    static func createCalendarBottomLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionNumber, _) -> NSCollectionLayoutSection? in
            
            if sectionNumber == 0 {
                let item = NSCollectionLayoutItem(
                    layoutSize: .init(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .absolute(100)
                    )
                )
                
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
                
                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: .init(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .absolute(100)
                    ),
                    subitems: [item]
                )
                
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 12
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 12, trailing: 0)
                
                let headerSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(42)
                )
                let header = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerSize,
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top
                )
                
                header.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0)
                section.boundarySupplementaryItems = [header]
                
                return section
                
            } else {
                return nil
            }
        }
    }
    
    static func createCalendarListLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (_, _) -> NSCollectionLayoutSection? in
            
            let item = NSCollectionLayoutItem(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(100)
                )
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
            
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(100)
                ),
                subitems: [item]
            )
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 12 // 그룹 간의 간격 설정
            
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(52)
            )
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            
            header.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0)
            
            let footerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(4)
            )
            let footer = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: footerSize,
                elementKind: UICollectionView.elementKindSectionFooter,
                alignment: .bottom
            )
            
            section.boundarySupplementaryItems = [header, footer]
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 12, trailing: 0)
            
            return section
        }
    }
    
    static func createHomeListLayout(HomeVC: HomeViewController) -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionNumber, _) -> NSCollectionLayoutSection? in
            
            // TEST: - HomeViewController에 있는 인스턴스를 잘 가져오는지 테스트 하는 코드
            print("🙆🏻userName: \(HomeVC.userName)🙆🏻")
            print("🙆🏻existIsScrapped: \(HomeVC.hasScrapped)🙆🏻")
            
            if sectionNumber == 0 {
                let item = NSCollectionLayoutItem(
                    layoutSize: .init(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .fractionalHeight(1)
                    )
                )
                
                if HomeVC.userName.count > 6 {
                    let group = NSCollectionLayoutGroup.horizontal(
                        layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(48)),
                        subitems: [item]
                    )
                    
                    let section = NSCollectionLayoutSection(group: group)
                    section.contentInsets = .init(top: 0, leading: 0, bottom: 16, trailing: 0)
                    
                    return section
                    
                } else {
                    let group = NSCollectionLayoutGroup.horizontal(
                        layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(24)),
                        subitems: [item])
                    
                    let section = NSCollectionLayoutSection(group: group)
                    section.contentInsets = .init(top: 0, leading: 0, bottom: 16, trailing: 0)
                    
                    return section
                }
                
            } else if sectionNumber == 1 {
                
                if HomeVC.upcomingCardLists.isEmpty {
                    let itemWidth: CGFloat = 327.adjusted
                    
                    let item = NSCollectionLayoutItem(
                        layoutSize: .init(
                            widthDimension: .absolute(itemWidth),
                            heightDimension: .fractionalHeight(1)
                        )
                    )
                    
                    let groupHeight: CGFloat = 116.adjustedH
                    
                    let group = NSCollectionLayoutGroup.horizontal(
                        layoutSize: .init(
                            widthDimension: .fractionalWidth(1.0),
                            heightDimension: .absolute(groupHeight)
                        ), subitems: [item]
                    )
                    
                    let section = NSCollectionLayoutSection(group: group)
                    section.contentInsets = .init(top: 0, leading: 24, bottom: 20, trailing: 0)
                    
                    return section
                    
                } else {
                    let itemWidth: CGFloat = 246.adjusted
                    
                    let item = NSCollectionLayoutItem(
                        layoutSize: .init(
                            widthDimension: .absolute(itemWidth),
                            heightDimension: .fractionalHeight(1)
                        )
                    )
                    
                    let groupHeight: CGFloat = 116.adjustedH
                    
                    let group = NSCollectionLayoutGroup.horizontal(
                        layoutSize: .init(
                            widthDimension: .estimated(itemWidth),
                            heightDimension: .absolute(groupHeight)
                        ),
                        subitems: [item]
                    )
                    
                    let section = NSCollectionLayoutSection(group: group)
                    
                    section.contentInsets = .init(top: 0, leading: 24, bottom: 20, trailing: 24)
                    section.interGroupSpacing = 20
                    
                    section.orthogonalScrollingBehavior = .continuous
                    
                    return section
                }
                
            } else if sectionNumber == 2 {
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(100.adjustedH))
                
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                // Group
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(100.adjustedH)) // 헤더가 포함된 사이즈여야함.
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                // Section
                let section = NSCollectionLayoutSection(group: group)
                
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(114.adjustedH))
                let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerSize,
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top
                )
                
                sectionHeader.pinToVisibleBounds = true
                section.boundarySupplementaryItems = [sectionHeader]
                section.interGroupSpacing = 12
                section.contentInsets = .init(top: 4, leading: 0, bottom: 20, trailing: 0)
                
                return section
            } else {
                return nil
            }
        }
    }
    
    static func createRecommendLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionNumber, _) -> NSCollectionLayoutSection? in
            
            if sectionNumber == 0 || sectionNumber == 1 {
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .absolute(140.adjusted),
                    heightDimension: .absolute(136.adjustedH)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 12.adjusted)
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .absolute(140.adjusted),
                    heightDimension: .absolute(136.adjustedH)
                )
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 24.adjusted, bottom: 0, trailing: 0)
                
                let headerSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(63.adjustedH)
                )
                let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerSize,
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top
                )
                
                section.boundarySupplementaryItems = [sectionHeader]
                
                return section
                
            } else {
                return nil
            }
        }
    }
    
    static func jobFilterLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { _, _ -> NSCollectionLayoutSection? in
            let interItemSpacing: CGFloat = 17.0
            let numberOfColumns: CGFloat = 3
            
            let totalHorizontalInsets: CGFloat = (numberOfColumns - 1) * interItemSpacing
            let sideInset: CGFloat = 24 * 2
            let availableWidth = UIScreen.main.bounds.width - totalHorizontalInsets - sideInset
            let itemWidth = availableWidth / numberOfColumns
            
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .absolute(itemWidth),
                heightDimension: .absolute(itemWidth)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(itemWidth)
            )
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.interItemSpacing = .fixed(interItemSpacing)
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 20
            
            return section
        }
    }
    
    static func createNewHomeCollectionViewLayout(hasScrapped: Bool, soonData: [AnnouncementModel], userName: String) -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionNumber, _) -> NSCollectionLayoutSection? in
            
            print("호출: 섹션 번호 - \(sectionNumber)")
            if sectionNumber == 0 {
                let item = NSCollectionLayoutItem(
                    layoutSize: .init(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .fractionalHeight(1)
                    )
                )
                
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(46.adjustedH)),
                    subitems: [item]
                )
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = .init(top: 0, leading: 0, bottom: 2.adjustedH, trailing: 0)
                
                return section
                
            } else if sectionNumber == 1 {
                
                if hasScrapped && !soonData.isEmpty {
                    let itemWidth: CGFloat = 246.adjusted
                    
                    let item = NSCollectionLayoutItem(
                        layoutSize: .init(
                            widthDimension: .absolute(itemWidth),
                            heightDimension: .fractionalHeight(1)
                        )
                    )
                    
                    let groupHeight: CGFloat = 116.adjustedH
                    
                    let group = NSCollectionLayoutGroup.horizontal(
                        layoutSize: .init(
                            widthDimension: .estimated(itemWidth),
                            heightDimension: .absolute(groupHeight)
                        ),
                        subitems: [item]
                    )
                    
                    let section = NSCollectionLayoutSection(group: group)
                    
                    section.contentInsets = .init(top: 0, leading: 24, bottom: 20, trailing: 24)
                    section.interGroupSpacing = 20
                    
                    section.orthogonalScrollingBehavior = .continuous
                    
                    return section
                } else {
                    
                    let itemWidth: CGFloat = 327.adjusted
                    
                    let item = NSCollectionLayoutItem(
                        layoutSize: .init(
                            widthDimension: .absolute(itemWidth),
                            heightDimension: .fractionalHeight(1)
                        )
                    )
                    
                    let groupHeight: CGFloat = 116.adjustedH
                    
                    let group = NSCollectionLayoutGroup.horizontal(
                        layoutSize: .init(
                            widthDimension: .fractionalWidth(1.0),
                            heightDimension: .absolute(groupHeight)
                        ), subitems: [item]
                    )
                    
                    let section = NSCollectionLayoutSection(group: group)
                    section.contentInsets = .init(top: 0, leading: 24, bottom: 20, trailing: 0)
                    
                    return section
                }
                
            } else if sectionNumber == 2 {
                
                let item = NSCollectionLayoutItem(
                    layoutSize: .init(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .fractionalHeight(1)
                    )
                )
                
                if userName.count > 6 {
                    
                    // Group
                    let groupSize = NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .absolute(100.adjustedH))
                    
                    let group = NSCollectionLayoutGroup.horizontal(
                        layoutSize: groupSize,
                        subitems: [item]
                    )
                    
                    let section = NSCollectionLayoutSection(group: group)
                    
                    let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(108.adjustedH))
                    let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                        layoutSize: headerSize,
                        elementKind: UICollectionView.elementKindSectionHeader,
                        alignment: .top
                    )
                    
                    sectionHeader.pinToVisibleBounds = true
                    section.boundarySupplementaryItems = [sectionHeader]
                    section.interGroupSpacing = 12.adjustedH
                    section.contentInsets = .init(top: 4, leading: 0, bottom: 12.adjustedH, trailing: 0)
                    
                    return section
                    
                } else {
                    
                    // Group
                    let groupSize = NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .absolute(100.adjustedH))
                    
                    let group = NSCollectionLayoutGroup.horizontal(
                        layoutSize: groupSize,
                        subitems: [item])
                    
                    let section = NSCollectionLayoutSection(group: group)
                    
                    let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(84.adjustedH))
                    let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                        layoutSize: headerSize,
                        elementKind: UICollectionView.elementKindSectionHeader,
                        alignment: .top
                    )
                    
                    sectionHeader.pinToVisibleBounds = true
                    section.boundarySupplementaryItems = [sectionHeader]
                    section.interGroupSpacing = 12.adjustedH
                    section.contentInsets = .init(top: 4, leading: 0, bottom: 12.adjustedH, trailing: 0)
                    
                    return section
                }
            }
            
            return nil
        }
    }
}
