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
    
    private weak var homeViewController: HomeViewController?
    
    // MARK: - UIComponents
    
    lazy var collectionView: UICollectionView = {
        guard let homeVC = homeViewController else {
            fatalError("homeViewController가 없습니다.")
        }
        let layout = CompositionalLayout.createHomeListLayout(HomeVC: homeVC)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.isScrollEnabled = true
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        
        return collectionView
    }()
    
    private let homeLogoView = UIView().then {
        $0.backgroundColor = .white
    }
    private let homeLogoImage = UIImageView().then {
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
            homeLogoView,
            collectionView,
            gradientLayerView
        )
        
        homeLogoView.addSubview(homeLogoImage)
    }
    
    private func setLayout() {
        homeLogoView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(52.adjustedH)
        }
        
        homeLogoImage.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(24.adjusted)
            $0.centerY.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(homeLogoImage.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide)
        }
        
        gradientLayerView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(215.adjustedH)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(43.adjustedH)
        }
    }
}
