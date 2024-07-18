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
enum OnboardingViewType {
    case grade
    case workingPeriod
    case graduationDate
}

final class OnboardingView: UIView {
    
    // MARK: - Properties
    
    private let viewType: OnboardingViewType
    
    private let gradeButtonOptions = [
        ("1학년", "대학생의 첫 인턴, 어린 나이에 미리 도전해볼래요!"),
        ("2학년", "미리 대학생 인턴 경험하고, 사회 생활을 해 보고 싶어요"),
        ("3학년", "4학년이 되기 전, 인턴으로 유의미한 스펙을 쌓고 싶어요"),
        ("4학년", "사회인으로의 첫 발걸음, 인턴으로 채우고 싶어요")
    ]
    
    private let workingPeriodButtonOptions = [
        ("1개월 ~ 3개월", "짧은 기간 안에 스펙을 쌓고 싶은\n‘인턴 초년생'에게 추천해요!"),
        ("4개월 ~ 6개월", "좀 더 오랜 시간동안의 회사 경험을 원하는\n‘성숙 인턴러'에게 추천해요!"),
        ("7개월 이상", "산업에 오랜 기간 딥다이브 하고 싶은\n‘예비 사회인'에게 추천해요!")
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
        text: "*5년제 혹은 초과학기생인 경우 4학년으로 선택해주세요",
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
            $0.height.equalTo(68)
        }
        progressView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(92)
            $0.leading.equalToSuperview().inset(20)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(progressView.snp.bottom).offset(19)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        nextButton.snp.makeConstraints {
            $0.height.equalTo(54)
            $0.horizontalEdges.equalToSuperview().inset(-5)
            $0.bottom.equalToSuperview().inset(12)
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
        titleLabel.text = "재학 상태를 선택해주세요"
        subTitleLabel.text = "휴학중이라면, 휴학 전 마지막 수료 학년을 선택해주세요"
        
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
        titleLabel.text = "희망하는 인턴 근무 기간을 선택해주세요"
        subTitleLabel.text = "선택한 기간동안 근무할 수 있는 인턴 공고를 찾아드릴게요"
        
        addSubview(buttonStackView)
        
        for (index, (originalTitle, selectedTitle)) in workingPeriodButtonOptions.enumerated() {
            let button = CustomOnboardingButton(
                originalTitle: originalTitle,
                selectedTitle: selectedTitle,
                height: 68
            )
            button.index = index
            button.addTarget(self, action: #selector(optionSelected(_:)), for: .touchUpInside)
            buttonStackView.addArrangedSubview(button)
        }
    }
    
    private func setGraduationDateUI() {
        titleLabel.text = "입사를 계획중인 달을 선택해주세요"
        subTitleLabel.text = "선택한 달부터 근무를 시작할 수 있는 공고를 찾아드릴게요"
        
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
                OnboardingData.shared.startYear = year
                OnboardingData.shared.startMonth = month
                self?.dateSelectedSubject.onNext(date)
            }
        }
    }
    
    private func setGradeLayout() {
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        additionalInfoLabel.snp.makeConstraints {
            $0.top.equalTo(buttonStackView.snp.bottom).offset(9)
            $0.horizontalEdges.equalToSuperview().inset(22)
        }
    }
    
    private func setworkingPeriodLayout() {
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
    }
    
    private func setGraduationDateLayout() {
        customDatePicker.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(200)
        }
    }
    private func updateOnboardingData(for viewType: OnboardingViewType, with index: Int?) {
        switch viewType {
        case .grade:
            OnboardingData.shared.grade = index ?? -1
        case .workingPeriod:
            OnboardingData.shared.workingPeriod = index ?? -1
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
        selectedButton?.deselectButton()
        selectedButton = sender
        sender.selectButton()
        updateOnboardingData(for: viewType, with: sender.index)
        optionSelectedSubject.onNext(sender.index)
    }
}
