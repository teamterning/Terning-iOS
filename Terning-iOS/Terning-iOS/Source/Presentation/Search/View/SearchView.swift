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
    
    // MARK: - Properties
    
    var viewsNum: [RecommendAnnouncement]?
    var scrapsNum: [RecommendAnnouncement]?
    
    // MARK: - UIComponents
    
    private let navigationView = UIView()
    
    private let logoImageView = UIImageView().then {
        $0.image = .homeLogo
        $0.contentMode = .scaleAspectFill
        $0.layer.masksToBounds = true
    }
    
    let searchView = CustomSearchView()
    
    lazy var advertisementCollectionView: UICollectionView = {
        let layout = CompositionalLayout.createAdvertisementLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.backgroundColor = .white
        collectionView.isScrollEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    lazy var recommendedCollectionView: UICollectionView = {
        let layout = CompositionalLayout.createRecommendLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.backgroundColor = .white
        collectionView.isScrollEnabled = false
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    let pageControl = UIPageControl().then {
        $0.currentPage = 0
        $0.pageIndicatorTintColor = UIColor(
            red: 1.0,
            green: 1.0,
            blue: 1.0,
            alpha: 0.5
        )
        $0.currentPageIndicatorTintColor = .terningMain
        $0.isUserInteractionEnabled = false
    }
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
        
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
        self.backgroundColor = .white
    }
    
    private func setHierarchy() {
        self.addSubviews(
            navigationView,
            logoImageView,
            searchView,
            advertisementCollectionView,
            recommendedCollectionView,
            pageControl
        )
    }
    
    private func setLayout() {
        navigationView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(52.adjustedH)
        }
        
        logoImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8.adjustedH)
            $0.leading.equalToSuperview().inset(24.adjusted)
        }
        
        searchView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom).offset(8.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(24.adjusted)
        }
        
        advertisementCollectionView.snp.makeConstraints {
            $0.top.equalTo(searchView.snp.bottom).offset(12.adjustedH)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(108.adjustedH)
        }
        
        recommendedCollectionView.snp.makeConstraints {
            $0.top.equalTo(advertisementCollectionView.snp.bottom).offset(20.adjustedH)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide)
        }
        
        pageControl.snp.makeConstraints {
            $0.top.equalTo(advertisementCollectionView.snp.top).offset(84.adjustedH)
            $0.centerX.equalToSuperview()
        }
    }
}
