//
//  RecommendCollectionViewCell.swift
//  Terning-iOS
//
//  Created by 정민지 on 7/14/24.
//

import UIKit

import SnapKit
import Then

final class RecommendCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let recommendImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 5
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    private let underLineView = UIView().then {
        $0.backgroundColor = .grey100
    }
    
    private let descriptionLabel = LabelFactory.build(
        font: .button3,
        textColor: .terningBlack,
        textAlignment: .left,
        lineSpacing: 1.2,
        characterSpacing: 0.002
    ).then {
        $0.numberOfLines = 3
        $0.lineBreakMode = .byTruncatingTail
        $0.baselineAdjustment = .alignBaselines
        $0.setContentHuggingPriority(.required, for: .vertical)
    }
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.setUI()
        self.setHierarchy()
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension RecommendCollectionViewCell {
    private func setUI() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 5
        self.layer.applyShadow(
            color: .black,
            alpha: 0.15,
            x: 0,
            y: 0,
            blur: 4,
            spread: 0
        )
    }
    
    private func setHierarchy() {
        self.addSubviews(
            recommendImageView,
            underLineView,
            descriptionLabel
        )
    }
    
    private func setLayout() {
        recommendImageView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(70)
        }
        
        underLineView.snp.makeConstraints {
            $0.top.equalTo(recommendImageView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(2)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(underLineView.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(8)
            $0.bottom.equalToSuperview().inset(7)
            $0.height.equalTo(51)
        }
    }
}

// MARK: - Bind

extension RecommendCollectionViewCell {
    func bind(with data: RecommendAnnouncement) {
        recommendImageView.setImage(with: data.companyImage, placeholder: "placeholder_image")
        descriptionLabel.text = data.title
    }
}
