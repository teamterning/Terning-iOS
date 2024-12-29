//
//  Grade.swift
//  Terning-iOS
//
//  Created by 정민지 on 12/28/24.
//

import Foundation

enum Grade: String, CaseIterable, Codable {
    case freshman = "1학년"
    case sophomore = "2학년"
    case junior = "3학년"
    case senior = "4학년"
    
    var displayName: String {
        return self.rawValue
    }
    
    var englishValue: String {
        switch self {
        case .freshman:
            return "freshman"
        case .sophomore:
            return "sophomore"
        case .junior:
            return "junior"
        case .senior:
            return "senior"
        }
    }
    
    var description: String {
        switch self {
        case .freshman:
            return "대학생 인턴, 누구보다 빠르게 시작해 보세요!"
        case .sophomore:
            return "인턴이라는 좋은 기회로 단숨에 스펙업하세요!"
        case .junior:
            return "지금까지 준비한 역량을 인턴으로 발휘해 보세요!"
        case .senior:
            return "사회초년생으로 도약하는 마지막 단계를 경험하세요!"
        }
    }
}
