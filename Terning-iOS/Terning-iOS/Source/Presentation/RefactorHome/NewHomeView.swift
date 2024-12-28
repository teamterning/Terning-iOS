//
//  NewHomeView.swift
//  Terning-iOS
//
//  Created by 이명진 on 12/19/24.
//

import UIKit

import SnapKit
import Then

final class NewHomeView: UIView {
    
    // MARK: - Properties
    
    // MARK: - UIComponents
    
    var hasScrapped: Bool = false
    var soonData: [AnnouncementModel] = []
    var userName: String = ""
    
    lazy var collectionView: UICollectionView = {
        
        let layout = CompositionalLayout.createNewHomeCollectionViewLayout(hasScrapped: hasScrapped, soonData: soonData, userName: userName)
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
    
    init(hasScrapped: Bool, soonData: [AnnouncementModel], userName: String) {
        super.init(frame: .zero)
        
        self.hasScrapped = hasScrapped
        self.soonData = soonData
        self.userName = userName
        
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

extension NewHomeView {
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
        
        homeLogoView.backgroundColor = .white
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
            $0.top.equalTo(homeLogoView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide)
        }
        
        gradientLayerView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(215.adjustedH)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(43.adjustedH)
        }
    }
    
    func updateLayout(hasScrapped: Bool, soonData: [AnnouncementModel], userName: String) {
        self.hasScrapped = hasScrapped
        self.soonData = soonData
        self.userName = userName
        
        // 새로운 레이아웃 생성 및 적용
        let newLayout = CompositionalLayout.createNewHomeCollectionViewLayout(hasScrapped: hasScrapped, soonData: soonData, userName: userName)
        collectionView.collectionViewLayout = newLayout
        collectionView.reloadData()
    }
}
