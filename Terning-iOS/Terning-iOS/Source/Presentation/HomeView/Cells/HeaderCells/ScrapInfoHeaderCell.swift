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
    
    let headerIdentifier1 = "ScrapInfoHeaderCell"
    
    // MARK: - UIComponents
    
    let titleLabel = LabelFactory.build(text: "오늘 마감되는 남지우님의 관심공고", font: .title1, textColor: .terningBlack)
    // "남지우" 라고 되어있는 name을 따로 받아야함.
    
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

// MARK: - Extensions

extension ScrapInfoHeaderCell {
    
    func setHierarchy() {
        addSubviews(titleLabel)
    }
    
    func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
        }
    }
}

