//
//  HomeViewModel.swift
//  Terning-iOS
//
//  Created by 이명진 on 12/27/24.
//

import RxSwift

final class HomeViewModel: ViewModelType {
    
    
    struct Input {
        let viewDidLoad: PublishSubject<Void>
    }
    
    
    struct Output {
        
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        
        
        return Output()
    }
}
