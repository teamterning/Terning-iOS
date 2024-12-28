//
//  OnboardingView.swift
//  Terning-iOS
//
//  Created by 정민지 on 7/11/24.
//

import UIKit

import RxSwift

import SnapKit

@frozen
public enum OnboardingViewType {
    case grade
    case workingPeriod
    case graduationDate
}

final class OnboardingView: UIView {
    
    // MARK: - Properties
    
    private let viewType: OnboardingViewType
    
    private let gradeButtonOptions = [
        ("1학년", "대학생 인턴, 누구보다 빠르게 시작해 보세요!"),
        ("2학년", "인턴이라는 좋은 기회로 단숨에 스펙업하세요! "),
        ("3학년", "지금까지 준비한 역량을 인턴으로 발휘해 보세요!"),
        ("4학년", "사회초년생으로 도약하는 마지막 단계를 경험하세요!")
    ]
    
    private let workingPeriodButtonOptions = [
        ("1개월 ~ 3개월", "짧은 기간 안에 유의미한 스펙을 쌓을 수 있어요!"),
        ("4개월 ~ 6개월", "회사와 직무에 대해 이해하기 적당한 기간이에요!"),
        ("7개월 이상", "오랜 기간 내 커리어에 맞는 직무경험을 만들 수 있어요!")
    ]
    private var selectedButton: CustomOnboardingButton?
    
    let optionSelectedSubject = PublishSubject<Int?>()
    let dateSelectedSubject = BehaviorSubject<Date?>(value: nil)
    
    // MARK: - UI Components
    
    let navigationBar = CustomNavigationBar(type: .leftButton)
    
    private let progressView = CustomProgressView(
        currentStep: 0,
        totalSteps: 3,
        circleSize: 28,
        lineLength: 12
    )
    
    let titleLabel = LabelFactory.build(
        text: "제목",
        font: .title3,
        textAlignment: .left
    ).then {
        $0.numberOfLines = 0
    }
    
    let subTitleLabel = LabelFactory.build(
        text: "추가 설명을 입력해주세요.",
        font: .body5,
        textColor: .grey300,
        textAlignment: .left,
        lineSpacing: 1.2,
        characterSpacing: 0.002
    )
    
