//
//  ScrapInfoHeaderCell.swift
//  Terning-iOS
//
//  Created by 김민성 on 7/10/24.
//

import UIKit

import SnapKit
import Then

class ScrapInfoHeaderCell: UICollectionReusableView {
    
    // MARK: - Properties
    
    // MARK: - UIComponents
    
    let titleLabel = LabelFactory.build(
        text: "오늘 마감되는 남지우님의 관심공고",
        font: .title1,
        textColor: .terningBlack
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

extension ScrapInfoHeaderCell {
    
    func setHierarchy() {
        addSubview(titleLabel)
    }
    
    func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
        }
    }
}
