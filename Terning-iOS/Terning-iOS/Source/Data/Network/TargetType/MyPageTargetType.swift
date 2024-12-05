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
    case patchProfileInfo(name: String, profileImage: String)
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
        case .patchProfileInfo:
            return "/mypage/profile"
        case .logout:
            return "/auth/logout"
        case .withdraw:
            return "/auth/withdraw"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getProfileInfo:
            return .get
        case .patchProfileInfo:
            return .patch
        case .logout:
            return .post
        case .withdraw:
            return .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getProfileInfo, .logout, .withdraw:
            return .requestPlain
        case .patchProfileInfo(let name, let profileImage):
            return .requestParameters(
                parameters: [
                    "name": name,
                    "profileImage": profileImage
                ],
                encoding: JSONEncoding.default
            )
        }
    }
    
    var headers: [String: String]? {
        return Config.defaultHeader
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}
