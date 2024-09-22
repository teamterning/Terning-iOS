//
//  SearchResultView.swift
//  Terning-iOS
//
//  Created by 정민지 on 7/17/24.
//

import UIKit

import RxSwift

import SnapKit

final class SearchResultView: UIView {
    
    // MARK: - Properties
    
    var searchResult: [AnnouncementModel]?
    var sortBySubject = PublishSubject<String>()
    
    // MARK: - UI Components
    
    let navigationBar = CustomNavigationBar(type: .centerTitleWithLeftButton)
    
    let searchView = CustomSearchView()
    
    let searchTitleLabel = LabelFactory.build(
        text: "어떤 공고를\n찾고 계시나요?",
        font: .heading2,
        textColor: .grey500,
        textAlignment: .left
    ).then {
        $0.numberOfLines = 2
    }
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout { [weak self] (sectionIndex, _) -> NSCollectionLayoutSection? in
        guard let section = SearchResultType(rawValue: sectionIndex), let self = self else { return nil }
        
        switch section {
        case .graphic:
            return SearchResultView.createGraphicSection()
        case .search:
            return SearchResultView.createSearchSection(hasResults: self.searchResult?.count ?? 0 > 0)
        case .noSearch:
            return SearchResultView.createNoSearchSection(hasResults: self.searchResult?.count ?? 0 == 0)
        }
    })

    // MARK: - init
    
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

extension SearchResultView {
    private func setUI() {
        navigationBar.setTitle("검색 결과")
        
        collectionView.register(
            JobCardCell.self,
            forCellWithReuseIdentifier: JobCardCell.className
        )
        collectionView.register(
            GraphicCollectionViewCell.self,
            forCellWithReuseIdentifier: GraphicCollectionViewCell.className
        )
        collectionView.register(
            InavailableFilterView.self,
            forCellWithReuseIdentifier: InavailableFilterView.className
        )
        collectionView.register(
            SortHeaderCell.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SortHeaderCell.className
        )
        collectionView.backgroundColor = .white
    }
    
    private func setHierarchy() {
        addSubviews(
            navigationBar,
            searchTitleLabel,
            searchView,
            collectionView
        )
    }
    
    private func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(68)
        }
        
        searchTitleLabel.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(14)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        searchView.snp.makeConstraints {
            $0.top.equalTo(searchTitleLabel.snp.bottom).offset(13)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(searchView.snp.bottom).offset(8)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        
    }
}

// MARK: - Methods

extension SearchResultView {
    func updateLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(68)
        }
        
        searchTitleLabel.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(14)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        searchView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(searchView.snp.bottom).offset(20)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        setNeedsLayout()
    }
}

// MARK: - UICollectionViewCompositionalLayout

extension SearchResultView {
    private static func createGraphicSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    private static func createSearchSection(hasResults: Bool) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(116)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(116)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
      
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0)
        
        if hasResults {
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(28.adjustedH)
            )
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            sectionHeader.pinToVisibleBounds = true
            section.boundarySupplementaryItems = [sectionHeader]
        } else {
            section.boundarySupplementaryItems = []
        }
        
        return section
    }

    private static func createNoSearchSection(hasResults: Bool) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(266.adjustedH)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(266.adjustedH)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        if hasResults {
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(28.adjustedH)
            )
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            sectionHeader.pinToVisibleBounds = true
            section.boundarySupplementaryItems = [sectionHeader]
        } else {
            section.boundarySupplementaryItems = []
        }
        
        return section
    }
}
