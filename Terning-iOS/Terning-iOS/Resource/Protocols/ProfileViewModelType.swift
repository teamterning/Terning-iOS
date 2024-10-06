//
//  ProfileViewModelType.swift
//  Terning-iOS
//
//  Created by 정민지 on 9/8/24.
//

import UIKit

import RxSwift
import RxCocoa

protocol ProfileViewModelType {
    var userInfo: UserProfileInfoModel? { get }
    var nameRelay: BehaviorRelay<String> { get }
    var imageStringRelay: BehaviorRelay<String> { get }
    
    func transform(input: ProfileViewModelInput, disposeBag: DisposeBag) -> ProfileViewModelOutput
    func validateInput(newText: String) -> Bool
}

extension ProfileViewModelType {
    func characterCount(of string: String) -> Int {
        return string.count
    }
    
    func containsSpecialCharacters(_ string: String) -> Bool {
        let regex = "[\\p{S}\\p{C}]"
        return string.range(of: regex, options: .regularExpression) != nil
    }
    
    func containsSymbols(_ string: String) -> Bool {
        let regex = "[!@#$%^&*(),.?\":;'/{}\\[\\]|<>+=\\-_\\\\—…’‘’]"
        return string.range(of: regex, options: .regularExpression) != nil
    }
}

struct ProfileViewModelInput {
    let userInfo: Observable<UserProfileInfoModel>
    let name: Observable<String>
    let imageStringSubject: Observable<String>
    let saveButtonTap: Observable<Void>
}

struct ProfileViewModelOutput {
    let userInfo: Driver<UserProfileInfoModel>
    let text: Observable<String>
    let nameCountText: Observable<String>
    let isNameValid: Observable<Bool>
    let nameValidationMessage: Observable<ValidationMessage>
    let saveAlert: Driver<Void>
    let isSaveButtonEnabled: Observable<Bool>
}
