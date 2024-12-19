//
//  StickyHeaderCell.swift
//  Terning-iOS
//
//  Created by 이명진 on 12/19/24.
//

import UIKit

import SnapKit
import Then

final class StickyHeaderCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    private var count: Int = 0
    
    // MARK: - UIComponents
    
    private let titleLabel = LabelFactory.build(
        text: "곧 마감되는 회원님의 관심 공고",
        font: .title1,
        textColor: .terningBlack,
        textAlignment: .left
    ).then {
        $0.numberOfLines = 0
    }
    
    private lazy var FilterButton: UIButton = MainFilterButton()
    private lazy var sortButton: UIButton = MainSortButton()
    
    private let totalCountLabel = LabelFactory.build(font: .body3)
    
    private lazy var HStackView: UIStackView = UIStackView(
        arrangedSubviews: [
            sortButton,
            FilterButton
        ]
    ).then {
        $0.axis = .horizontal
        $0.spacing = 8.adjusted
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

extension StickyHeaderCell {
    
    private func setHierarchy() {
        addSubviews(
            titleLabel,
            totalCountLabel,
            HStackView
        )
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(24.adjusted)
        }
        
        totalCountLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(21.adjustedH)
            $0.leading.equalToSuperview().offset(26.adjusted)
        }
        
        HStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(15.adjustedH)
            $0.leading.equalTo(totalCountLabel.snp.trailing).offset(54.adjusted)
            $0.height.equalTo(30.adjustedH)
        }
        
        sortButton.snp.makeConstraints {
            $0.width.equalTo(132.adjusted)
        }
        
        FilterButton.snp.makeConstraints {
            $0.width.equalTo(80.adjusted)
        }
    }
    
    func bind(name: String) {
        if name.count > 6 {
            titleLabel.text = "\(name)님에게 \n딱 맞는 대학생 인턴 공고"
        } else {
            titleLabel.text = "\(name)님에게 딱 맞는 대학생 인턴 공고"
        }
        
        totalCountLabel.text = "총 \(count)개"
    }
}
