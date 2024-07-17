//
//  ScrapsTargetType.swift
//  Terning-iOS
//
//  Created by 이명진 on 7/16/24.
//

import Foundation
import Moya

enum ScrapsTargetType {
    case addScrap(internshipAnnouncementId: Double, color: Int)
    case removeScrap(scrapId: Double)
    case patchScrap(scrapId: Double, color: Int)
}

extension ScrapsTargetType: TargetType {
    
    var baseURL: URL {
        guard let url = URL(string: Config.baseURL) else {
            fatalError("baseURL could not be configured")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .addScrap(let id, _),
                .removeScrap(let id),
                .patchScrap(let id, _):
            return "/scraps/\(id)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .addScrap:
            return .post
        case .removeScrap:
            return .delete
        case .patchScrap:
            return .patch
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .addScrap(_, let color), .patchScrap(_, let color):
            return .requestParameters(parameters: ["color": color], encoding: JSONEncoding.default)
        case .removeScrap:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        return Config.headerWithAccessToken
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}
