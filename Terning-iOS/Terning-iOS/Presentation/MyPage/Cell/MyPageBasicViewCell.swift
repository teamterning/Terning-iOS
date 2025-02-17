//
//  MyPageBasicViewCell.swift
//  Terning-iOS
//
//  Created by 정민지 on 9/7/24.
//

import UIKit

import SnapKit

@frozen
public enum AccessoryType {
    case none
    case disclosureIndicator
    case label(text: String)
}

final class MyPageBasicViewCell: UITableViewCell {
    // MARK: - UI Components
    
    private let profileImageView = UIImageView()
    
    private let titleLabel = LabelFactory.build(
        font: .body5,
        textAlignment: .left
    )
    
    private let accessoryImageView = UIImageView()
    
    private let accessoryLabel = LabelFactory.build(
        font: .body6,
        textColor: .grey350,
        textAlignment: .left
    )
    
    private let horizontalStickView = UIView().then {
        $0.backgroundColor = .grey150
    }
    
    // MARK: - Life Cycles
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension MyPageBasicViewCell {
    private func setUI() {
        contentView.addSubviews(
            profileImageView,
            titleLabel,
            accessoryImageView,
            accessoryLabel,
            horizontalStickView
        )
    }
    
    private func setLayout() {
        
        profileImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16.adjusted)
            $0.verticalEdges.equalToSuperview().inset(20)
            $0.width.equalTo(profileImageView.snp.height)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(8.adjusted)
            $0.centerY.equalToSuperview()
        }
        
        accessoryImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(9.adjusted)
            $0.verticalEdges.equalToSuperview().inset(20)
            $0.width.equalTo(profileImageView.snp.height)
        }
        
        accessoryLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16.adjusted)
            $0.centerY.equalToSuperview()
        }
        
        horizontalStickView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(19.5.adjusted)
            $0.trailing.equalToSuperview().inset(12.5.adjusted)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
}

// MARK: - Methods

extension MyPageBasicViewCell {
    func bind(with viewModel: MyPageBasicCellModel, isLastCellInSection: Bool) {
        profileImageView.image = viewModel.image
        titleLabel.text = viewModel.title
        
        switch viewModel.accessoryType {
        case .none:
            accessoryImageView.isHidden = true
            accessoryLabel.isHidden = true
        case .disclosureIndicator:
            accessoryImageView.image = .icFrontArrow
            accessoryImageView.isHidden = false
            accessoryLabel.isHidden = true
        case .label(let text):
            accessoryLabel.text = text
            accessoryLabel.isHidden = false
            accessoryImageView.isHidden = true
        }

        horizontalStickView.isHidden = isLastCellInSection
    }
}
