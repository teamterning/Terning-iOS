//
//  SearchCollectionViewHeaderCell.swift
//  Terning-iOS
//
//  Created by 정민지 on 7/14/24.
//

import UIKit

import SnapKit

@frozen
public enum SearchHeaderType {
    case main
    case sub
}

final class SearchCollectionViewHeaderCell: UICollectionReusableView {
    
    // MARK: - Properties
    
    private var searchHeaderType: SearchHeaderType!
    
    // MARK: - UI Components
    
    private let titleLabel = LabelFactory.build(
        text: "요즘 대학생들에게 인기 있는 공고",
        font: .title1,
        textColor: .terningBlack,
        textAlignment: .left,
        lineSpacing: 1.2
    )
    
    private let subTitleLabel = LabelFactory.build(
        font: .body3,
        textColor: .grey400,
        textAlignment: .left,
        lineSpacing: 1.2,
        characterSpacing: 0.002
    )
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension SearchCollectionViewHeaderCell {
    private func setUI() {
        self.addSubviews(titleLabel, subTitleLabel)
    }
    
    private func setLayout(_ type: SearchHeaderType) {
        switch type {
        case .main:
            setMainLayout()
        case .sub:
            setSubLayout()
        }
    }
}

// MARK: - Methods

extension SearchCollectionViewHeaderCell {
    private func setMainLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20.adjustedH)
            $0.horizontalEdges.equalToSuperview()
        }
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4.adjustedH)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(12.adjustedH)
        }
    }
    
    private func setSubLayout() {
        titleLabel.isHidden = true

        subTitleLabel.snp.remakeConstraints {
            $0.top.equalToSuperview().offset(32.adjustedH)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(12.adjustedH)
        }
    }
}

// MARK: - Bind

extension SearchCollectionViewHeaderCell {
    public func bind(title: String?, subTitle: String?, type: SearchHeaderType) {
        self.searchHeaderType = type
        
        titleLabel.text = title
        subTitleLabel.text = subTitle
        
        setLayout(type)
    }
}
