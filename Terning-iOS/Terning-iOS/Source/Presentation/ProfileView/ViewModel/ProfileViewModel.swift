//
//  ProfileViewModel.swift
//  Terning-iOS
//
//  Created by 정민지 on 7/10/24.
//

import RxCocoa
import RxSwift

final class ProfileViewModel {
    private let disposeBag = DisposeBag()
    
    let nameRelay = BehaviorRelay<String>(value: "")
    private let nameValidationMessageRelay = BehaviorRelay<ValidationMessage>(value: .defaultMessage)
    
    // MARK: - Input
    
    struct Input {
        let name: Observable<String>
    }
    
    // MARK: - Output
    
    struct Output {
        let nameCountText: Observable<String>
        let isNameValid: Observable<Bool>
        let nameValidationMessage: Observable<ValidationMessage>
    }
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        input.name
            .bind(to: nameRelay)
            .disposed(by: disposeBag)

        let isNameValid = nameRelay
            .map { [weak self] name -> Bool in
                guard let self = self else { return false }
                let isValid = !name.isEmpty && name.count <= 12 && !self.containsSpecialCharacters(name) && !self.containsSymbols(name)
                return isValid
            }
            .share(replay: 1, scope: .whileConnected)
        
        let nameCountText = nameRelay
            .map { "\($0.count)/12" }
            .share(replay: 1, scope: .whileConnected)
        
        let nameValidationMessage = nameValidationMessageRelay.asObservable()
        
        return Output(
            nameCountText: nameCountText,
            isNameValid: isNameValid,
            nameValidationMessage: nameValidationMessage
        )
    }
    
    private func containsSpecialCharacters(_ string: String) -> Bool {
        let regex = "[\\p{S}\\p{C}]"
        return string.range(of: regex, options: .regularExpression) != nil
    }
    
    private func containsSymbols(_ string: String) -> Bool {
        let regex = "[!@#$%^&*(),.?\":;'/{}\\[\\]|<>+=\\-_\\\\\\ \\—]"
        return string.range(of: regex, options: .regularExpression) != nil
    }
    
    func validateInput(newText: String) -> Bool {
        if newText.isEmpty {
            nameValidationMessageRelay.accept(.defaultMessage)
        } else if newText.count > 12 {
            nameValidationMessageRelay.accept(.tooLong)
            return false
        } else if containsSpecialCharacters(newText) {
            nameValidationMessageRelay.accept(.containsSpecialCharacters)
        } else if containsSymbols(newText) {
            nameValidationMessageRelay.accept(.containsSymbols)
        } else {
            nameValidationMessageRelay.accept(.valid)
        }
        return true
    }
}