    let buttonStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 12
        $0.distribution = .fillEqually
    }
    
    let additionalInfoLabel = LabelFactory.build(
        text: "*5년제 혹은 초과학기생인 경우 4학년으로 선택해 주세요",
        font: .detail3,
        textColor: .grey400,
        textAlignment: .left,
        lineSpacing: 1.2,
        characterSpacing: 0.002
    )
    
    let customDatePicker = CustomDatePicker()
    
    lazy var nextButton = CustomButton(title: "다음으로")
    
    // MARK: - Init
    
    init(viewType: OnboardingViewType) {
        self.viewType = viewType
        super.init(frame: .zero)
        
        setUI(viewType: viewType)
        setLayout(viewType: viewType)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension OnboardingView {
    private func setUI(viewType: OnboardingViewType) {
        nextButton.setColor(
            bgColor: .terningMain,
            disableColor: .grey200
        )
        
        addSubviews(
            navigationBar,
            progressView,
            titleLabel,
            subTitleLabel,
            nextButton
        )
        
        switch viewType {
        case .grade:
            setGradeUI()
        case .workingPeriod:
            setworkingPeriodUI()
        case .graduationDate:
            setGraduationDateUI()
        }
    }
    
    private func setLayout(viewType: OnboardingViewType) {
        navigationBar.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(68.adjustedH)
        }
        progressView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(92.adjustedH)
            $0.leading.equalToSuperview().inset(24.adjusted)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(progressView.snp.bottom).offset(20.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(24.adjusted)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(24.adjusted)
        }
        
        nextButton.snp.makeConstraints {
            $0.height.equalTo(54.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(-5.adjusted)
            $0.bottom.equalToSuperview().inset(12.adjustedH)
        }
        
        switch viewType {
        case .grade:
            setGradeLayout()
        case .workingPeriod:
            setworkingPeriodLayout()
        case .graduationDate:
            setGraduationDateLayout()
        }
    }
}

// MARK: - Methods

extension OnboardingView {
    private func setGradeUI() {
        let userName = OnboardingData.shared.userName
        print("userName", userName)
        if userName.isEmpty {
            titleLabel.text = "재학 상태를 선택해 주세요"
        } else if userName.count > 6 {
            titleLabel.text = "\(userName)님의\n재학 상태를 선택해 주세요"
        } else {
            titleLabel.text = "\(userName)님의 재학 상태를 선택해 주세요"
        }
        
        subTitleLabel.text = "휴학 중이라면, 휴학 전 마지막 수료 학년을 선택해 주세요"
        
        addSubviews(
            buttonStackView,
            additionalInfoLabel
        )
        
        for (index, (originalTitle, selectedTitle)) in gradeButtonOptions.enumerated() {
            let button = CustomOnboardingButton(
                originalTitle: originalTitle,
                selectedTitle: selectedTitle
            )
            button.index = index
            button.addTarget(self, action: #selector(optionSelected(_:)), for: .touchUpInside)
            buttonStackView.addArrangedSubview(button)
        }
    }
    
    private func setworkingPeriodUI() {
        titleLabel.text = "희망하는 인턴 근무 기간을 선택해 주세요"
        subTitleLabel.text = "선택한 기간 동안 근무할 수 있는 인턴 공고를 찾아드릴게요"
        
        addSubview(buttonStackView)
        
        for (index, (originalTitle, selectedTitle)) in workingPeriodButtonOptions.enumerated() {
            let button = CustomOnboardingButton(
                originalTitle: originalTitle,
                selectedTitle: selectedTitle,
                height: 68.adjustedH
            )
            button.index = index
            button.addTarget(self, action: #selector(optionSelected(_:)), for: .touchUpInside)
            buttonStackView.addArrangedSubview(button)
        }
    }
    
    private func setGraduationDateUI() {
        titleLabel.text = "언제부터 인턴 근무가 가능한지 알려주세요"
        subTitleLabel.text = "원하는 근무 시작 시기에 맞는 인턴 공고를 찾아드려요"
        
        addSubview(customDatePicker)
        
        let (currentYear, currentMonth) = Date().getCurrentKrYearAndMonth()
        
        let initialCalendar = Calendar.current
        var initialDateComponents = DateComponents()
        initialDateComponents.year = currentYear
        initialDateComponents.month = currentMonth
        if let initialDate = initialCalendar.date(from: initialDateComponents) {
            OnboardingData.shared.startYear = currentYear
            OnboardingData.shared.startMonth = currentMonth
            self.dateSelectedSubject.onNext(initialDate)
        }
        
        customDatePicker.onDateSelected = { [weak self] year, month in
            let calendar = Calendar.current
            var dateComponents = DateComponents()
            dateComponents.year = year
            dateComponents.month = month
            if let date = calendar.date(from: dateComponents) {
                OnboardingData.shared.startYear = year ?? 0
                OnboardingData.shared.startMonth = month ?? 0
                self?.dateSelectedSubject.onNext(date)
            }
        }
    }
    
    private func setGradeLayout() {
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(24.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(24.adjusted)
        }
        additionalInfoLabel.snp.makeConstraints {
            $0.top.equalTo(buttonStackView.snp.bottom).offset(8.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(24.adjusted)
        }
    }
    
    private func setworkingPeriodLayout() {
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(24.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(24.adjusted)
        }
    }
    
    private func setGraduationDateLayout() {
        customDatePicker.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(24.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(20.adjusted)
            $0.height.equalTo(200.adjustedH)
        }
    }
    private func updateOnboardingData(for viewType: OnboardingViewType, with stringValue: String?) {
        switch viewType {
        case .grade:
            OnboardingData.shared.grade = stringValue ?? ""
        case .workingPeriod:
            OnboardingData.shared.workingPeriod = stringValue ?? ""
        case .graduationDate:
            break
        }
    }
}

// MARK: - Public Methods

extension OnboardingView {
    public func updateProgress(step: Int) {
        progressView.setCurrentStep(step)
    }
}

// MARK: - @objc func

extension OnboardingView {
    @objc
    private func optionSelected(_ sender: CustomOnboardingButton) {
        
        if sender == selectedButton {
            selectedButton?.deselectButton()
            selectedButton = nil
            updateOnboardingData(for: viewType, with: nil)
            optionSelectedSubject.onNext(nil)
        } else {
            selectedButton?.deselectButton()
            selectedButton = sender
            sender.selectButton()
            
            let stringValue: String?
                switch viewType {
                case .grade:
                    switch sender.index {
                    case 0: stringValue = "freshman"
                    case 1: stringValue = "sophomore"
                    case 2: stringValue = "junior"
                    case 3: stringValue = "senior"
                    default: stringValue = nil
                    }
                    
                case .workingPeriod:
                    switch sender.index {
                    case 0: stringValue = "short"
                    case 1: stringValue = "middle"
                    case 2: stringValue = "long"
                    default: stringValue = nil
                    }

                case .graduationDate:
                    stringValue = nil
                }
            
            updateOnboardingData(for: viewType, with: stringValue)
            optionSelectedSubject.onNext(sender.index)
        }
    }
}
