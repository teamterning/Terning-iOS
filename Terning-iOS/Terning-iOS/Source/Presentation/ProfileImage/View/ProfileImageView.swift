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
        $0.minimumInteritemSpacing = 18.66
        $0.minimumLineSpacing = 20
    }
    
    // MARK: - UI Components
    
    private let titleLabel = LabelFactory.build(
        text: "프로필 이미지 선택",
        font: .title2,
        textAlignment: .left
    )
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).then {
        $0.backgroundColor = .white
        $0.isScrollEnabled = false
    }
    
    let saveButton = CustomButton(
        title: "저장하기"
    )
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        backgroundColor = .white
        
        setUI()
        setHierarchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout
    
extension ProfileImageView {
    private func setUI() {

    }
    
    private func setHierarchy() {
        addSubviews(
            titleLabel,
            collectionView,
            saveButton
        )
    }
                    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(15)
            $0.horizontalEdges.equalToSuperview().inset(44)
            $0.bottom.equalTo(saveButton.snp.top).offset(-15)
        }
        
        saveButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(54)
            $0.bottom.equalToSuperview().inset(12)
        }
    }
}
