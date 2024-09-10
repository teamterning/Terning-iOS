//
//  LoginService.swift
//  Terning-iOS
//
//  Created by 이명진 on 9/1/24.
//

import AuthenticationServices
import KakaoSDKUser
import RxSwift
import RxCocoa

protocol LoginServiceProtocol {
    func loginWithKakao() -> Observable<Bool>
    func loginWithApple() -> Observable<Bool>
}

final class LoginService: NSObject, LoginServiceProtocol {
    private let userInfoRelay = PublishRelay<Bool>()
    private let disposeBag = DisposeBag()

    // MARK: - Kakao Login

    func loginWithKakao() -> Observable<Bool> {
        return Observable<Bool>.create { observer in
            if UserApi.isKakaoTalkLoginAvailable() {
                UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
                    print("⭐️ kakao = \(oauthToken)")
                    
                    if let error = error {
                        print("⭐️ kakao Error isKakaoTalkLoginAvailable = \(error.localizedDescription)")
                        observer.onNext(false)
                        observer.onCompleted()
                    } else {
                        guard let oauthToken = oauthToken else {
                            observer.onNext(false)
                            observer.onCompleted()
                            return
                        }
                        
                        UserManager.shared.kakaoAccessToken = oauthToken.accessToken
                        
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
                            observer.onCompleted()
                        }
                    }
                }
            } else {
                UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
                    print("⭐️ kakao = \(oauthToken)")
                    
                    if let error = error {
                        print("❗️ kakao Error loginWithKakaoAccount = \(error.localizedDescription)")
                        observer.onNext(false)
                        observer.onCompleted()
                    } else {
                        // 토큰 저장
                        guard let oauthToken = oauthToken else {
                            observer.onNext(false)
                            observer.onCompleted()
                            return
                        }
                        
                        print("🍎 카카오 토큰 \(oauthToken.accessToken)")
                        
                        UserManager.shared.kakaoAccessToken = oauthToken.accessToken
                        
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

    // 애플 로그인
    func loginWithApple() -> Observable<Bool> {
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

extension LoginService: ASAuthorizationControllerDelegate {
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
            print("Token : \(String(describing: tokenStr))")
            
            UserManager.shared.appleAccessToken = tokenStr
            
            UserManager.shared.signIn(authType: "APPLE") { result in
                switch result {
                case .success(let type):
                    print(type)
                    self.userInfoRelay.accept(type)
                case .failure(let error):
                    print(error)
                    self.userInfoRelay.accept(false)
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
