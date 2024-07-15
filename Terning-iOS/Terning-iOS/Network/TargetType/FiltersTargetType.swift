//
//  FiltersTargetType.swift
//  Terning-iOS
//
//  Created by 이명진 on 7/16/24.
//

import Foundation
import Moya

enum FiltersTargetType {
    case getFilterDatas
    case setFilterDatas(grade: Int, workingPeriod: Int, startYear: Int, startMonth: Int)
}

extension FiltersTargetType: TargetType {
    
    var baseURL: URL {
        guard let url = URL(string: Config.baseURL) else {
            fatalError("baseURL could not be configured")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .getFilterDatas, .setFilterDatas:
            return "/filters"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getFilterDatas:
            return .post
        case .setFilterDatas:
            return .put
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getFilterDatas:
            return .requestPlain
        case .setFilterDatas(let grade, let workingPeriod, let startYear, let startMonth):
            return .requestParameters(
                parameters: [
                    "grade": grade,
                    "workingPeriod": workingPeriod,
                    "startYear": startYear,
                    "startMonth": startMonth
                ],
                encoding: JSONEncoding.default
            )
        }
    }
    
    var headers: [String: String]? {
        return Config.headerWithAccessToken
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}

