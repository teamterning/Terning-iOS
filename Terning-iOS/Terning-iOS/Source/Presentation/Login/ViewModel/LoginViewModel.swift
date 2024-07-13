//
//  LoginViewModel.swift
//  Terning-iOS
//
//  Created by 정민지 on 7/13/24.
//

import UIKit

import RxSwift
import RxCocoa

import KakaoSDKUser
import AuthenticationServices

final class LoginViewModel {
    private let disposeBag = DisposeBag()
    
    // MARK: - Input
    
    struct Input {
        let kakaoLoginButtonTapped: Observable<Void>
        let appleLoginButtonTapped: Observable<Void>
    }
    
    // MARK: - Output
    
    struct Output {
        let loginSuccess: Driver<Bool>
    }
    
    // MARK: - Transform
    
    func transform(_ input: Input) -> Output {
        let kakaoLoginSuccess = input.kakaoLoginButtonTapped
            .flatMapLatest { _ in
                self.loginWithKakaoTalk()
                    .catchAndReturn(false)
            }
        
        let appleLoginSuccess = input.appleLoginButtonTapped
            .flatMapLatest { _ in
                self.loginWithApple()
                    .catchAndReturn(false)
            }
        
        let loginSuccess = Observable.merge(kakaoLoginSuccess, appleLoginSuccess)
            .asDriver(onErrorJustReturn: false)
        
        return Output(loginSuccess: loginSuccess)
    }
}

extension LoginViewModel {
    private func loginWithKakaoTalk() -> Observable<Bool> {
        return Observable<Bool>.create { observer in
            if UserApi.isKakaoTalkLoginAvailable() {
                UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
                    if let error = error {
                        observer.onNext(false)
                    } else {
                        // 토큰 저장
                        observer.onNext(true)
                    }
                    observer.onCompleted()
                }
            } else {
                UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
                    if let error = error {
                        print(error)
                        observer.onNext(false)
                    } else {
                        // 토큰 저장
                        observer.onNext(true)
                    }
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
}

extension LoginViewModel {
    private func loginWithApple() -> Observable<Bool> {
        return Observable<Bool>.create { observer in

            observer.onNext(true)
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
}
