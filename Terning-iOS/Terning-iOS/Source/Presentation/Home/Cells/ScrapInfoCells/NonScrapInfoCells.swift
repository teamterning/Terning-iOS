//
//  NotScrapInfoCells.swift
//  Terning-iOS
//
//  Created by 김민성 on 7/10/24.
//

import UIKit

import SnapKit
import Then


class NonScrapInfoCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    // MARK: - UIComponents
    
    // internshipScrapedStatus~ -> 분기처리가 필요한 화면이라 함수화가 필요함
    let internshipScrapedStatus = UIView().then {
        $0.makeBorder(width: 1, color: .grey150, cornerRadius: 5)
        $0.backgroundColor =  .white
        $0.layer.applyShadow(color: .black, alpha: 0.25, x: 0, y: 0, blur: 4, spread: 0)
    }
    
    let internshipScrapedStatusLabel = LabelFactory.build(
        text: "아직 스크랩된 인턴 공고가 없어요! \n 관심 공고를 스크랩하면 마감 당일에 알려드릴게요",
        font: .detail2,
        textColor: .grey400
    ).then {
        $0.numberOfLines = 2
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
            internshipScrapedStatusLabel
        )
    }
    
    private func setLayout() {
        internshipScrapedStatus.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        internshipScrapedStatusLabel.snp.makeConstraints {
            $0.centerY.equalTo(internshipScrapedStatus)
            $0.centerX.equalTo(internshipScrapedStatus)
        }
    }
}
