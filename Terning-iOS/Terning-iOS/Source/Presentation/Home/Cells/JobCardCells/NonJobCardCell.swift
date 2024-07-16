//
//  NonJobCardCell.swift
//  Terning-iOS
//
//  Created by 김민성 on 7/11/24.
//

import UIKit

import SnapKit
import Then

class NonJobCardCell: UICollectionViewCell {
    
    // MARK: - UIComponents
    
    private let emptyJobCard = UIView().then {
        $0.backgroundColor = .white
        $0.makeBorder(width: 1, color: .terningBlack, cornerRadius: 0)
    }
    
    private let descriptionLabel = LabelFactory.build(
        text: "지금 공고 필터링을 설정하고 \n 내 계획에 딱 맞는 대학생 인턴 공고를 추천받아보세요!",
        font: .detail2,
        textColor: .grey500
    ).then {
        $0.numberOfLines = 2
    }
    
    lazy var emptyStackView = UIStackView(
        arrangedSubviews: [
            emptyJobCard,
            descriptionLabel
        ]
    ).then {
        $0.axis = .vertical
        $0.spacing = 20
        $0.alignment = .center
        $0.distribution = .fillProportionally
    }
    
    // MARK: - LifeCycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setHierarchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension NonJobCardCell {
    private func setHierarchy() {
        contentView.addSubviews(
            emptyJobCard,
            descriptionLabel
        )
    }
    
    private func setLayout() {
        emptyJobCard.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.height.equalTo(222)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(emptyJobCard.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
    }
}
