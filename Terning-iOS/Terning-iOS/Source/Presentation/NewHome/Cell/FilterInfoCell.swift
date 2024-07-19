//
//  FilterInfoCell.swift
//  Terning-iOS
//
//  Created by 이명진 on 7/19/24.
//

import UIKit

import SnapKit
import Then

final class FilterInfoCell: UICollectionViewCell {
    
    // MARK: - UIComponents
    
    // 상단 타이틀
    private let subTitleLabel = LabelFactory.build(
        text: "마음에 드는 공고를 스크랩하고 캘린더에서 모아보세요",
        font: .detail2,
        textColor: .terningBlack
    )
    
    private let titleLabel = LabelFactory.build(
        text: "내 계획에 딱 맞는 대학생 인턴 공고",
        font: .title1,
        textColor: .terningBlack
    )
    
    private lazy var titleStack = UIStackView(
        arrangedSubviews: [
            subTitleLabel,
            titleLabel
        ]
    ).then {
        $0.axis = .vertical
        $0.spacing = 5
        $0.alignment = .leading
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

extension FilterInfoCell {
    func setHierarchy() {
        contentView.addSubview(titleStack)
    }
    
    func setLayout() {
        titleStack.snp.makeConstraints {
            $0.top.equalToSuperview().offset(28)
            $0.leading.equalToSuperview().offset(20)
            $0.height.equalTo(40)
        }
    }
}
