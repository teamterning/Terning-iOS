//
//  FilteringViewModel.swift
//  Terning-iOS
//
//  Created by 정민지 on 12/28/24.
//

import RxSwift
import RxCocoa

final class FilteringViewModel: ViewModelType {
    
    // MARK: - Properties
    
    private let filtersRepository: FiltersRepositoryInterface
    
    // MARK: - Input
    
    struct Input {
        let jobFilteringState: Observable<Bool>
        let planFilteringState: Observable<Bool>
        let saveButtonTap: Observable<Void>
    }
    
    // MARK: - Output
    
    struct Output {
        let isSaveButtonEnabled: Driver<Bool>
        let dismissModal: Driver<Void>
    }
    
    // MARK: - Init
    
    init(filtersRepository: FiltersRepositoryInterface) {
        self.filtersRepository = filtersRepository
    }
    
    // MARK: - Transform
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let isSaveButtonEnabled = Observable
            .combineLatest(input.jobFilteringState, input.planFilteringState)
            .map { jobState, planState in
                return jobState && planState
            }
            .asDriver(onErrorJustReturn: false)
        
        let saveAction: Observable<Event<Void>> = input.saveButtonTap
            .flatMapLatest {
                self.filtersRepository.setFilterDatas(
                    grade: TemporaryFilteringData.shared.grade?.englishValue,
                    workingPeriod: TemporaryFilteringData.shared.workingPeriod?.englishValue,
                    startYear: TemporaryFilteringData.shared.startYear,
                    startMonth: TemporaryFilteringData.shared.startMonth,
                    jobType: TemporaryFilteringData.shared.jobType?.englishValue
                )
                .materialize()
            }

        let dismissModal = saveAction
            .do(onNext: {_ in 
                UserFilteringData.shared.jobType = TemporaryFilteringData.shared.jobType
                UserFilteringData.shared.grade = TemporaryFilteringData.shared.grade
                UserFilteringData.shared.workingPeriod = TemporaryFilteringData.shared.workingPeriod
                UserFilteringData.shared.startYear = TemporaryFilteringData.shared.startYear
                UserFilteringData.shared.startMonth = TemporaryFilteringData.shared.startMonth
            })
            .map { _ in () }
            .asDriver(onErrorDriveWith: .empty())

        return Output(
            isSaveButtonEnabled: isSaveButtonEnabled,
            dismissModal: dismissModal
        )
    }
}
