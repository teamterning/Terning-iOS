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
        var selectedIndex: Observable<Int>
        var initialSelectedImageString: String
    }
    
    // MARK: - Output
    
    struct Output {
        let initialIndex: Observable<Int>
        let selectedImageString: Observable<String>
    }
    
    // MARK: - Transform
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let initialIndex = Observable.just(input.initialSelectedImageString)
            .map { [weak self] imageString -> Int in
                return self?.profileImageNames.firstIndex(of: imageString) ?? 0
            }
        
        let selectedImageString = input.selectedIndex
                   .map { [weak self] index -> String in
                       return self?.profileImageNames[index] ?? "basic"
                   }
        
        return Output(
            initialIndex: initialIndex,
            selectedImageString: selectedImageString
        )
    }
}
