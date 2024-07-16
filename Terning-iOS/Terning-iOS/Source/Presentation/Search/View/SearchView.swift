//
//  SearchView.swift
//  Terning-iOS
//
//  Created by 정민지 on 7/13/24.
//
import UIKit
import RxSwift
import SnapKit

final class SearchView: UIView {
    
    // MARK: - UIProperty
    
    var advertisement: AdvertisementsModel?
    var viewsNum: [RecommendAnnouncementModel]?
    var scrapsNum: [RecommendAnnouncementModel]?
    
    // MARK: - UI Components
    
    private let navigationView = UIView()
    
    private let logoImageView = UIImageView().then {
        $0.image = .icHomeFill
        $0.contentMode = .scaleAspectFill
        $0.layer.masksToBounds = true
    }
    
    let searchView = CustomSearchView()
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
        guard let section = RecomandType(rawValue: sectionIndex) else { return nil }
        switch section {
        case .advertisement:
            return SearchView.createAdvertisementSection(using: layoutEnvironment)
        case .viewsNum, .scrapsNum:
            return SearchView.createRecommendSection()
        }
    }).then {
        $0.isScrollEnabled = false
    }
    
    let pageControl = UIPageControl().then {
        $0.currentPage = 0
        $0.pageIndicatorTintColor = .white
        $0.currentPageIndicatorTintColor = .terningMain
        $0.isUserInteractionEnabled = false
    }
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
        self.backgroundColor = .white
        
        setUI()
        setHierarchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension SearchView {
    private func setUI() {
        collectionView.register(AdvertisementCollectionViewCell.self,
                                forCellWithReuseIdentifier: AdvertisementCollectionViewCell.className)
        collectionView.register(RecommendCollectionViewCell.self,
                                forCellWithReuseIdentifier: RecommendCollectionViewCell.className)
        collectionView.register(SearchCollectionViewHeaderCell.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: SearchCollectionViewHeaderCell.className)
    }
    
    private func setHierarchy() {
        self.addSubviews(
            navigationView,
            logoImageView,
            searchView,
            collectionView,
            pageControl
        )
    }
    
    private func setLayout() {
        navigationView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(94)
        }
        
        logoImageView.snp.makeConstraints {
            $0.centerY.equalTo(navigationView.snp.centerY)
            $0.leading.equalToSuperview().inset(21)
            $0.height.equalTo(36)
            $0.width.equalTo(156)
        }
        searchView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom).offset(6)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        collectionView.snp.makeConstraints {
            $0.top.equalTo(searchView.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(50)
        }
        pageControl.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.top).offset(78)
            $0.centerX.equalToSuperview()
        }
    }
}

// MARK: - UICollectionViewCompositionalLayout

extension SearchView {
    private static func createAdvertisementSection(using environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(108)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(108)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 7, trailing: 0)
        
        return section
    }
    
    private static func createRecommendSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(140),
            heightDimension: .absolute(136)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 12)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(140),
            heightDimension: .absolute(136)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 0)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .estimated(63))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
}
