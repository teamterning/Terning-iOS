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
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .signIn:
            return .post
        case .getNewToken:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .signIn(let authType):
            return .requestParameters(parameters: ["authType": authType], encoding: JSONEncoding.default)
        case .getNewToken:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .signIn, .getNewToken:
            return Config.headerWithAccessToken
        }
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}
