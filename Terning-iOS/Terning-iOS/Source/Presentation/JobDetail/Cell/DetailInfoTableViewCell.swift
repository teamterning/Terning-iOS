//
//  DetailInfoTableViewCell.swift
//  Terning-iOS
//
//  Created by 정민지 on 7/12/24.
//

import UIKit

import SnapKit

final class DetailInfoTableViewCell: UITableViewCell {
    
    // MARK: - UI Components
    
    private let datailDescriptionLabel = LabelFactory.build(
        text: "상세 정보입니다.",
        font: .detail1,
        textColor: .grey400,
        textAlignment: .left,
        lineSpacing: 1.2,
        characterSpacing: 0.002
    ).then {
        $0.numberOfLines = 0
    }
    
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

extension DetailInfoTableViewCell {
    private func setUI() {
        self.addSubview(datailDescriptionLabel)
    }
    private func setLayout() {
        datailDescriptionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.horizontalEdges.bottom.equalToSuperview().inset(20)
        }
    }
}

// MARK: - Methods

extension DetailInfoTableViewCell {
    func configure(with detailInfo: DetailInfoModel) {
        datailDescriptionLabel.text = detailInfo.detail
    }
}
