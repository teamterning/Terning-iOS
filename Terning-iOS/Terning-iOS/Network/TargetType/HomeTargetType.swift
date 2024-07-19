//
//  HomeTargertType.swift
//  Terning-iOS
//
//  Created by 이명진 on 7/16/24.
//

import Foundation
import Moya

enum HomeTargertType {
    case getHomeToday
    case getHome(sortBy: String, startYear: Int, startMonth: Int)
}

extension HomeTargertType: TargetType {
    var baseURL: URL {
        guard let url = URL(string: Config.baseURL) else {
            fatalError("baseURL could not be configured")
        }
        
        return url
    }
    
    var path: String {
        switch self {
        case .getHomeToday:
            return "/home/today"
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
            
        case .getHome(let sortBy, let startYear, let startMonth):
            let parameters: [String: Any] = [
                "sortBy": sortBy,
                "startYear": startYear,
                "startMonth": startMonth
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json", "Authorization": "Bearer \(Config.refreshToken)"]
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}
