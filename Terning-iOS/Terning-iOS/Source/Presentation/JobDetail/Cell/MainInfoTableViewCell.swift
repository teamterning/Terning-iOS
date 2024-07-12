//
//  MainInfoTableViewCell.swift
//  Terning-iOS
//
//  Created by 정민지 on 7/12/24.
//

import UIKit

import SnapKit
import Then

final class MainInfoTableViewCell: UITableViewCell {
    
    // MARK: - UI Components
    
    private let dDayDivView = UIView().then {
        $0.layer.cornerRadius = 10
        $0.layer.borderColor = UIColor.terningMain.cgColor
        $0.layer.borderWidth = 1
    }
    
    private let dDayLabel = LabelFactory.build(
        text: "D-3",
        font: .body0,
        textColor: .terningMain,
        lineSpacing: 1.0,
        characterSpacing: 0.002
    )
    
    private let titleLabel = LabelFactory.build(
        text: "[SomeOne] 콘텐츠 마케터 대학생 인턴 채용",
        font: .title2,
        textAlignment: .left
    ).then {
        $0.numberOfLines = 2
    }
    
    private let divView = UIView().then {
        $0.layer.cornerRadius = 5
        $0.layer.borderColor = UIColor.terningMain.cgColor
        $0.layer.borderWidth = 1
    }

    private let deadlineInfoView = JobDetailInfoView(
        title: "서류 마감",
        description: "2024년 7월 23일"
    )
    
    private let workPeriodInfoView = JobDetailInfoView(
        title: "근무 기간",
        description: "2개월"
    )
    
    private let workStartInfoView = JobDetailInfoView(
        title: "근무 시작",
        description: "2024년 8월"
    )
    
    private let viewsTitleLabel = LabelFactory.build(
        text: "조회수",
        font: .detail3,
        textColor: .grey400
    )
    
    private let viewsLabel = LabelFactory.build(
        text: "3,219회",
        font: .button4,
        textColor: .grey400
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

extension MainInfoTableViewCell {
    private func setUI() {
        [dDayDivView,
         titleLabel,
         divView,
         viewsTitleLabel,
         viewsLabel
        ].forEach {
            self.addSubview($0)
        }
        
        dDayDivView.addSubview(dDayLabel)
        
        [
            deadlineInfoView,
            workPeriodInfoView,
            workStartInfoView
        ].forEach {
            divView.addSubviews($0)
        }
    }
    
    private func setLayout() {
        dDayDivView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(20)
        }
        
        dDayLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.leading.equalToSuperview().inset(10)
            $0.trailing.equalToSuperview().inset(11)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(dDayDivView.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        divView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        deadlineInfoView.snp.makeConstraints {
            $0.top.equalTo(divView.snp.top).inset(16)
            $0.leading.equalTo(divView.snp.leading).inset(16)
            $0.height.equalTo(18)
        }
        
        workPeriodInfoView.snp.makeConstraints {
            $0.top.equalTo(deadlineInfoView.snp.bottom).offset(5)
            $0.leading.equalTo(divView.snp.leading).inset(16)
            $0.height.equalTo(18)
        }
        
        workStartInfoView.snp.makeConstraints {
            $0.top.equalTo(workPeriodInfoView.snp.bottom).offset(5)
            $0.leading.equalTo(divView.snp.leading).inset(16)
            $0.height.equalTo(18)
            $0.bottom.equalTo(divView.snp.bottom).inset(16)
        }
        
        viewsLabel.snp.makeConstraints {
            $0.top.equalTo(divView.snp.bottom).offset(8)
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(14)
        }
        
        viewsTitleLabel.snp.makeConstraints {
            $0.centerY.equalTo(viewsLabel.snp.centerY)
            $0.trailing.equalTo(viewsLabel.snp.leading).offset(-3)
        }
    }
}

// MARK: - Methods

extension MainInfoTableViewCell {
    func configure(with mainInfo: MainInfoModel) {
        if let dDayInt = Int(mainInfo.dDay) {
            dDayLabel.text = "D-\(dDayInt)"
        } else {
            dDayLabel.text = mainInfo.dDay
        }
        
        titleLabel.text = mainInfo.title
        
        deadlineInfoView.setDescriptionText(description: mainInfo.deadline)
        workPeriodInfoView.setDescriptionText(description: mainInfo.workingPeriod)
        workStartInfoView.setDescriptionText(description: mainInfo.startDate)
        
        viewsLabel.text = "\(mainInfo.viewCount)회"
    }
}
