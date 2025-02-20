//
//  JobDetailTableViewHeaderCell.swift
//  Terning-iOS
//
//  Created by 정민지 on 7/12/24.
//

import UIKit

import SnapKit

final class JobDetailTableViewHeaderView: UITableViewHeaderFooterView {
    
    // MARK: - UI Components
    
    private let horizontalStickView = UIView().then {
        $0.backgroundColor = .terningMain
    }
    
    private let titleLabel = LabelFactory.build(
        text: "기업 정보",
        font: .title4,
        textColor: .terningBlack,
        textAlignment: .left
    )
    
    // MARK: - Init
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension JobDetailTableViewHeaderView {
    private func setUI() {
        contentView.backgroundColor = .clear
        contentView.addSubviews(
            horizontalStickView,
            titleLabel
        )
    }
    
    private func setLayout() {
        horizontalStickView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(7.adjustedH)
            $0.leading.equalToSuperview().inset(24.adjusted)
            $0.width.equalTo(2.adjusted)
            $0.bottom.equalToSuperview().inset(6.adjustedH)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(6)
            $0.leading.equalTo(horizontalStickView.snp.trailing).offset(8.adjusted)
            $0.trailing.equalToSuperview().inset(24.adjusted)
            $0.bottom.equalToSuperview().inset(5)
        }
    }
}

// MARK: - Public Methods

extension JobDetailTableViewHeaderView {
    public func setTitle(_ title: String) {
        titleLabel.text = title
    }
}
