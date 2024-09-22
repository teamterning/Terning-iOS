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
                    heightDimension: .absolute(100))
                
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                // Group
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(100)) // 헤더가 포함된 사이즈여야함.
                
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
                section.interGroupSpacing = 20
                section.contentInsets = .init(top: 10, leading: 0, bottom: 28, trailing: 0)
                
                return section
            } else {
                return nil
            }
        }
    }
}
