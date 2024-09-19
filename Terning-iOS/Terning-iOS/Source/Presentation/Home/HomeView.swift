//
//  HomeView.swift
//  Terning-iOS
//
//  Created by 이명진 on 7/19/24.
//

import UIKit

import SnapKit
import Then

final class HomeView: UIView {
    
    // MARK: - Properties
    
    private let homeViewController: HomeViewController
    
    // MARK: - UIComponents
    
    lazy var collectionView: UICollectionView = {
        let layout = CompositionalLayout.createHomeListLayout(HomeVC: homeViewController)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.isScrollEnabled = true
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        
        return collectionView
    }()
    
    private let homeLogo = UIImageView().then {
        $0.image = UIImage(resource: .homeLogo)
    }
    
    let gradientLayerView = GradientLayerView()
    
    // MARK: - Life Cycles
    
    init(frame: CGRect, homeViewController: HomeViewController) {
        self.homeViewController = homeViewController
        super.init(frame: frame)
        
        setUI()
        setHierarchy()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - UI & Layout

extension HomeView {
    private func setUI() {
        gradientLayerView.isHidden = true
    }
    
    private func setHierarchy() {
        addSubviews(
            homeLogo,
            collectionView,
            gradientLayerView
        )
    }
    
    private func setLayout() {
        homeLogo.snp.makeConstraints {
            $0.top.equalToSuperview().offset(65)
            $0.leading.equalToSuperview().offset(21)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(homeLogo.snp.bottom).offset(23)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide)
        }
        
        gradientLayerView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(230)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(43.adjustedH)
        }
    }
}
