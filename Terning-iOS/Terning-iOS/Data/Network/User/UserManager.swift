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
    private let myPageProvider = Providers.myPageProvider
    
    @UserDefaultWrapper<String>(key: "kakaoAccessToken") public var kakaoAccessToken // 카카오 토큰
    @UserDefaultWrapper<String>(key: "appleAccessToken") public var appleAccessToken // 애플 토큰
    @UserDefaultWrapper<String>(key: "accessToken") public var accessToken // 서버 토큰
    @UserDefaultWrapper<String>(key: "refreshToken") public var refreshToken
    @UserDefaultWrapper<Int>(key: "userId") public var userId
    @UserDefaultWrapper<String>(key: "authId") public var authId
    @UserDefaultWrapper<String>(key: "authType") public var authType
    @UserDefaultWrapper<String>(key: "userName") public var userName
    
    // FCM 로직
    @UserDefaultWrapper<String>(key: "fcmToken") public var fcmToken
    @UserDefaultWrapper<String>(key: "lastSentFCMToken") public var lastSentFCMToken
    @NonOptionalUserDefaultWrapper<Bool>(key: "didSyncFCMToken", defaultValue: false) public var didSyncFCMToken
    
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
    
    func signIn(authType: String, completion: @escaping (Result<Bool, TNError>) -> Void) {
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
                } else if status == 429 {
                    print("🚫 429 Too Many Requests")
                    NotificationCenter.default.post(name: .didReceiveRateLimit, object: nil)
                    completion(.failure(.networkFail))
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
    
    func getNewToken(completion: @escaping (Result<Bool, TNError>) -> Void) {
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

extension UserManager {
    /// 푸시 알림 ON OFF 메서드
    func updatePushStatus(isEnabled: Bool) {
        let newStatus = isEnabled ? "ENABLED" : "DISABLED"
        myPageProvider.request(.updatePushStatus(newStatus: newStatus)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                if 200..<300 ~= statusCode {
                    do {
                        _ = try response.map(BaseResponse<BlankData>.self)
                        print("✅ 푸시 상태 서버 반영 성공: \(newStatus)")
                    } catch {
                        print(error.localizedDescription)
                        print("❌ 푸시 상태 반영 에러 - code: \(statusCode)")
                    }

                } else {
                    print("❌ 푸시 상태 반영 실패 - code: \(statusCode)")
                }

            case .failure(let error):
                print("❌ 푸시 상태 반영 실패: \(error.localizedDescription)")
            }
        }
    }
}

extension UserManager {
    
    /// 서버에 FCM 토큰을 전송하는 메서드 (최초 1회만 전송)
    func setUserFCMTokenToServer(fcmToken: String) {
        print("🧾 [FCM] 전송 시도 시작")
        print(" ⮕ 현재 FCM Token: \(fcmToken)")
        print(" ⮕ 저장된 마지막 전송 FCM Token: \(lastSentFCMToken ?? "없음")")
        print(" ⮕ 로그인 상태: \(hasAccessToken ? "✅ 있음" : "❌ 없음")")
        print(" ⮕ 동기화된 적 있음?: \(didSyncFCMToken ? "✅ 예" : "❌ 아니오")")
        
        // ✅ 조건: 로그인 + (아직 동기화 안 했거나, 저장된 토큰과 다를 때)
        guard hasAccessToken, (!didSyncFCMToken || lastSentFCMToken != fcmToken) else {
            print("🚫 전송 조건 불충족 → FCM 토큰 전송 안함\n")
            return
        }

        authProvider.request(.setUserFCMToken(fcmToken: fcmToken)) { result in
            switch result {
            case .success(let response):
                print("✅ FCM 토큰 서버 전송 성공 (statusCode: \(response.statusCode))")
                self.lastSentFCMToken = fcmToken
                self.didSyncFCMToken = true
            case .failure(let error):
                print("❌ FCM 토큰 서버 전송 실패: \(error.localizedDescription)")
            }
            print("🧾 [FCM] 전송 처리 종료\n")
        }
    }
}
