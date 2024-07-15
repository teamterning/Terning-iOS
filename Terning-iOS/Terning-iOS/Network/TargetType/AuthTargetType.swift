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
    case signUp(name: String, profileImage: Int)
    case postOnboarding(grade: Int, workingPeriod: Int, startYear: Int, startMonth: Int)
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
            return .requestPlain
        case .signUp(let name, let profileImage):
            return .requestParameters(parameters: ["name": name, "profileImage": profileImage], encoding: JSONEncoding.default)
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
        switch self {
        case .signIn:
            return Config.defaultHeader
        case .getNewToken:
            return ["Content-Type": "application/json", "refreshToken": Config.refreshToken]
        case .signUp, .postOnboarding:
            return ["Content-Type": "application/json", "User-Id": Config.userId]
        }
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}
