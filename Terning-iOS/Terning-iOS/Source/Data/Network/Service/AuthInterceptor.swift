//
//  AuthInterceptor.swift
//  Terning-iOS
//
//  Created by 이명진 on 7/16/24.
//

import Foundation

import Alamofire
import Moya

///// 토큰 만료 시 자동으로 refresh를 위한 서버 통신
final class AuthInterceptor: RequestInterceptor {
    
    static let shared = AuthInterceptor()
    
    private var retryCount = 0
    private let maxRetryCount = 3
    
    private init() {}
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        
        guard urlRequest.url?.absoluteString.hasPrefix(Config.baseURL) == true,
              let accessToken = UserManager.shared.accessToken,
              let refreshToken = UserManager.shared.refreshToken
        else {
            completion(.success(urlRequest))
            return
        }
        
        urlRequest.setValue(accessToken, forHTTPHeaderField: "accessToken")
        urlRequest.setValue(refreshToken, forHTTPHeaderField: "refreshToken")
        print("adator 적용 \(urlRequest.headers)")
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        print("retry 진입")
        guard retryCount < maxRetryCount,
              let response = request.task?.response as? HTTPURLResponse,
              response.statusCode == 401,
              let pathComponents = request.request?.url?.pathComponents,
              !pathComponents.contains("getNewToken")
        else {
            dump(error)
            completion(.doNotRetryWithError(error))
            return
        }
        
        UserManager.shared.getNewToken { result in
            switch result {
            case .success:
                print("Retry-토큰 재발급 성공")
                self.retryCount += 1
                completion(.retry)
            case .failure(let error):
                // 세션 만료 -> 로그인 화면으로 전환
                completion(.doNotRetryWithError(error))
            }
        }
    }
}
