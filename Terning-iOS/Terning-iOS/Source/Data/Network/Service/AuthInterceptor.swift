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
    
    private init() {}
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        guard urlRequest.url?.absoluteString.hasPrefix(Config.baseURL) == true,
              let accessToken = UserManager.shared.accessToken
        else {
            completion(.success(urlRequest))
            return
        }
        
        var urlRequest = urlRequest
        urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        print("adator 적용 \(urlRequest.headers)")
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        print("retry 진입")
        guard let response = request.task?.response as? HTTPURLResponse,
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
                completion(.retry)
            case .failure(let error):
                // 세션 만료 -> 로그인 화면으로 전환
                completion(.doNotRetryWithError(error))
            }
        }
    }
}
