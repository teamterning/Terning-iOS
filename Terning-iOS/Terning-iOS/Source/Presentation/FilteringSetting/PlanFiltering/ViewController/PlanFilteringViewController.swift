//
//  PlanFilteringViewController.swift
//  Terning-iOS
//
//  Created by 정민지 on 12/17/24.
//

import UIKit

import RxSwift
import RxCocoa

import SnapKit
import Then

final class PlanFilteringViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: PlanFilteringViewModel
    private let disposeBag = DisposeBag()
    var filteringState = BehaviorRelay<Bool>(value: false)
    private var selectedButtons: [CustomOnboardingButton?] = [nil, nil]
   
    // MARK: - UI Components
    
    private var gradeTitleLabel = LabelFactory.build(
        text: "재학 상태",
        font: .title4
    )
    private var periodTitleLabel = LabelFactory.build(
        text: "희망 근무 기간",
        font: .title4
    )
    private var dateTitleLabel = LabelFactory.build(
        text: "근무 시작 시기",
        font: .title4
    )
    private lazy var gradeButtons = createButtonGroup(titles: Grade.allCases.map { $0.displayName }, section: 0)
    private lazy var periodButtons = createButtonGroup(titles: WorkingPeriod.allCases.map { $0.displayName }, section: 1)
    private var customPickerView = CustomDatePicker()
    private let checkBox = CustomCheckButton(title: "계획 필터링 없이 모든 공고 보기")
    
    // MARK: - Init
    
    init(viewModel: PlanFilteringViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setHierarchy()
        setLayout()
        bindViewModel()
    }
}
    
// MARK: - UI & Layout

extension PlanFilteringViewController {
    private func setHierarchy() {
        view.addSubviews(
            gradeTitleLabel,
            gradeButtons,
            periodTitleLabel,
            periodButtons,
            dateTitleLabel,
            customPickerView,
            checkBox
        )
    }
    private func setLayout() {
        gradeTitleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        gradeButtons.snp.makeConstraints {
            $0.top.equalTo(gradeTitleLabel.snp.bottom).offset(12.adjustedH)
            $0.horizontalEdges.equalToSuperview()
        }
        periodTitleLabel.snp.makeConstraints {
            $0.top.equalTo(gradeButtons.snp.bottom).offset(24.adjustedH)
            $0.leading.equalToSuperview()
        }
        periodButtons.snp.makeConstraints {
            $0.top.equalTo(periodTitleLabel.snp.bottom).offset(12.adjustedH)
            $0.horizontalEdges.equalToSuperview()
        }
        dateTitleLabel.snp.makeConstraints {
            $0.top.equalTo(periodButtons.snp.bottom).offset(24.adjustedH)
            $0.leading.equalToSuperview()
        }
        customPickerView.snp.makeConstraints {
            $0.top.equalTo(dateTitleLabel.snp.bottom).offset(10.adjustedH)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(170.adjustedH)
        }
        checkBox.snp.makeConstraints {
            $0.bottom.trailing.equalToSuperview()
        }
    }
    
    private func createButtonGroup(titles: [String], section: Int) -> UIStackView {
        let stackView = UIStackView().then {
            $0.axis = .horizontal
            $0.spacing = 12
            $0.distribution = .fillEqually
        }
        
        titles.enumerated().forEach { index, title in
            let button = CustomOnboardingButton(
                originalTitle: title,
                selectedTitle: title,
                cornerRadius: 10,
                height: 36.adjustedH
            )
            button.tag = section * 10 + index

            stackView.addArrangedSubview(button)
        }
        return stackView
    }
}

// MARK: - Methods

