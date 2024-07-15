//
//  MyPageTargetType.swift
//  Terning-iOS
//
//  Created by 이명진 on 7/16/24.
//

import Foundation
import Moya

enum MyPageTargetType {
    case getProfileInfo
    case logout
    case withdraw
}

extension MyPageTargetType: TargetType {
    var baseURL: URL {
        guard let url = URL(string: Config.baseURL) else {
            fatalError("baseURL could not be configured")
        }
        
        return url
    }
    
    var path: String {
        switch self {
        case .getProfileInfo:
            return "/mypage/profile"
        case .logout:
            return "/mypage/logout"
        case .withdraw:
            return "/mypage/withdraw"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getProfileInfo:
            return .get
        case .logout:
            return .patch
        case .withdraw:
            return .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getProfileInfo, .logout, .withdraw:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return Config.headerWithAccessToken
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}
