//
//  CalendarTargetType.swift
//  Terning-iOS
//
//  Created by 이명진 on 7/16/24.
//

import Foundation
import Moya

enum CalendarTargetType {
    case getMonthlyDefault(year: Int, month: Int)
    case getMonthlyList(year: Int, month: Int)
    case getDaily(date: String)
}

extension CalendarTargetType: TargetType {
    var baseURL: URL {
        guard let url = URL(string: Config.baseURL) else {
            fatalError("baseURL could not be configured")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .getMonthlyDefault:
            return "/calendar/monthly-default"
        case .getMonthlyList:
            return "/calendar/monthly-list"
        case .getDaily:
            return "/calendar/daily"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getMonthlyDefault, .getMonthlyList, .getDaily:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getMonthlyDefault(let year, let month), .getMonthlyList(let year, let month):
            return .requestParameters(parameters: ["year": year, "month": month], encoding: URLEncoding.default)
        case .getDaily(let date):
            return .requestParameters(parameters: ["date": date], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        return Config.defaultHeader
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}
