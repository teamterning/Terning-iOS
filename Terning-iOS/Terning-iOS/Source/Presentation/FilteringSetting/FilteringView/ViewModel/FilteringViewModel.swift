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
        let currentIndex: Observable<Int>
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
            .combineLatest(input.jobFilteringState, input.planFilteringState, input.currentIndex)
            .map { jobState, planState, currentIndex in
                if currentIndex == 0 {
                    return jobState
                } else if currentIndex == 1 {
                    return planState
                }
                return false
            }
            .asDriver(onErrorJustReturn: false)
        
        let saveAction: Observable<Event<Void>> = input.saveButtonTap
            .withLatestFrom(Observable.combineLatest(input.jobFilteringState, input.planFilteringState, input.currentIndex))
            .flatMapLatest { [weak self] _, _, currentIndex -> Observable<Void> in
                guard let self = self else { return .empty() }
                if currentIndex == 0 {
                    return self.filtersRepository.setFilterDatas(
                        grade: UserFilteringData.shared.grade?.englishValue,
                        workingPeriod: UserFilteringData.shared.workingPeriod?.englishValue,
                        startYear: UserFilteringData.shared.startYear,
                        startMonth: UserFilteringData.shared.startMonth,
                        jobType: TemporaryFilteringData.shared.jobType?.englishValue
                    )
                } else if currentIndex == 1 {
                    return self.filtersRepository.setFilterDatas(
                        grade: TemporaryFilteringData.shared.grade?.englishValue,
                        workingPeriod: TemporaryFilteringData.shared.workingPeriod?.englishValue,
                        startYear: TemporaryFilteringData.shared.startYear,
                        startMonth: TemporaryFilteringData.shared.startMonth,
                        jobType: UserFilteringData.shared.jobType?.englishValue
                    )
                }
                return .empty()
            }
            .materialize()
        
        let dismissModal = saveAction
            .withLatestFrom(input.currentIndex) { (event: Event<Void>, currentIndex: Int) -> Event<Void> in
                if case .next = event, currentIndex == 0 {
                    UserFilteringData.shared.jobType = TemporaryFilteringData.shared.jobType
                } else if case .next = event, currentIndex == 1 {
                    UserFilteringData.shared.grade = TemporaryFilteringData.shared.grade
                    UserFilteringData.shared.workingPeriod = TemporaryFilteringData.shared.workingPeriod
                    UserFilteringData.shared.startYear = TemporaryFilteringData.shared.startYear
                    UserFilteringData.shared.startMonth = TemporaryFilteringData.shared.startMonth
                }
                return event
            }
            .compactMap { event -> Void? in
                guard case .next = event else { return nil }
                return ()
            }
            .asDriver(onErrorDriveWith: .empty())

        return Output(
            isSaveButtonEnabled: isSaveButtonEnabled,
            dismissModal: dismissModal
        )
    }
}
