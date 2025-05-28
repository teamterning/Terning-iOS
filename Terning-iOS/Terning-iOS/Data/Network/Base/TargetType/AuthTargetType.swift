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
    case signUp(name: String, profileImage: String, authType: String, fcmToken: String)
    case postOnboarding(grade: String, workingPeriod: String, startYear: Int, startMonth: Int)
    case logout
    case withdraw
    case setUserFCMToken(fcmToken: String)
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
        case .logout:
            return "/auth/logout"
        case .withdraw:
            return "/auth/withdraw"
        case .setUserFCMToken:
            return "/auth/sync-user"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .signIn, .signUp, .getNewToken, .postOnboarding, .logout, .setUserFCMToken:
            return .post
        case .withdraw:
            return .delete
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
        case .signUp(let name, let profileImage, let authType, let fcmToken):
            return .requestParameters(
                parameters: [
                    "name": name,
                    "profileImage": profileImage,
                    "authType": authType,
                    "fcmToken": fcmToken
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
        case .setUserFCMToken(let fcmToken):
            return .requestParameters(
                parameters: ["fcmToken": fcmToken],
                encoding: JSONEncoding.default
            )
        case .logout, .withdraw:
            return .requestPlain
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
        case .logout, .withdraw:
            return Config.defaultHeader
        case .setUserFCMToken:
            return Config.headerWithAccessToken
        }
        return headers
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}
