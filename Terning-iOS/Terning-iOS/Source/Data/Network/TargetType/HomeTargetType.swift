//
//  HomeTargetType.swift
//  Terning-iOS
//
//  Created by 이명진 on 7/16/24.
//

import Foundation
import Moya

enum HomeTargetType {
    case getHomeToday
    case getHome(sortBy: String, page: Int)
}

extension HomeTargetType: TargetType {
    var baseURL: URL {
        guard let url = URL(string: Config.baseURL) else {
            fatalError("baseURL could not be configured")
        }
        
        return url
    }
    
    var path: String {
        switch self {
        case .getHomeToday:
            return "/home/upcoming"
        case .getHome:
            return "/home"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getHomeToday, .getHome:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getHomeToday:
            return .requestPlain
            
        case .getHome(let sortBy, let page):
            let parameters: [String: Any] = [
                "sortBy": sortBy,
                "page": page
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        return Config.defaultHeader
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}
