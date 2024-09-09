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
        $0.contentMode = .scaleAspectFit
        $0.makeBorder(
            width: 1,
            color: .grey150,
            cornerRadius: 20.adjusted
        )
        $0.layer.masksToBounds = true
    }
    
    private let companyNameLabel = LabelFactory.build(
        text: "회사명",
        font: .title4
    ).then {
        $0.numberOfLines = 2
    }
    
    private let companyTypeLabel = LabelFactory.build(
        text: "스타트업",
        font: .body4,
        textColor: .grey300,
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
            $0.top.equalToSuperview().inset(12.adjustedH)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(128.adjusted)
        }
        
        companyNameLabel.snp.makeConstraints {
            $0.top.equalTo(companyImageView.snp.bottom).offset(20.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(110.adjusted)
        }
        
        companyTypeLabel.snp.makeConstraints {
            $0.top.equalTo(companyNameLabel.snp.bottom).offset(8.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(12.adjusted)
            $0.bottom.equalToSuperview().inset(12.adjustedH)
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
