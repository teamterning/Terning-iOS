//
//  LoginViewModel.swift
//  Terning-iOS
//
//  Created by 정민지 on 7/13/24.
//

import RxSwift
import RxCocoa

final class LoginViewModel: ViewModelType {
    
    private let userInfoRelay = PublishRelay<Bool>()
    
    private let loginRepository: LoginRepositoryProtocol
    
    init(loginRepository: LoginRepositoryProtocol) {
        self.loginRepository = loginRepository
    }
    
    // MARK: - Input
    
    struct Input {
        let kakaoLoginDidTap: Observable<Void>
        let appleLoginDidTap: Observable<Void>
    }
    
    // MARK: - Output
    
    struct Output {
        let loginSuccess: Driver<Bool>
    }
    
    // MARK: - Transform
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let kakaoLoginSuccess = input.kakaoLoginDidTap
            .flatMapLatest { _ in
                
                self.loginRepository.loginWithKakao()
                    .catchAndReturn(false)
            }
        
        let appleLoginSuccess = input.appleLoginDidTap
            .flatMapLatest { _ in
                self.loginRepository.loginWithApple()
                    .catchAndReturn(false)
            }
        
        let loginSuccess = Observable.merge(kakaoLoginSuccess, appleLoginSuccess)
            .asDriver(onErrorJustReturn: false)
        
        return Output(loginSuccess: loginSuccess)
    }
}
