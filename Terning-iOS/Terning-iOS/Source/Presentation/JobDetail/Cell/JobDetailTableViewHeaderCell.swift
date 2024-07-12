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
    
    private let titleLabel = LabelFactory.build(
        text: "기업 정보",
        font: .title4,
        textColor: .terningMain,
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
        contentView.backgroundColor = .terningSelect
        contentView.addSubview(titleLabel)
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(6)
            $0.horizontalEdges.equalToSuperview().inset(20)
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
