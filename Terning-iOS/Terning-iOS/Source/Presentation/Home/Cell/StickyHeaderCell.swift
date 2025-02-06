//
//  StickyHeaderCell.swift
//  Terning-iOS
//
//  Created by 이명진 on 12/19/24.
//

import UIKit

import SnapKit
import Then

protocol StickyHeaderCellDelegate: AnyObject {
    func didTapSortButton() // 정렬 버튼 Action
    func didTapFilterButton() // 필터 버튼 Action
}

final class StickyHeaderCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    private var count: Int = 0
    
    weak var delegate: StickyHeaderCellDelegate?
    
    // MARK: - UIComponents
    
    private let titleLabel = LabelFactory.build(
        text: "곧 마감되는 회원님의 관심 공고",
        font: .title1,
        textColor: .terningBlack,
        textAlignment: .left
    ).then {
        $0.numberOfLines = 0
    }
    
    private lazy var filterButton: UIButton = MainFilterButton()
    lazy var sortButton = MainSortButton()
    
    private let totalLabel = LabelFactory.build(
        text: "총",
        font: .body3,
        textColor: .grey400
    )
    
    private let totalCountLabel = LabelFactory.build(
        font: .body4,
        textColor: .terningMain
    )
    
    private let countLabel = LabelFactory.build(
        text: "개",
        font: .body3,
        textColor: .grey400
    )
    
    private lazy var HStackView: UIStackView = UIStackView(
        arrangedSubviews: [
            sortButton,
            filterButton
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
        setAddTarget()
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
            totalLabel,
            totalCountLabel,
            countLabel,
            HStackView
        )
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(24.adjusted)
        }
        
        totalLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(21.adjustedH)
            $0.leading.equalToSuperview().offset(26.adjusted)
        }
        
        totalCountLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(21.adjustedH)
            $0.leading.equalTo(totalLabel.snp.trailing).offset(4.adjusted)
        }
        
        countLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(21.adjustedH)
            $0.leading.equalTo(totalCountLabel.snp.trailing).offset(1.adjusted)
        }
        
        HStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(15.adjustedH)
            $0.trailing.equalToSuperview().offset(-24.adjusted)
            $0.height.equalTo(30.adjustedH)
        }
        
        sortButton.snp.makeConstraints {
            $0.width.equalTo(132.adjusted)
        }
        
        filterButton.snp.makeConstraints {
            $0.width.equalTo(80.adjusted)
        }
    }
    
    private func setAddTarget() {
        filterButton.addTarget(self, action: #selector(filterButtonDidTap), for: .touchUpInside)
        sortButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sortButtonDidTap)))
    }
    
    @objc
    private func filterButtonDidTap() {
        delegate?.didTapFilterButton()
    }
    
    @objc
    private func sortButtonDidTap() {
        delegate?.didTapSortButton()
    }
    
    func bind(totalCount: Int, name: String) {
        if name.count > 6 {
            titleLabel.text = "\(name)님에게 \n딱 맞는 대학생 인턴 공고"
        } else {
            titleLabel.text = "\(name)님에게 딱 맞는 대학생 인턴 공고"
        }
        
        totalCountLabel.text = totalCount >= 999 ? "999+" : "\(totalCount)"
    }
}
