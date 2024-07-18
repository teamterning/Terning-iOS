//
//  AnnouncementsTargetType.swift
//  Terning-iOS
//
//  Created by 이명진 on 7/16/24.
//

import Foundation
import Moya

enum AnnouncementsTargetType {
    case getAnnouncements(internshipAnnouncementId: Int)
}

extension AnnouncementsTargetType: TargetType {
    
    var baseURL: URL {
        guard let url = URL(string: Config.baseURL) else {
            fatalError("baseURL could not be configured")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .getAnnouncements(let internshipAnnouncementId):
            return "/announcements/\(internshipAnnouncementId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getAnnouncements:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getAnnouncements:
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
