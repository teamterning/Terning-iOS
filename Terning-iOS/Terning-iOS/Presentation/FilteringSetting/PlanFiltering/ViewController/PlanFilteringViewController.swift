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
                button.rx.tap.map { Grade.allCases[button.tag % 10] }
            }
        )
        
        let periodSelected = Observable<WorkingPeriod?>.merge(
            periodButtons.arrangedSubviews.compactMap { $0 as? CustomOnboardingButton }.map { button in
                button.rx.tap.map { WorkingPeriod.allCases[button.tag % 10] }
            }
        )
        
        let dateSelected = Observable<(Int?, Int?)>.create { [weak self] observer -> Disposable in
            self?.customPickerView.onDateSelected = { year, month in
                observer.onNext((year, month))
            }
            return Disposables.create()
        }
        .observe(on: MainScheduler.asyncInstance)
        .share()
        
        let checkBoxToggled = Observable<Bool>.create { [weak self] observer -> Disposable in
            self?.checkBox.action = { isChecked in
                observer.onNext(isChecked)
                if isChecked {
                    self?.customPickerView.addPlaceholder()
                    self?.customPickerView.removePlaceholder()
                }
            }
            return Disposables.create()
        }
        .observe(on: MainScheduler.asyncInstance)

        let input = PlanFilteringViewModel.Input(
            gradeSelected: gradeSelected,
            periodSelected: periodSelected,
            yearSelected: dateSelected.map { $0.0 },
            monthSelected: dateSelected.map { $0.1 },
            checkBoxToggled: checkBoxToggled
        )
        
        let output = viewModel.transform(input: input, disposeBag: disposeBag)
        
        Observable.combineLatest(output.selectedYear.asObservable(), output.selectedMonth.asObservable())
            .take(1)
            .subscribe(onNext: { [weak self] year, month in
                guard let self = self else { return }
                
                if let year = year, let month = month, year > 0, month > 0 {
                    self.customPickerView.setInitialDate(year: year, month: month)
                } else {
                    self.customPickerView.addPlaceholder()
                }
            })
            .disposed(by: disposeBag)

        output.selectedGrade
            .drive(onNext: { [weak self] grade in
                guard let self = self else { return }
                if let grade = grade {
                    self.updateButtonState(for: self.gradeButtons, selectedValue: grade.displayName)
                } else {
                    self.updateButtonState(for: self.gradeButtons, selectedValue: nil)
                }
            })
            .disposed(by: disposeBag)
        
        output.selectedPeriod
            .drive(onNext: { [weak self] period in
                guard let self = self else { return }
                if let period = period {
                    self.updateButtonState(for: self.periodButtons, selectedValue: period.displayName)
                } else {
                    self.updateButtonState(for: self.periodButtons, selectedValue: nil)
                }
            })
            .disposed(by: disposeBag)
        
        output.isCheckBoxChecked
            .drive(onNext: { [weak self] isChecked in
                self?.checkBox.setChecked(isChecked)
            })
            .disposed(by: disposeBag)
        
        output.isFilterApplied
            .drive(filteringState)
            .disposed(by: disposeBag)
    }
    
    private func updateButtonState(for buttonGroup: UIStackView?, selectedValue: String?) {
        guard let buttonGroup = buttonGroup else { return }
        buttonGroup.arrangedSubviews.compactMap { $0 as? CustomOnboardingButton }.forEach { button in
            let isSelected = (button.originalTitle == selectedValue)
            isSelected ? button.selectButton() : button.deselectButton()
        }
    }
}
