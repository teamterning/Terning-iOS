//
//  NonScrapInfoCell.swift
//  Terning-iOS
//
//  Created by 김민성 on 7/10/24.
//

import UIKit

import SnapKit
import Then

final class NonScrapInfoCell: UICollectionViewCell {
    
    // MARK: - UIComponents
    
    private let internshipScrapedStatus = UIView().then {
        $0.layer.cornerRadius = 5
        $0.backgroundColor =  .white
        $0.layer.applyShadow(color: .greyShadow, alpha: 0.25, x: 0, y: 0, blur: 4, spread: 0)
    }
    
    private let internshipScrapedStatusLabel = LabelFactory.build(
        text: "아직 스크랩된 인턴 공고가 없어요!",
        font: .detail2,
        textColor: .grey400
    ).then {
        $0.numberOfLines = 2
    }
    
    private let nonTodayDeadlineImage = UIImageView().then {
        $0.image = .imgNonScrap
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

extension NonScrapInfoCell {
    private func setHierarchy() {
        contentView.addSubviews(
            internshipScrapedStatus,
            internshipScrapedStatusLabel,
            nonTodayDeadlineImage
        )
    }
    
    private func setLayout() {
        internshipScrapedStatus.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        
        nonTodayDeadlineImage.snp.makeConstraints {
            $0.top.equalTo(internshipScrapedStatus.snp.top).offset(30)
            $0.centerX.equalTo(internshipScrapedStatus)
            $0.height.width.equalTo(44.adjustedH)
        }
        
        internshipScrapedStatusLabel.snp.makeConstraints {
            $0.top.equalTo(nonTodayDeadlineImage.snp.bottom).offset(8)
            $0.centerX.equalTo(internshipScrapedStatus)
        }
    }
}
