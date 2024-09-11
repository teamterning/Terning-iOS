//
//  FilteringSettingView.swift
//  Terning-iOS
//
//  Created by 김민성 on 7/11/24.
//

import UIKit

import SnapKit
import Then

final class FilteringSettingView: UIView {
    
    // MARK: - UIComponents
    
    private let notchView = UIView().then {
        $0.backgroundColor = .grey300
        $0.layer.cornerRadius = 2
        $0.isUserInteractionEnabled = true
    }
    
    private let mainTitleLabel = LabelFactory.build(
        text: "필터링 재설정",
        font: .title2,
        textColor: .terningBlack
    )
    
    private let splitView = UIView().then {
        $0.backgroundColor = .grey200
    }
    
    private let schoolStatusLabel = LabelFactory.build(
        text: "재학 상태",
        font: .title4,
        textColor: .terningBlack
    )
    
    lazy var gradeButton1 = UIButton().then {
        $0.configureGradeButton(grade: "1학년")
    }
    
    lazy var gradeButton2 = UIButton().then {
        $0.configureGradeButton(grade: "2학년")
    }
    
    lazy var gradeButton3 = UIButton().then {
        $0.configureGradeButton(grade: "3학년")
    }
    
    lazy var gradeButton4 = UIButton().then {
        $0.configureGradeButton(grade: "4학년")
    }
    
    lazy var gradeButtonStack = UIStackView(
        arrangedSubviews: [
            gradeButton1,
            gradeButton2,
            gradeButton3,
            gradeButton4
        ]
    ).then {
        $0.axis = .horizontal
        $0.spacing = 13
        $0.alignment = .center
        $0.distribution = .fillEqually
    }
    
    private let workingPeriodLabel = LabelFactory.build(
        text: "희망 근무 기간",
        font: .title4,
        textColor: .terningBlack
    )
    
    lazy var periodButton1 = UIButton().then {
        $0.configurePeriodButton(period: "1개월 ~ 3개월")
    }
    
    lazy var periodButton2 = UIButton().then {
        $0.configurePeriodButton(period: "4개월 ~ 6개월")
    }
    
    lazy var periodButton3 = UIButton().then {
        $0.configurePeriodButton(period: "7개월 이상")
    }
    
    lazy var periodButtonStack = UIStackView(
        arrangedSubviews: [
            periodButton1,
            periodButton2,
            periodButton3
        ]
    ).then {
        $0.axis = .horizontal
        $0.spacing = 16
        $0.alignment = .center
        $0.distribution = .fillEqually
    }
    
    private let workStartTimeLabel = LabelFactory.build(
        text: "근무 시작 시기",
        font: .title4,
        textColor: .terningBlack
    )
    
    var monthPickerView = CustomDatePicker()
    
    lazy var saveButton = UIButton().then {
        $0.setTitle("저장하기", for: .normal)
        $0.titleLabel?.font = .button0
        $0.setTitleColor(.white, for: .normal)
        $0.setBackgroundColor(.terningPressed, for: .selected)
        $0.setBackgroundColor(.terningMain, for: .normal)
        $0.layer.cornerRadius = 10
    }
    
    // MARK: - LifeCycles
    
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

extension FilteringSettingView {
    private func setUI() {
        backgroundColor = .white
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.layer.cornerRadius = 30
        self.layer.masksToBounds = true
    }
    
    private func setHierarchy() {
        addSubviews(
            notchView,
            mainTitleLabel,
            splitView,
            schoolStatusLabel,
            gradeButtonStack,
            workingPeriodLabel,
            periodButtonStack,
            workStartTimeLabel,
            monthPickerView,
            saveButton
        )
    }
    
    private func setLayout() {
        notchView.snp.makeConstraints {
            $0.top.equalTo(self.snp.top).offset(12)
            $0.centerX.equalTo(self.snp.centerX)
            $0.width.equalTo(60.adjusted)
            $0.height.equalTo(4.adjustedH)
        }
        
        mainTitleLabel.snp.makeConstraints {
            $0.top.equalTo(notchView.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(29)
        }
        
        splitView.snp.makeConstraints {
            $0.top.equalTo(mainTitleLabel.snp.bottom).offset(15)
            $0.horizontalEdges.equalToSuperview().inset(25.adjusted)
            $0.height.equalTo(1.adjustedH)
        }
        
        schoolStatusLabel.snp.makeConstraints {
            $0.top.equalTo(splitView.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(25)
        }
        
        [gradeButton1, gradeButton2, gradeButton3, gradeButton4].forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(36.adjustedH)
            }
        }
        
        gradeButtonStack.snp.makeConstraints {
            $0.top.equalTo(schoolStatusLabel.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(24.adjusted)
        }
        
        workingPeriodLabel.snp.makeConstraints {
            $0.top.equalTo(gradeButtonStack.snp.bottom).offset(32)
            $0.leading.equalToSuperview().offset(25)
        }
        
        [periodButton1, periodButton2, periodButton3].forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(36.adjustedH)
            }
        }
        
        periodButtonStack.snp.makeConstraints {
            $0.top.equalTo(workingPeriodLabel.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(24.adjusted)
        }
        
        workStartTimeLabel.snp.makeConstraints {
            $0.top.equalTo(periodButtonStack.snp.bottom).offset(32)
            $0.leading.equalToSuperview().offset(25)
        }
        
        monthPickerView.snp.makeConstraints {
            $0.top.equalTo(workStartTimeLabel.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(20.adjusted)
        }
        
        saveButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(40.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(24.adjusted)
            $0.height.equalTo(54.adjustedH)
        }
    }
}

// MARK: - Methods

extension UIButton {
    func configurePeriodButton(period: String) {
        self.makeBorder(width: 1, color: .terningMain, cornerRadius: 10)
        self.setTitle(period, for: .normal)
        self.setTitleColor(.terningMain, for: .normal)
        self.titleLabel?.font = .button3
    }
    
    func configureGradeButton(grade: String) {
        self.makeBorder(width: 1, color: .terningMain, cornerRadius: 10)
        self.setTitle(grade, for: .normal)
        self.setTitleColor(.grey400, for: .normal)
        self.titleLabel?.font = .button3
    }
}
