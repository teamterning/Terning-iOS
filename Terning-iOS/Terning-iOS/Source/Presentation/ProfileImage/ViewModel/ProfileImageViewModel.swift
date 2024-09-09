//
//  ProfileImageViewModel.swift
//  Terning-iOS
//
//  Created by 정민지 on 7/17/24.
//

import RxCocoa
import RxSwift

final class ProfileImageViewModel: ViewModelType {
    
    // MARK: - Properties
    
    private let profileImageNames: [String] = [
        "basic",
        "lucky",
        "smart",
        "glass",
        "calendar",
        "passion"
    ]

    // MARK: - Input
    
    struct Input {
        var initialSelectedImageString: String
    }
    
    // MARK: - Output
    
    struct Output {
        let initialIndex: Observable<Int>
    }
    
    // MARK: - Transform
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let initialIndex = Observable.just(input.initialSelectedImageString)
            .map { [weak self] imageString -> Int in
                return self?.profileImageNames.firstIndex(of: imageString) ?? 0
            }
        
        return Output(
            initialIndex: initialIndex
        )
    }
}
