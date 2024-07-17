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

final class LoginViewModel: NSObject, ViewModelType {
    
    private let userInfoRelay = PublishRelay<Bool>()
    private let disposeBag = DisposeBag()
    private var authId: Int = 0
    
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
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
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
                        print("🍎 error: \(error)")
                        observer.onNext(false)
                        observer.onCompleted()
                    } else {
                        // 토큰 저장
                        guard let oauthToken = oauthToken else {
                            observer.onNext(false)
                            observer.onCompleted()
                            return
                        }
                        
                        UserManager.shared.signIn(authType: "KAKAO") { result in
                            switch result {
                            case .success(let type):
                                print(type)
                                observer.onNext(true)
                            case .failure(let error):
                                print(error)
                                observer.onNext(false)
                            }
                            observer.onCompleted()
                        }
                    }
                }
            } else {
                UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
                    if let error = error {
                        print(error)
                        observer.onNext(false)
                        observer.onCompleted()
                    } else {
                        // 토큰 저장
                        guard let oauthToken = oauthToken else {
                            observer.onNext(false)
                            observer.onCompleted()
                            return
                        }
                        
                        print("🍎 \(oauthToken.accessToken)")
                        
                        UserManager.shared.accessToken = oauthToken.accessToken
                        
                        UserManager.shared.signIn(authType: "KAKAO") { result in
                            switch result {
                            case .success(let type):
                                print(type)
                                observer.onNext(true)
                                observer.onCompleted()
                            case .failure(let error):
                                print(error)
                                observer.onNext(false)
                            }
                            
                        }
                    }
                }
            }
            return Disposables.create()
        }
    }
}

extension LoginViewModel {
    private func loginWithApple() -> Observable<Bool> {
        return Observable<Bool>.create { observer in
            self.requestAppleLogin()
                .subscribe(onNext: { success in
                    observer.onNext(success)
                    observer.onCompleted()
                }, onError: { error in
                    observer.onNext(false)
                    observer.onCompleted()
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    private func requestAppleLogin() -> Observable<Bool> {
        return Observable<Bool>.create { observer in
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self as? ASAuthorizationControllerPresentationContextProviding
            authorizationController.performRequests()
            
            self.userInfoRelay
                .take(1)
                .subscribe(onNext: { success in
                    observer.onNext(success)
                    observer.onCompleted()
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
}

// MARK: - Apple Login

extension LoginViewModel: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            let userIdentifier = appleIDCredential.user
            guard let identityToken = appleIDCredential.identityToken,
                  let tokenStr = String(data: identityToken, encoding: .utf8) else {
                self.userInfoRelay.accept(false)
                return
            }
            
            print("User ID : \(String(describing: userIdentifier))")
            print("token : \(String(describing: tokenStr))")
            
            UserManager.shared.signIn(authType: "APPLE") { [weak self] result in
                switch result {
                case .success(let type):
                    self?.userInfoRelay.accept(true)
                case .failure(let error):
                    print(error)
                    self?.userInfoRelay.accept(false)
                }
            }
            
        default:
            break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("[🍎] Apple Login error - \(error.localizedDescription)")
    }
}
