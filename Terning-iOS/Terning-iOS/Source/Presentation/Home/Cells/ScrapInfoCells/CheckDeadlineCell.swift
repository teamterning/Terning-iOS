//
//  CheckDeadlineCell.swift
//  Terning-iOS
//
//  Created by 김민성 on 7/11/24.
//

import UIKit

import SnapKit
import Then

class CheckDeadlineCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    // MARK: - UIComponents
    private let checkDeadlineCard = UIView().then {
        $0.makeBorder(width: 1, color: .grey150, cornerRadius: 5
        )
        $0.backgroundColor =  .white
        $0.layer.applyShadow(color: .black, alpha: 0.25, x: 0, y: 0, blur: 4, spread: 0
        )
    }
    
    private let checkDeadlineCardLabel = LabelFactory.build(
        text: "오늘 마감인 공고가 없어요 \n 캘린더에서 가까운 공고 일정을 확인해보세요",
        font: .detail3,
        textAlignment: .center
    ).then {
        $0.numberOfLines = 2
    }
    
    private let checkDeadlineButton = UIButton().then {
        $0.backgroundColor = .clear
        $0.makeBorder(width: 1, color: .terningMain, cornerRadius: 14)
    }
    
    private let checkDeadlineButtonLabel = LabelFactory.build(
        text: "공고 마감 일정 확인하기",
        font: .button4,
        textColor: .terningMain,
        textAlignment: .center
    )
    
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

extension CheckDeadlineCell {
    private func setHierarchy() {
        contentView.addSubviews(
            checkDeadlineCard,
            checkDeadlineCardLabel,
            checkDeadlineButton,
            checkDeadlineButtonLabel
        )
    }
    
    private func setLayout() {
        checkDeadlineCard.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        checkDeadlineCardLabel.snp.makeConstraints {
            $0.centerX.equalTo(checkDeadlineCard)
            $0.top.equalTo(checkDeadlineCard.snp.top).offset(35)
        }
        
        checkDeadlineButton.snp.makeConstraints {
            $0.top.equalTo(checkDeadlineCardLabel.snp.bottom).offset(5)
            $0.centerX.equalTo(checkDeadlineCard)
            $0.width.equalTo(133)
            $0.height.equalTo(28)
        }
        
        checkDeadlineButtonLabel.snp.makeConstraints {
            $0.centerX.equalTo(checkDeadlineButton)
            $0.centerY.equalTo(checkDeadlineButton)
        }
    }
}
