//
//  OnboardingViewModel.swift
//  Terning-iOS
//
//  Created by 정민지 on 7/11/24.
//

import UIKit

import RxSwift
import RxCocoa

final class OnboardingViewModel {
    private let disposeBag = DisposeBag()
    
    // MARK: - Input
    
    struct Input {
        let optionSelected: Observable<Int?>
        let dateSelected: Observable<Date?>
    }
    
    // MARK: - Output
    
    struct Output {
        let isNextButtonEnabled: Driver<Bool>
    }
    
    // MARK: - Transform
    
    func transform(_ input: Input) -> Output {
        input.optionSelected
            .subscribe(onNext: { _ in })
            .disposed(by: disposeBag)
        
        input.dateSelected
            .subscribe(onNext: { _ in })
            .disposed(by: disposeBag)
        
        let isNextButtonEnabled = Observable.combineLatest(
            input.optionSelected.startWith(nil),
            input.dateSelected.startWith(nil)
        )
        .map { option, date in
            return option != nil || date != nil
        }
        .asDriver(onErrorJustReturn: false)

        return Output(isNextButtonEnabled: isNextButtonEnabled)
    }
}
