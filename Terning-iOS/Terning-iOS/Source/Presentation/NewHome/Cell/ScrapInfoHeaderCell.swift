//
//  ScrapInfoHeaderCell.swift
//  Terning-iOS
//
//  Created by 김민성 on 7/10/24.
//

import UIKit

import SnapKit
import Then

final class ScrapInfoHeaderCell: UICollectionViewCell {
    
    // MARK: - UIComponents
    
    private let titleLabel = LabelFactory.build(
        text: "곧 마감되는 회원님의 관심공고",
        font: .title1,
        textColor: .terningBlack,
        textAlignment: .left
    ).then {
        $0.numberOfLines = 0
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

extension ScrapInfoHeaderCell {
    
    private func setHierarchy() {
        addSubview(titleLabel)
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(20.adjusted)
        }
    }
}

// MARK: - Methods

extension ScrapInfoHeaderCell {
    func bind(name: String) {
        if name.isEmpty {
            titleLabel.text = "곧 마감되는 회원님의 관심공고"
        } else if name.count > 6 {
            titleLabel.text = "곧 마감되는\n\(name)님의 관심공고"
        } else {
            titleLabel.text = "곧 마감되는 \(name)님의 관심공고"
        }
    }
}
