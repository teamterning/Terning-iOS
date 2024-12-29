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
    
    private let isFilterAppliedRelay = BehaviorRelay<Bool>(value: false)
    private let gradeRelay = BehaviorRelay<Grade?>(value: UserFilteringData.shared.grade)
    private let periodRelay = BehaviorRelay<WorkingPeriod?>(value: UserFilteringData.shared.workingPeriod)
    private let yearRelay = BehaviorRelay<Int?>(value: UserFilteringData.shared.startYear)
    private let monthRelay = BehaviorRelay<Int?>(value: UserFilteringData.shared.startMonth)
    private let checkBoxRelay = BehaviorRelay<Bool>(value: false)
    
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
        let isFilterApplied: Driver<Bool>
    }
    
    // MARK: - Transform
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        input.gradeSelected
            .subscribe(onNext: { grade in
                TemporaryFilteringData.shared.grade = grade
                self.gradeRelay.accept(grade)
            })
            .disposed(by: disposeBag)
        
        input.periodSelected
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
            .bind(to: checkBoxRelay)
            .disposed(by: disposeBag)
        
        Observable
            .combineLatest(gradeRelay, periodRelay, yearRelay, monthRelay, checkBoxRelay)
            .do(onNext: { grade, period, year, month, isChecked in
                    print("Grade: \(String(describing: grade))")
                    print("Period: \(String(describing: period))")
                    print("Year: \(String(describing: year))")
                    print("Month: \(String(describing: month))")
                    print("IsChecked: \(isChecked)")
                })
            .map { grade, period, year, month, isChecked in
                if isChecked { return true }
                return grade != nil && period != nil && year != nil && month != nil
            }
            .bind(to: isFilterAppliedRelay)
            .disposed(by: disposeBag)
        
        return Output(
            selectedGrade: gradeRelay.asDriver(),
            selectedPeriod: periodRelay.asDriver(),
            selectedYear: yearRelay.asDriver(),
            selectedMonth: monthRelay.asDriver(),
            isFilterApplied: isFilterAppliedRelay.asDriver()
        )
    }
}
