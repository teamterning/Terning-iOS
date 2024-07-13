//
//  CompanyInfoTableViewCell.swift
//  Terning-iOS
//
//  Created by 정민지 on 7/12/24.
//

import UIKit

import SnapKit

final class CompanyInfoTableViewCell: UITableViewCell {
    
    // MARK: - UI Components
    
    private let companyImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 30
        $0.layer.masksToBounds = true 
        $0.makeBorder(width: 2, color: .terningMain)
    }
    
    private let companyNameLabel = LabelFactory.build(
        text: "회사명",
        font: .title4,
        textAlignment: .left
    ).then {
        $0.numberOfLines = 2
    }
    
    private let companyTypeLabel = LabelFactory.build(
        text: "스타트업",
        font: .body4,
        textColor: .grey300,
        textAlignment: .left,
        lineSpacing: 1.5,
        characterSpacing: 0.002
    )
    
    // MARK: - Init
    
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

extension CompanyInfoTableViewCell {
    private func setUI() {
        self.addSubviews(companyImageView, companyNameLabel, companyTypeLabel)
    }
    
    private func setLayout() {
        companyImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.bottom.equalToSuperview().inset(20)
            $0.height.width.equalTo(60)
        }
        
        companyNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(27)
            $0.leading.equalTo(companyImageView.snp.trailing).offset(12)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        companyTypeLabel.snp.makeConstraints {
            $0.top.equalTo(companyNameLabel.snp.bottom).offset(1)
            $0.leading.equalTo(companyImageView.snp.trailing).offset(12)
            $0.trailing.equalToSuperview().inset(20)
        }
    }
}

// MARK: - Methods

extension CompanyInfoTableViewCell {
    func bind(with companyInfo: CompanyInfoModel) {
        companyImageView.setImage(with: companyInfo.companyImage ?? "placeholder_image", placeholder: "placeholder_image")
        companyNameLabel.text = companyInfo.company
        companyTypeLabel.text = companyInfo.companyCategory
    }
}
