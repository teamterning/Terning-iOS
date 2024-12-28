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
    private let dateRelay = BehaviorRelay<Date?>(
        value: {
            guard let year = UserFilteringData.shared.startYear,
                  let month = UserFilteringData.shared.startMonth else { return nil }
            let components = DateComponents(year: year, month: month)
            return Calendar.current.date(from: components)
        }())
    private let checkBoxRelay = BehaviorRelay<Bool>(value: false)
    
    // MARK: - Input
    
    struct Input {
        let gradeSelected: Observable<Grade?>
        let periodSelected: Observable<WorkingPeriod?>
        let dateSelected: Observable<Date?>
        let checkBoxToggled: Observable<Bool>
    }
    
    // MARK: - Output
    
    struct Output {
        let selectedGrade: Driver<Grade?>
        let selectedPeriod: Driver<WorkingPeriod?>
        let selectedDate: Driver<Date?>
        let isFilterApplied: Driver<Bool>
    }
    
    // MARK: - Transform
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        input.gradeSelected
            .subscribe(onNext: { grade in
                TemporaryFilteringData.shared.grade = grade
            })
            .disposed(by: disposeBag)
        
        input.periodSelected
            .subscribe(onNext: { period in
                TemporaryFilteringData.shared.workingPeriod = period
            })
            .disposed(by: disposeBag)
        
        input.dateSelected
            .subscribe(onNext: { date in
                guard let date = date else { return }
                let components = Calendar.current.dateComponents([.year, .month], from: date)
                TemporaryFilteringData.shared.startYear = components.year
                TemporaryFilteringData.shared.startMonth = components.month
            })
            .disposed(by: disposeBag)
        
        input.checkBoxToggled
            .bind(to: checkBoxRelay)
            .disposed(by: disposeBag)
        
        Observable
            .combineLatest(gradeRelay, periodRelay, dateRelay, checkBoxRelay)
            .map { grade, period, date, isChecked in
                if isChecked { return true }
                return grade != nil && period != nil && date != nil
            }
            .bind(to: isFilterAppliedRelay)
            .disposed(by: disposeBag)
        
        return Output(
            selectedGrade: gradeRelay.asDriver(),
            selectedPeriod: periodRelay.asDriver(),
            selectedDate: dateRelay.asDriver(),
            isFilterApplied: isFilterAppliedRelay.asDriver()
        )
    }
}
