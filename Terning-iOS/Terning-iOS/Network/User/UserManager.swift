//
//  UserManager.swift
//  Terning-iOS
//
//  Created by 이명진 on 7/16/24.
//

import Foundation

import Moya

enum TNError: Error {
    case networkFail
    case etc
}

final class UserManager {
    static let shared = UserManager()
    
    private var authProvider = Providers.authProvider
    
    @UserDefaultWrapper<String>(key: "kakaoAccessToken") public var kakaoAccessToken // 카카오 토큰
    @UserDefaultWrapper<String>(key: "appleAccessToken") public var appleAccessToken // 애플 토큰
    @UserDefaultWrapper<String>(key: "accessToken") public var accessToken // 서버 토큰
    @UserDefaultWrapper<String>(key: "refreshToken") public var refreshToken
    @UserDefaultWrapper<Int>(key: "userId") public var userId
    @UserDefaultWrapper<String>(key: "authId") public var authId
    @UserDefaultWrapper<String>(key: "authType") public var authType
    
    var hasAccessToken: Bool { return self.accessToken != nil }
    var hasKakaoToken: Bool { return self.kakaoAccessToken != nil }
    var hasAppleToken: Bool { return self.appleAccessToken != nil }
    
    private init() {}
    
    func updateKakaoToken(token: String) {
        self.kakaoAccessToken = token
    }
    
    func updateAppleToken(token: String) {
        self.appleAccessToken = token
    }
    
    func updateToken(accessToken: String, refreshToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
    
    func signIn(authType: String, completion: @escaping(Result<Bool, TNError>) -> Void) {
        print("🍎🍎signIn 함수 시작🍎🍎")
        authProvider.request(.signIn(authType: authType)) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let result):
                let status = result.statusCode
                if 200..<300 ~= status {
                    do {
                        let responseDto = try result.map(BaseResponse<SignInResponseModel>.self)
                        guard let data = responseDto.result else {
                            completion(.failure(.networkFail))
                            return
                        }
                        
                        self.accessToken = data.accessToken
                        self.refreshToken = data.refreshToken
                        self.userId = data.userId
                        self.authId = data.authId
                        self.authType = data.authType
                        
                        completion(.success(true))
                    } catch {
                        print("🍎🍎🍎🍎\(error.localizedDescription)")
                        completion(.failure(.networkFail))
                    }
                } else if status >= 400 {
                    print("400 error")
                    completion(.failure(.networkFail))
                }
            case .failure(let error):
                print(" 🔥 🔥 \(error.localizedDescription)")
                if let response = error.response {
                    if let responseData = String(bytes: response.data, encoding: .utf8) {
                        print("\n 🔥 SignIn 메세지 \(responseData)\n")
                    } else {
                        print(" 🔥Failed to decode response data as UTF-8 string.")
                    }
                } else {
                    print(error.localizedDescription)
                }
                completion(.failure(.networkFail))
            }
        }
    }
    
    func getNewToken(completion: @escaping(Result<Bool, TNError>) -> Void) {
        authProvider.request(.getNewToken) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let result):
                let status = result.statusCode
                if 200..<300 ~= status {
                    do {
                        let responseModel = try result.map(BaseResponse<NewTokenModel>.self)
                        guard let data = responseModel.result else { return }
                        
                        self.accessToken = data.accessToken
                        completion(.success(true))
                    } catch {
                        print(error.localizedDescription)
                        completion(.failure(.networkFail))
                    }
                }
                if status >= 400 {
                    print("400 error")
                    completion(.failure(.networkFail))
                }
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(.networkFail))
            }
        }
    }
    
    func logout() {
        self.resetTokens()
    }
    
    private func resetTokens() {
        self.accessToken = nil
        self.refreshToken = nil
        self.userId = nil
        self.authType = nil
        self.kakaoAccessToken = nil
        self.appleAccessToken = nil
    }
}
