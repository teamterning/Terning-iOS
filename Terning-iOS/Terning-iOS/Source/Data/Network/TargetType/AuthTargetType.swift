//
//  AuthTargetType.swift
//  Terning-iOS
//
//  Created by 이명진 on 7/16/24.
//

import Foundation
import Moya

enum AuthTargetType {
    case signIn(authType: String)
    case getNewToken
    case signUp(name: String, profileImage: String, authType: String)
    case postOnboarding(grade: String, workingPeriod: String, startYear: Int, startMonth: Int)
}

extension AuthTargetType: TargetType {
    var baseURL: URL {
        guard let url = URL(string: Config.baseURL) else {
            fatalError("baseURL could not be configured")
        }
        
        return url
    }
    
    var path: String {
        switch self {
        case .signIn:
            return "/auth/sign-in"
        case .getNewToken:
            return "/auth/token-reissue"
        case .signUp:
            return "/auth/sign-up"
        case .postOnboarding:
            return "/auth/sign-up/filter"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .signIn, .signUp, .getNewToken, .postOnboarding:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .signIn(let authType):
            return .requestParameters(parameters: ["authType": authType], encoding: JSONEncoding.default)
        case .getNewToken:
            return .requestParameters(
                parameters: ["Authorization": Config.refreshToken],
                encoding: JSONEncoding.default
            )
        case .signUp(let name, let profileImage, let authType):
            return .requestParameters(
                parameters: [
                    "name": name,
                    "profileImage": profileImage,
                    "authType": authType
                ],
                encoding: JSONEncoding.default
            )
        case .postOnboarding(let grade, let workingPeriod, let startYear, let startMonth):
            return .requestParameters(
                parameters: [
                    "grade": grade,
                    "workingPeriod": workingPeriod,
                    "startYear": startYear,
                    "startMonth": startMonth
                ],
                encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        var headers: [String: String] = ["Content-Type": "application/json"]
        switch self {
        case .signIn:
            if let authType = UserManager.shared.authType {
                switch authType {
                case "KAKAO":
                    if let kakaoToken = UserManager.shared.kakaoAccessToken {
                        headers["Authorization"] = "Bearer \(kakaoToken)"
                    }
                case "APPLE":
                    if let appleToken = UserManager.shared.appleAccessToken {
                        headers["Authorization"] = "Bearer \(appleToken)"
                    }
                default:
                    break
                }
            }
        case .getNewToken:
            if let refreshToken = UserManager.shared.refreshToken {
                headers["Authorization"] = "Bearer \(refreshToken)"
            }
        case .signUp:
            headers["Authorization"] = Config.authId
        case .postOnboarding:
            return Config.userIdHeader
        }
        return headers
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}
