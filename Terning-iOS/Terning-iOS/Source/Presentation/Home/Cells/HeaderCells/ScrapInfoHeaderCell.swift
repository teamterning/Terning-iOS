//
//  ScrapInfoHeaderCell.swift
//  Terning-iOS
//
//  Created by 김민성 on 7/10/24.
//

import UIKit

import SnapKit
import Then

final class ScrapInfoHeaderCell: UICollectionReusableView {
    
    // MARK: - UIComponents
    
    private let titleLabel = LabelFactory.build(
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
    
    private func setHierarchy() {
        addSubview(titleLabel)
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
        }
    }
    
    // MARK: - Methods
    
    private func setTitleLabel(name: String) {
        if name.count >= 7 {
            titleLabel.text = "오늘 마감되는 \n\(name)님의 관심공고"
            titleLabel.numberOfLines = 2
            titleLabel.textAlignment = .left
        } else if name.count < 7 {
            titleLabel.text = "오늘 마감되는 \(name)님의 관심공고"
            titleLabel.textAlignment = .left
        }
    }
    
    func bind(model: UserProfileInfoModel) {
        setTitleLabel(name: model.name)
    }
}
