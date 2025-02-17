//
//  WorkingPeriod.swift
//  Terning-iOS
//
//  Created by 정민지 on 12/28/24.
//

import Foundation

enum WorkingPeriod: String, CaseIterable, Codable {
    case short = "1개월 ~ 3개월"
    case middle = "4개월 ~ 6개월"
    case long = "7개월 이상"
    
    var displayName: String {
        return self.rawValue
    }
    
    var englishValue: String {
        switch self {
        case .short:
            return "short"
        case .middle:
            return "middle"
        case .long:
            return "long"
        }
    }
    
    var description: String {
        switch self {
        case .short:
            return "짧은 기간 안에 유의미한 스펙을 쌓을 수 있어요!"
        case .middle:
            return "회사와 직무에 대해 이해하기 적당한 기간이에요!"
        case .long:
            return "오랜 기간 내 커리어에 맞는 직무경험을 만들 수 있어요!"
        }
    }
}

extension WorkingPeriod {
    static func fromEnglishValue(_ value: String) -> WorkingPeriod? {
        return WorkingPeriod.allCases.first { $0.englishValue == value }
    }
}
