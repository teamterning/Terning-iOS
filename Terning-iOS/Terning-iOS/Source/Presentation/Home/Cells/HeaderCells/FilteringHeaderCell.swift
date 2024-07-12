//
//  FilteringHeaderCell.swift
//  Terning-iOS
//
//  Created by 김민성 on 7/10/24.
//

import UIKit

import SnapKit
import Then

class FilteringHeaderCell: UICollectionReusableView {
    
    // MARK: - Properties
    
    // MARK: - UIComponents
    
    var subTitleLabel = LabelFactory.build(text: "마음에 드는 공고를 스크랩하고 캘린더에서 모아보세요", font: .detail2, textColor: .terningBlack)
    
    var titleLabel = LabelFactory.build(text: "내 계획에 딱 맞는 대학생 인턴 공고", font: .title1, textColor: .terningBlack)
    
    lazy var titleStack = UIStackView(
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

extension FilteringHeaderCell {
    
    func setHierarchy() {
        addSubview(titleStack)
    }
    
    func setLayout() {
        titleStack.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.height.equalTo(42)
        }
    }
}
