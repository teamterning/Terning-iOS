//
//  HomeTopCell.swift
//  Terning-iOS
//
//  Created by 이명진 on 12/19/24.
//

import UIKit

import SnapKit
import Then

final class HomeTopCell: UICollectionViewCell {
    
    // MARK: - UIComponents
    
    private let titleLabel = LabelFactory.build(
        text: "곧 마감되는 관심 공고",
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

extension HomeTopCell {
    private func setHierarchy() {
        backgroundColor = .white
        contentView.addSubview(titleLabel)
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(24.adjusted)
        }
    }
}
