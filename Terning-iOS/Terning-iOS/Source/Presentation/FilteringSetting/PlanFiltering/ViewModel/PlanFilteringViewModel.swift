//  PlanFilteringViewModel.swift
//  Terning-iOS
//
//  Created by 정민지 on 12/28/24.
//

import UIKit

import RxSwift
import RxCocoa

final class PlanFilteringViewModel: ViewModelType {
    
    // MARK: - Properties
    
    private let hasNonNilValueRelay = BehaviorRelay<Bool>(value: false)
    private let isCheckBoxRelay = BehaviorRelay<Bool?>(value: nil)
    
    private let gradeRelay = BehaviorRelay<Grade?>(value: UserFilteringData.shared.grade)
    private let periodRelay = BehaviorRelay<WorkingPeriod?>(value: UserFilteringData.shared.workingPeriod)
    private let yearRelay = BehaviorRelay<Int?>(value: UserFilteringData.shared.startYear)
    private let monthRelay = BehaviorRelay<Int?>(value: UserFilteringData.shared.startMonth)
    private let isFilterAppliedRelay = BehaviorRelay<Bool>(value: false)
    
    // MARK: - Input
    
    struct Input {
        let gradeSelected: Observable<Grade?>
        let periodSelected: Observable<WorkingPeriod?>
        let yearSelected: Observable<Int?>
        let monthSelected: Observable<Int?>
        let checkBoxToggled: Observable<Bool>
    }
    
    // MARK: - Output
    
    struct Output {
        let selectedGrade: Driver<Grade?>
        let selectedPeriod: Driver<WorkingPeriod?>
        let selectedYear: Driver<Int?>
        let selectedMonth: Driver<Int?>
        let isCheckBoxChecked: Driver<Bool>
        let isFilterApplied: Driver<Bool>
    }
    
    // MARK: - Transform
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        input.gradeSelected
            .withLatestFrom(gradeRelay) { (newGrade, currentGrade) in
                return newGrade == currentGrade ? nil : newGrade
            }
            .subscribe(onNext: { grade in
                TemporaryFilteringData.shared.grade = grade
                self.gradeRelay.accept(grade)
            })
            .disposed(by: disposeBag)
        
        input.periodSelected
            .withLatestFrom(periodRelay) { (newPeriod, currentPeriod) in
                return newPeriod == currentPeriod ? nil : newPeriod
            }
            .subscribe(onNext: { period in
                TemporaryFilteringData.shared.workingPeriod = period
                self.periodRelay.accept(period)
            })
            .disposed(by: disposeBag)
        
        input.yearSelected
            .subscribe(onNext: { year in
                TemporaryFilteringData.shared.startYear = year
                self.yearRelay.accept(year)
            })
            .disposed(by: disposeBag)
        
        input.monthSelected
            .subscribe(onNext: { month in
                TemporaryFilteringData.shared.startMonth = month
                self.monthRelay.accept(month)
            })
            .disposed(by: disposeBag)
        
        input.checkBoxToggled
            .subscribe(onNext: { [weak self] isChecked in
                guard let self = self else { return }
                self.isCheckBoxRelay.accept(isChecked)

                if isChecked {
                    self.gradeRelay.accept(nil)
                    self.periodRelay.accept(nil)
                    self.yearRelay.accept(nil)
                    self.monthRelay.accept(nil)
                    self.hasNonNilValueRelay.accept(false)
                    
                    TemporaryFilteringData.shared.grade = nil
                    TemporaryFilteringData.shared.workingPeriod = nil
                }
            })
            .disposed(by: disposeBag)
        
        let combinedRelays = Observable
            .combineLatest(gradeRelay, periodRelay, yearRelay, monthRelay)
        
        let isCheckBoxChecked = Observable
            .combineLatest(combinedRelays, isCheckBoxRelay.asObservable())
            .map { [weak self] relays, isCheckBoxValue -> Bool in
                guard let self = self else { return false }
                let (grade, period, year, month) = relays
                let isAllNil = grade == nil && period == nil && year == nil && month == nil

                if let isCheckBoxValue = isCheckBoxValue {
                    if !isCheckBoxValue {
                        return false
                    }
                }

                if !isAllNil {
                    self.hasNonNilValueRelay.accept(true)
                }

                return isAllNil && !self.hasNonNilValueRelay.value
            }
            .distinctUntilChanged()
            .share(replay: 1, scope: .forever)
        
        let isFilterApplied = Observable
            .combineLatest(combinedRelays, isCheckBoxChecked)
            .map { relays, isCheckBoxChecked in
                let (grade, period, year, month) = relays
                if isCheckBoxChecked { return true }
                return grade != nil && period != nil && year != nil && month != nil
            }
            .distinctUntilChanged()
        
        return Output(
            selectedGrade: gradeRelay.asDriver(),
            selectedPeriod: periodRelay.asDriver(),
            selectedYear: yearRelay.asDriver(),
            selectedMonth: monthRelay.asDriver(),
            isCheckBoxChecked: isCheckBoxChecked.asDriver(onErrorJustReturn: false),
            isFilterApplied: isFilterApplied.asDriver(onErrorJustReturn: false)
        )
    }
}
