//
//  JobCategoryCell.swift
//  Terning-iOS
//
//  Created by 정민지 on 12/17/24.
//

import UIKit

import SnapKit
import Then

final class JobCategoryCell: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let iconImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .grey300
        $0.snp.makeConstraints {
            $0.size.equalTo(24)
        }
    }
    
    private let titleLabel = LabelFactory.build(
        font: .body6,
        textColor: .grey350,
        lineSpacing: 1.2,
        characterSpacing: 0.002
    )
    
    private lazy var stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 7
        $0.alignment = .center
        $0.distribution = .equalSpacing
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierarchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension JobCategoryCell {
    private func setUI() {
        contentView.layer.borderWidth = 1.0
        contentView.layer.cornerRadius = 10
        contentView.layer.borderColor = UIColor.grey200.cgColor
    }
    private func setHierarchy() {
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(titleLabel)
        
        contentView.addSubview(stackView)
    }
    private func setLayout() {
        iconImageView.snp.makeConstraints {
            $0.size.equalTo(24)
        }
        
        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

// MARK: - Methods

extension JobCategoryCell {
    override var isSelected: Bool {
        didSet {
            updateSelectionState()
        }
    }
    
    private func updateSelectionState() {
        if isSelected {
            contentView.layer.borderColor = UIColor.terningMain.cgColor
            titleLabel.textColor = .terningMain
            iconImageView.tintColor = .terningMain
        } else {
            contentView.layer.borderColor = UIColor.grey200.cgColor
            titleLabel.textColor = .grey350
            iconImageView.tintColor = .grey300
        }
    }
}

// MARK: - Bind

extension JobCategoryCell {
    func bind(with title: String, image: UIImage?) {
        titleLabel.text = title
        iconImageView.image = image
    }
}