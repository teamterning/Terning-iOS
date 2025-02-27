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
    case setFilterDatas(
        grade: String?,
        workingPeriod: String?,
        startYear: Int?,
        startMonth: Int?,
        jobType: String?
    )
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
            return .get
        case .setFilterDatas:
            return .put
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getFilterDatas:
            return .requestPlain
        case .setFilterDatas(
            let grade,
            let workingPeriod,
            let startYear,
            let startMonth,
            let jobType
        ):
            let parameters: [String: Any?] = [
                "grade": grade,
                "workingPeriod": workingPeriod,
                "startYear": startYear,
                "startMonth": startMonth,
                "jobType": jobType
            ]
            
            let nonNilParameters = parameters.mapValues { $0 ?? NSNull() }
            
            return .requestParameters(
                parameters: nonNilParameters,
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
