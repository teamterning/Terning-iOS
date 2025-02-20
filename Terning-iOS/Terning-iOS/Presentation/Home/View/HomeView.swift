//
//  HomeView.swift
//  Terning-iOS
//
//  Created by 이명진 on 12/19/24.
//

import UIKit

import SnapKit
import Then

final class HomeView: UIView {
    
    // MARK: - Properties
    
    var hasScrapped: Bool = false
    var soonData: [AnnouncementModel] = []
    var userName: String = ""
    
    // MARK: - UIComponents
    
    lazy var collectionView: UICollectionView = {
        
        let layout = CompositionalLayout.createHomeCollectionViewLayout(hasScrapped: hasScrapped, soonData: soonData, userName: userName)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.isScrollEnabled = true
        collectionView.backgroundColor = .clear
        
        return collectionView
    }()
    
    private let homeLogoView = UIView().then {
        $0.backgroundColor = .white
    }
    private let homeLogoImage = UIImageView().then {
        $0.image = UIImage(resource: .homeLogo)
    }
    
    private let emptyView = EmptyView()
    
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

extension HomeView {
    private func setUI() {
        gradientLayerView.isHidden = true
        
        homeEmptyViewSetting()
    }
    
    private func setHierarchy() {
        addSubviews(
            homeLogoView,
            collectionView,
            emptyView,
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
            $0.top.equalToSuperview().offset(176.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(8.adjusted)
            $0.height.equalTo(43.adjustedH)
        }
        
        emptyView.snp.makeConstraints {
            $0.width.equalTo(327.adjusted)
            $0.height.equalTo(258.adjustedH)
            $0.top.equalToSuperview().offset(380.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(24.adjusted)
        }
    }
    
    private func homeEmptyViewSetting() {
        emptyView.emptyImage.image = .imgNonCardViewInfo
        emptyView.emptyLabel.text = "아직 채용중인 인턴 공고가 없어요!\n새로운 공고가 올라오면 보여드릴게요"
    }
    
    func updateLayout(hasScrapped: Bool, soonData: [AnnouncementModel], userName: String) {
        self.hasScrapped = hasScrapped
        self.soonData = soonData
        self.userName = userName
        
        // 새로운 레이아웃 생성 및 적용
        
        DispatchQueue.main.async { [weak self] in
            let newLayout = CompositionalLayout.createHomeCollectionViewLayout(hasScrapped: hasScrapped, soonData: soonData, userName: userName)
            self?.collectionView.collectionViewLayout = newLayout
            self?.collectionView.reloadData()
        }
    }
    
    func emptyViewHidden(hidden: Bool) {
        self.emptyView.isHidden = hidden
    }
}
