//
//  NewHomeView.swift
//  Terning-iOS
//
//  Created by 이명진 on 7/19/24.
//

import UIKit

import SnapKit
import Then

final class NewHomeView: UIView {
    
    // MARK: - UIComponents
    
    lazy var collectionView: UICollectionView = {
        let layout = CompositionalLayout.createHomeListLayout()
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
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
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

extension NewHomeView {
    private func setUI() {
        backgroundColor = .white
        gradientView.isHidden = true
    }
    
    private func setHierarchy() {
        addSubviews(
            homeLogo,
            collectionView,
            gradientView
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
        
        gradientView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(245)
            $0.horizontalEdges.equalToSuperview()
        }
    }
}
