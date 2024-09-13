//
//  JobDetailInfoView.swift
//  Terning-iOS
//
//  Created by 이명진 on 7/7/24.
//

import UIKit

import SnapKit
import Then

final class JobDetailInfoView: UIView {
    
    // MARK: - UI Components
    
    private let titleLabel = LabelFactory.build(
        text: " ",
        font: .body2,
        textColor: .grey400,
        lineSpacing: 1.2,
        characterSpacing: 0.002
    )
    
    private let descriptionLabel = LabelFactory.build(
        text: " ",
        font: .body3,
        textColor: .grey375,
        lineSpacing: 1.2,
        characterSpacing: 0.002
    )
    
    // MARK: - Init
    
    init(title: String, description: String) {
        super.init(frame: .zero)
        
        self.setUI(title: title, description: description)
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension JobDetailInfoView {
    private func setUI(title: String, description: String) {
        self.backgroundColor = .clear
        self.titleLabel.text = title
        self.descriptionLabel.text = description
    }
    
    private func setLayout() {
        self.addSubviews(titleLabel, descriptionLabel)
        
        titleLabel.snp.makeConstraints {
            $0.verticalEdges.leading.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(titleLabel.snp.trailing).offset(12)
            $0.trailing.greaterThanOrEqualToSuperview()
        }
    }
}

// MARK: - Methods

extension JobDetailInfoView {
    @discardableResult
    func setDescriptionText(description: String) -> Self {
        self.descriptionLabel.text = description
        return self
    }
    
    @discardableResult
    func setTitleTextColor(titleColor: UIColor, descriptionColor: UIColor) -> Self {
        self.titleLabel.textColor = titleColor
        self.descriptionLabel.textColor = descriptionColor
        return self
    }
}
