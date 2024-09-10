//
//  ProfileImageView.swift
//  Terning-iOS
//
//  Created by 정민지 on 7/17/24.
//

import UIKit

import SnapKit
import Then

final class ProfileImageView: UIView {
    
    // MARK: - UIProperty
    
    private let layout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.minimumInteritemSpacing = 14
        $0.minimumLineSpacing = 9
    }
    
    // MARK: - UI Components
    
    private let notchView = UIView().then {
        $0.backgroundColor = .grey300
        $0.layer.cornerRadius = 2.adjustedH
    }
    
    private let titleLabel = LabelFactory.build(
        text: "프로필 이미지 선택",
        font: .title2,
        textAlignment: .left
    )
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).then {
        $0.backgroundColor = .white
        $0.isScrollEnabled = false
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout
    
extension ProfileImageView {
    private func setUI() {
        backgroundColor = .white
        addSubviews(
            notchView,
            titleLabel,
            collectionView
        )
    }
                    
    private func setLayout() {
        notchView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12.adjustedH)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(4.adjustedH)
            $0.width.equalTo(60.adjusted)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(notchView.snp.bottom).offset(16.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(28.adjusted)
            $0.bottom.lessThanOrEqualTo(collectionView.snp.top).offset(-19.adjustedH)
        }
        
        collectionView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(38.adjusted)
            $0.height.equalTo(194.adjustedH)
            $0.bottom.equalToSuperview().inset(57.adjustedH)
        }
    }
}
