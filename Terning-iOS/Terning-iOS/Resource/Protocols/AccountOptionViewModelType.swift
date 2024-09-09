//
//  AccountOptionViewModelType.swift
//  Terning-iOS
//
//  Created by 정민지 on 9/4/24.
//

import RxSwift
import RxCocoa

protocol AccountOptionViewModelType {
    var accountOption: AccountOption { get }
    
    func transform(input: AccountOptionViewModelInput, disposeBag: DisposeBag) -> AccountOptionViewModelOutput
}

struct AccountOptionViewModelInput {
    let yesButtonTap: Observable<Void>
    let noButtonTap: Observable<Void>
}

struct AccountOptionViewModelOutput {
    let showSplashScreen: Driver<Void>
    let dismissModal: Driver<Void>
}
