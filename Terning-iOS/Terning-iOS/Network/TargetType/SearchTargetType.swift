//
//  SearchTargetType.swift
//  Terning-iOS
//
//  Created by 이명진 on 7/16/24.
//

import Foundation
import Moya

enum SearchTargetType {
    case getSearchResult(keyword: String, sortBy: String, page: Int, size: Int)
    case getMostViewDatas
    case getMostScrapDatas
    case getAdvertiseDatas
}

extension SearchTargetType: TargetType {
    
    var baseURL: URL {
        guard let url = URL(string: Config.baseURL) else {
            fatalError("baseURL could not be configured")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .getSearchResult:
            return "/search"
        case .getMostViewDatas:
            return "/search/views"
        case .getMostScrapDatas:
            return "/search/scraps"
        case .getAdvertiseDatas:
            return "/search/advertisement"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getSearchResult, .getMostViewDatas, .getMostScrapDatas, .getAdvertiseDatas:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getMostViewDatas, .getMostScrapDatas, .getAdvertiseDatas:
            return .requestPlain
        case .getSearchResult(let keyword, let sortBy, let page, let size):
            return .requestParameters(parameters: ["keyword": keyword, "sortBy": sortBy, "page": page, "size": size], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return Config.headerWithAccessToken
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}
