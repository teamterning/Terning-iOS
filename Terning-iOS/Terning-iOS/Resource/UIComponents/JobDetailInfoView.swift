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
    
    private let titleLabel = UILabel().then {
        $0.font = .body2
        $0.textColor = .grey350
    }
    
    private let descriptionLabel = UILabel().then {
        $0.font = .body3
        $0.textColor = .grey500
    }
    
    // MARK: - initialization
    
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
        self.backgroundColor = .white
        self.titleLabel.text = title
        self.descriptionLabel.text = description
    }
    
    private func setLayout() {
        self.addSubviews(titleLabel, descriptionLabel)
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
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
}
