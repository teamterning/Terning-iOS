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
    
    private let titleLable = LabelFactory.build(
        text: "프로필 이미지 선택",
        font: .title2,
        textAlignment: .left
    )
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).then {
        $0.backgroundColor = .white
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
            titleLable,
            collectionView,
            saveButton
        )
    }
                    
    private func setLayout() {
        titleLable.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(4)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(titleLable.snp.bottom).offset(21.33)
            $0.horizontalEdges.equalToSuperview().inset(13.33)
            $0.bottom.equalTo(saveButton.snp.top).offset(21.33)
            
        }
        
        saveButton.snp.makeConstraints {
            $0.bottom.horizontalEdges.equalToSuperview()
            $0.height.equalTo(54)
        }
    }
}
