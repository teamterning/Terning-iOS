//
//  ProfileImageViewModel.swift
//  Terning-iOS
//
//  Created by 정민지 on 7/17/24.
//

import RxCocoa
import RxSwift

final class ProfileImageViewModel: ViewModelType {
    
    // MARK: - Input
    
    struct Input {
        let saveButtonTapped: Observable<Void>
        let selectedIndex: Observable<Int>
    }
    
    // MARK: - Output
    
    struct Output {
        let savedIndex: Observable<Int>
    }
    
    private let savedIndexSubject = PublishSubject<Int>()
    
    // MARK: - Transform
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        input.saveButtonTapped
            .withLatestFrom(input.selectedIndex)
            .bind(to: savedIndexSubject)
            .disposed(by: disposeBag)
        
        return Output(
            savedIndex: savedIndexSubject.asObservable()
        )
    }
}
