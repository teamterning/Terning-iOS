//
//  LoginRepository.swift
//  Terning-iOS
//
//  Created by 이명진 on 9/1/24.
//

import RxSwift

protocol LoginRepositoryProtocol {
    func loginWithKakao() -> Observable<Bool>
    func loginWithApple() -> Observable<Bool>
}

final class LoginRepository: LoginRepositoryProtocol {
    private let loginService: LoginServiceProtocol
    
    init(loginService: LoginServiceProtocol) {
        self.loginService = loginService
    }
    
    func loginWithKakao() -> Observable<Bool> {
        return loginService.loginWithKakao()
    }
    
    func loginWithApple() -> Observable<Bool> {
        return loginService.loginWithApple()
    }
}
