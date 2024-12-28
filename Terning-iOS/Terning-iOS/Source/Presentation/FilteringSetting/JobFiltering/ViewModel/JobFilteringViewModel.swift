//
//  JobFilteringViewModel.swift
//  Terning-iOS
//
//  Created by 정민지 on 12/28/24.
//

import UIKit

import RxSwift
import RxCocoa

final class JobFilteringViewModel: ViewModelType {
    
    // MARK: - Properties
    
    private let jobTypesRelay = BehaviorRelay<[JobType]>(value: JobType.allCases)
    private let selectedJobTypeRelay = BehaviorRelay<JobType?>(value: UserFilteringData.shared.jobType)
    
    // MARK: - Input
    
    struct Input {
        let jobSelected: Observable<IndexPath>
    }
    
    // MARK: - Output
    
    struct Output {
        let jobTypes: Driver<[JobType]>
        let selectedJobType: Driver<JobType?>
        let isFilterApplied: Driver<Bool>
    }
    
    // MARK: - Transform
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        input.jobSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                let selectedJob = JobType.allCases[indexPath.item]
                if self.selectedJobTypeRelay.value == selectedJob {
                    self.selectedJobTypeRelay.accept(nil)
                } else {
                    self.selectedJobTypeRelay.accept(selectedJob)
                }
            })
            .disposed(by: disposeBag)
        
        selectedJobTypeRelay
            .subscribe(onNext: { selectedJobType in
                TemporaryFilteringData.shared.jobType = selectedJobType
            })
            .disposed(by: disposeBag)
        
        let isFilterApplied = selectedJobTypeRelay
            .map { _ in true }
            .asDriver(onErrorJustReturn: false)
        
        return Output(
            jobTypes: jobTypesRelay.asDriver(),
            selectedJobType: selectedJobTypeRelay.asDriver(),
            isFilterApplied: isFilterApplied
        )
    }
}
