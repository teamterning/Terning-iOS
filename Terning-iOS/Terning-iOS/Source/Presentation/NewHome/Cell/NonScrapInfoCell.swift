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
        $0.makeBorder(width: 1, color: .grey150, cornerRadius: 5)
        $0.backgroundColor =  .white
        $0.layer.applyShadow(color: .black, alpha: 0.25, x: 0, y: 0, blur: 4, spread: 0)
    }
    
    private let internshipScrapedStatusLabel = LabelFactory.build(
        text: "오늘 마감인 공고가 없어요",
        font: .detail2,
        textColor: .grey400
    ).then {
        $0.numberOfLines = 2
    }
    
    private let nonTodayDeadlineImage = UIImageView().then {
        $0.image = UIImage(resource: .imgNonDeadline)
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
            $0.verticalEdges.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20)
            
        }
        
        nonTodayDeadlineImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(internshipScrapedStatus.snp.top).offset(30)
            $0.height.width.equalTo(44)
        }

        internshipScrapedStatusLabel.snp.makeConstraints {
            $0.top.equalTo(nonTodayDeadlineImage.snp.bottom).offset(8)
            $0.centerX.equalTo(internshipScrapedStatus)
        }
    }
}