extension PlanFilteringViewController {
    private func bindViewModel() {
        let gradeSelected = Observable<Grade?>.merge(
            gradeButtons.arrangedSubviews.compactMap { $0 as? CustomOnboardingButton }.map { button in
                button.rx.tap.map { [weak self] in
                    self?.updateSelectedButton(section: 0, sender: button)
                    return self?.selectedButtons[0] != nil ? Grade.allCases[button.tag % 10] : nil
                }
            }
        )
        let periodSelected = Observable<WorkingPeriod?>.merge(
            periodButtons.arrangedSubviews.compactMap { $0 as? CustomOnboardingButton }.map { button in
                button.rx.tap.map { [weak self] in
                    self?.updateSelectedButton(section: 1, sender: button)
                    return self?.selectedButtons[1] != nil ? WorkingPeriod.allCases[button.tag % 10] : nil
                }
            }
        )
        let dateSelected = Observable<(Int?, Int?)>.create { [weak self] observer -> Disposable in
            self?.customPickerView.onDateSelected = { year, month in
                self?.updateCheckBoxState()
                observer.onNext((year, month))
            }
            return Disposables.create()
        }
        .observe(on: MainScheduler.asyncInstance)
        .share()

        let checkBoxToggled: Observable<Bool> = Observable.create { [weak self] observer -> Disposable in
            self?.checkBox.action = { isChecked in
                self?.didTapCheckBox(isChecked: isChecked)
                observer.onNext(isChecked)
            }
            return Disposables.create()
        }
        
        let input = PlanFilteringViewModel.Input(
            gradeSelected: gradeSelected,
            periodSelected: periodSelected,
            yearSelected: dateSelected.map { $0.0 },
            monthSelected: dateSelected.map { $0.1 },
            checkBoxToggled: checkBoxToggled
        )
        
        let output = viewModel.transform(input: input, disposeBag: disposeBag)
        
        output.selectedGrade
            .drive(onNext: { [weak self] grade in
                guard let self = self, let grade = grade else { return }
                self.updateButtonState(for: self.gradeButtons, selectedValue: grade.displayName, section: 0)
            })
            .disposed(by: disposeBag)

        output.selectedPeriod
            .drive(onNext: { [weak self] period in
                guard let self = self, let period = period else { return }
                self.updateButtonState(for: self.periodButtons, selectedValue: period.displayName, section: 1)
            })
            .disposed(by: disposeBag)

        Observable
            .combineLatest(output.selectedYear.asObservable(), output.selectedMonth.asObservable())
            .take(1)
            .subscribe(onNext: { [weak self] year, month in
                guard let self = self, let year = year, let month = month else { return }
                self.customPickerView.setInitialDate(year: year, month: month)
            })
            .disposed(by: disposeBag)
        
        output.isFilterApplied
            .drive(filteringState)
            .disposed(by: disposeBag)
    }
    
    private func updateButtonState(for buttonGroup: UIStackView, selectedValue: String?, section: Int) {
        buttonGroup.arrangedSubviews.compactMap { $0 as? CustomOnboardingButton }.forEach { button in
            let isSelected = (button.originalTitle == selectedValue)
            if isSelected {
                button.selectButton()
                selectedButtons[section] = button
            } else {
                button.deselectButton()
            }
        }
    }
    
    private func updateCheckBoxState() {
        let hasSelectedButton = selectedButtons.contains { $0 != nil }
        let pickerHasValidSelection = {
            let selectedYearRow = customPickerView.selectedRow(inComponent: 0)
            let selectedMonthRow = customPickerView.selectedRow(inComponent: 1)
            
            let yearIsValid = selectedYearRow >= 0 && selectedYearRow < customPickerView.years.count && customPickerView.years[selectedYearRow] != "-"
            let monthIsValid = selectedMonthRow >= 0 && selectedMonthRow < customPickerView.months.count && customPickerView.months[selectedMonthRow] != "-"
            return yearIsValid || monthIsValid
        }()
        if hasSelectedButton || pickerHasValidSelection {
            checkBox.setChecked(false)
        }
    }
    
    private func updateSelectedButton(section: Int, sender: CustomOnboardingButton) {
        if selectedButtons[section] == sender {
            selectedButtons[section]?.deselectButton()
            selectedButtons[section] = nil
        } else {
            selectedButtons[section]?.deselectButton()
            sender.selectButton()
            selectedButtons[section] = sender
        }
        updateCheckBoxState()
    }
}

// MARK: - @objc func

extension PlanFilteringViewController {
    @objc
    private func didTapCheckBox(isChecked: Bool) {
        if isChecked {
            selectedButtons.forEach { button in
                button?.deselectButton()
            }
            selectedButtons = [nil, nil]
            
            customPickerView.addPlaceholder()
            customPickerView.removePlaceholder()
        }
    }
}
