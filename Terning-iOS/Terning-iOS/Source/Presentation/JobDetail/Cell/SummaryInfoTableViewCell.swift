//
//  SummaryInfoTableViewCell.swift
//  Terning-iOS
//
//  Created by 정민지 on 7/12/24.
//

import UIKit

import SnapKit

final class SummaryInfoTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    private var infoViews: [JobDetailInfoView] = []
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
    
// MARK: - UI & Layout
    
extension SummaryInfoTableViewCell {
    private func setLayout() {
        for (index, infoView) in infoViews.enumerated() {
            infoView.snp.makeConstraints {
                if index == 0 {
                    $0.top.equalToSuperview().inset(5.adjustedH)
                } else {
                    $0.top.equalTo(infoViews[index - 1].snp.bottom).offset(4.adjustedH)
                }
                $0.leading.equalToSuperview().inset(34.adjusted)
                if index == infoViews.count - 1 {
                    $0.bottom.equalToSuperview().inset(21.adjustedH)
                }
            }
        }
    }
}

// MARK: - Methods

extension SummaryInfoTableViewCell {
    func bind(with infoItems: [InfoItem]) {
        infoViews.forEach { $0.removeFromSuperview() }
        infoViews.removeAll()

        for item in infoItems {
            let infoView = JobDetailInfoView(title: item.title, description: item.description)
            infoView.setTitleTextColor(titleColor: .grey500, descriptionColor: .grey400)
            infoViews.append(infoView)
            self.addSubview(infoView)
        }
        
        setLayout()
    }
}
