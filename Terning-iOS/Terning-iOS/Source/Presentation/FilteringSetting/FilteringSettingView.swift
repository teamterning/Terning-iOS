//
//  FilteringSettingView.swift
//  Terning-iOS
//
//  Created by 김민성 on 7/11/24.
//

import UIKit

import SnapKit
import Then

class FilteringSettingView: UIView {
    
    // MARK: - UIComponents
    
    lazy var navi = CustomNavigationBar(type: .centerTitleWithLeftButton, isShadow: true).setTitle("필터링 재설정")
    
    let gradeSelectionTitle = LabelFactory.build(
        text: "재학 상태를 선택해주세요",
        font: .title3,
        textColor: .terningBlack
    )
    
    let gradeSelectionSubTitle = LabelFactory.build(
        text: "휴학중이라면, 휴학 전 마지막 수료 학년을 선택해주세요",
        font: .body3,
        textColor: .grey375
    )

    lazy var titleStack1 = UIStackView(
        arrangedSubviews: [
            gradeSelectionTitle,
            gradeSelectionSubTitle
        ]
    ).then {
        $0.axis = .vertical
        $0.spacing = 0
        $0.alignment = .leading
    }
    
    lazy var gradeButton1 = UIButton().then {
        $0.makeBorder(width: 1, color: .terningMain, cornerRadius: 10)
        $0.setTitle("1학년", for: .normal)
        $0.setTitleColor(.grey400, for: .normal)
        $0.titleLabel?.font = .button3
    }
    
    lazy var gradeButton2 = UIButton().then {
        $0.makeBorder(width: 1, color: .terningMain, cornerRadius: 10)
        $0.setTitle("2학년", for: .normal)
        $0.setTitleColor(.grey400, for: .normal)
        $0.titleLabel?.font = .button3
    }
    
    lazy var gradeButton3 = UIButton().then {
        $0.makeBorder(width: 1, color: .terningMain, cornerRadius: 10)
        $0.setTitle("3학년", for: .normal)
        $0.setTitleColor(.grey400, for: .normal)
        $0.titleLabel?.font = .button3
    }
    
    lazy var gradeButton4 = UIButton().then {
        $0.makeBorder(width: 1, color: .terningMain, cornerRadius: 10)
        $0.setTitle("4학년", for: .normal)
        $0.setTitleColor(.grey400, for: .normal)
        $0.titleLabel?.font = .button3
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
    
    let periodSelectionTitle = LabelFactory.build(
        text: "희망하는 인턴 근무 기간을 선택해주세요",
        font: .title3,
        textColor: .terningBlack
    )
    
    let periodSelectionSubTitle = LabelFactory.build(
        text: "선택한 기간동안 근무할 수 있는 인턴 공고를 찾아드릴게요",
        font: .body3,
        textColor: .grey375
    )
    
    lazy var titleStack2 = UIStackView(
        arrangedSubviews: [
            periodSelectionTitle,
            periodSelectionSubTitle
        ]
    ).then {
        $0.axis = .vertical
        $0.spacing = 0
        $0.alignment = .leading
    }
    
    lazy var periodButton1 = UIButton().then {
        $0.makeBorder(width: 1, color: .terningMain, cornerRadius: 10)
        $0.setTitle("1개월 ~ 3개월", for: .normal)
        $0.setTitleColor(.grey400, for: .normal)
        $0.titleLabel?.font = .button3
    }
    
    lazy var periodButton2 = UIButton().then {
        $0.makeBorder(width: 1, color: .terningMain, cornerRadius: 10)
        $0.setTitle("4개월 ~ 6개월", for: .normal)
        $0.setTitleColor(.grey400, for: .normal)
        $0.titleLabel?.font = .button3
    }
    
    lazy var periodButton3 = UIButton().then {
        $0.makeBorder(width: 1, color: .terningMain, cornerRadius: 10)
        $0.setTitle("7개월 이상", for: .normal)
        $0.setTitleColor(.grey400, for: .normal)
        $0.titleLabel?.font = .button3
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
    
    var monthPickerView = CustomDatePicker()
    
    let monthSelectionTitle = LabelFactory.build(
        text: "입사를 계획중인 달을 선택해주세요",
        font: .title3,
        textColor: .terningBlack
    )
    
    let monthSelectionSubTitle = LabelFactory.build(
        text: "선택한 달부터 근무를 시작할 수 있는 공고를 찾아드릴게요",
        font: .body3,
        textColor: UIColor(red: 137/255, green: 137/255, blue: 137/255, alpha: 1.0)
    )

    lazy var titleStack3 = UIStackView(
        arrangedSubviews: [
            monthSelectionTitle,
            monthSelectionSubTitle
        ]
    ).then {
        $0.axis = .vertical
        $0.spacing = 0
        $0.alignment = .leading
    }
    
    lazy var saveButton = UIButton().then {
        $0.setTitle("저장하기", for: .normal)
        $0.titleLabel?.font = .button0
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .terningMain
    }
    
    // MARK: LifeCycles
    
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

// MARK: UI & Layout

extension FilteringSettingView {
    
    func setUI() {
        backgroundColor = .white
    }
    
    func setHierarchy() {
        addSubviews(
            navi,
            titleStack1,
            gradeButtonStack,
            titleStack2,
            periodButtonStack,
            titleStack3,
            monthPickerView,
            saveButton
        )
    }
    
    func setLayout() {
        navi.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(68)
        }
        
        titleStack1.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(625)
            $0.leading.equalToSuperview().offset(20)
        }
        
        gradeButton1.snp.makeConstraints {
            $0.height.equalTo(36)
        }
        
        gradeButton2.snp.makeConstraints {
            $0.height.equalTo(36)
        }
        
        gradeButton3.snp.makeConstraints {
            $0.height.equalTo(36)
        }
        
        gradeButton4.snp.makeConstraints {
            $0.height.equalTo(36)
        }
        
        gradeButtonStack.snp.makeConstraints {
            $0.top.equalTo(titleStack1.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(22)
            $0.height.equalTo(36)
        }
        
        titleStack2.snp.makeConstraints {
            $0.top.equalTo(gradeButtonStack.snp.bottom).offset(35)
            $0.leading.equalToSuperview().offset(20)
        }
        
        periodButton1.snp.makeConstraints {
            $0.height.equalTo(36)
        }
        
        periodButton2.snp.makeConstraints {
            $0.height.equalTo(36)
        }
        
        periodButton3.snp.makeConstraints {
            $0.height.equalTo(36)
        }
        
        periodButtonStack.snp.makeConstraints {
            $0.top.equalTo(titleStack2.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(22)
            $0.height.equalTo(36)
        }
        
        titleStack3.snp.makeConstraints {
            $0.top.equalTo(periodButtonStack.snp.bottom).offset(35)
            $0.leading.equalToSuperview().offset(20)
        }
        
        monthPickerView.snp.makeConstraints {
            $0.top.equalTo(titleStack3.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        saveButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(52)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(52)
        }
    }
}
