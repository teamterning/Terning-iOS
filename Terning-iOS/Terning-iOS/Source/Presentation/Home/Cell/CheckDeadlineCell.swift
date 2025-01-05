//
//  CheckDeadlineCell.swift
//  Terning-iOS
//
//  Created by 김민성 on 9/9/24.
//

import UIKit

import SnapKit
import Then

protocol CheckDeadlineCellProtocol {
    func checkDeadlineButtonDidTap()
}

final class CheckDeadlineCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var checkDeadlineDelegate: CheckDeadlineCellProtocol?
    
    // MARK: - UIComponents
    
    private let checkDeadlineCard = UIView().then {
        $0.layer.cornerRadius = 5
        $0.backgroundColor =  .white
        $0.layer.applyShadow(color: .greyShadow, alpha: 1, y: 0)
    }
    
    private let checkDeadlineCardLabel = LabelFactory.build(
        text: "일주일 내에 마감인 공고가 없어요 \n 캘린더에서 스크랩한 공고 일정을 확인해 보세요",
        font: .detail2,
        textColor: .grey400
    ).then {
        $0.numberOfLines = 2
    }
    
    private lazy var checkDeadlineButton = UIButton().then {
        $0.setTitle("공고 마감 일정 확인하기", for: .normal)
        $0.setTitleColor(.terningMain, for: .normal)
        $0.setBackgroundColor(.white, for: .normal)
        $0.setBackgroundColor(.terningPressed, for: .highlighted)
        $0.titleLabel?.font = .button4
        $0.makeBorder(width: 1, color: .terningMain, cornerRadius: 14)
    }
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setHierarchy()
        setLayout()
        setAddTarget()
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
            checkDeadlineButton
        )
    }
    
    private func setLayout() {
        checkDeadlineCard.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        
        checkDeadlineCardLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(26)
            $0.centerX.equalToSuperview()
        }
        
        checkDeadlineButton.snp.makeConstraints {
            $0.top.equalTo(checkDeadlineCardLabel.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(133.adjusted)
            $0.height.equalTo(28.adjustedH)
        }
    }
}

// MARK: - Methods

extension CheckDeadlineCell {
    private func setAddTarget() {
        checkDeadlineButton.addTarget(self, action: #selector(checkDeadlineButtonDidTap), for: .touchUpInside)
    }
}

// MARK: - objc func

extension CheckDeadlineCell {
    @objc func checkDeadlineButtonDidTap() {
        checkDeadlineDelegate?.checkDeadlineButtonDidTap()
    }
}
