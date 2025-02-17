//
//  DetailInfoTableViewCell.swift
//  Terning-iOS
//
//  Created by 정민지 on 7/12/24.
//

import UIKit

import SnapKit
import Then

final class DetailInfoTableViewCell: UITableViewCell {
    
    // MARK: - UI Components
    
    private let datailDescriptionLabel = TextViewFactory.build(
        text: "",
        font: .detail1,
        textColor: .grey400,
        textAlignment: .left,
        lineSpacing: 1.2,
        characterSpacing: 0.002
    ).then {
        $0.isEditable = false
        $0.isScrollEnabled = false
        $0.dataDetectorTypes = [.link]
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
        contentView.addSubview(datailDescriptionLabel)
    }
    private func setLayout() {
        datailDescriptionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(4.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(34.adjusted)
            $0.bottom.equalToSuperview().inset(20.adjustedH)
        }
    }
}

// MARK: - Methods

extension DetailInfoTableViewCell {
    func bind(with detailInfo: DetailInfoModel) {
        datailDescriptionLabel.text = detailInfo.detail
    }
}
