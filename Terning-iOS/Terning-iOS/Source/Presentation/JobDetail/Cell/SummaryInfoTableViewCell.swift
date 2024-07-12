//
//  SummaryInfoTableViewCell.swift
//  Terning-iOS
//
//  Created by 정민지 on 7/12/24.
//

import UIKit

import SnapKit

final class SummaryInfoTableViewCell: UITableViewCell {
    
    // MARK: - UI Components
    
    private let qualificationLabel = JobSummaryInfoView(
        image: .icLightbulb,
        title: "자격요건",
        descriptions: ["졸업 예정자", "휴학생 가능"]
    )
    
    private let dutyLabel = JobSummaryInfoView(
        image: .icBag,
        title: "직무",
        descriptions: ["그래픽디자인", "UX/UI/GUI 디자인"]
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

extension SummaryInfoTableViewCell {
    private func setUI() {
        self.addSubviews(qualificationLabel, dutyLabel)
    }
    private func setLayout() {
        qualificationLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        dutyLabel.snp.makeConstraints {
            $0.top.equalTo(qualificationLabel.snp.bottom).offset(14)
            $0.horizontalEdges.bottom.equalToSuperview().inset(20)
        }
    }
}

// MARK: - Methods

extension SummaryInfoTableViewCell {
    func bind(with summaryInfo: SummaryInfoModel) {
        qualificationLabel.setDescriptionText(descriptions: summaryInfo.qualification)
        dutyLabel.setDescriptionText(descriptions: summaryInfo.jobType)
    }
}
