//
//  JobType.swift
//  Terning-iOS
//
//  Created by 정민지 on 12/28/24.
//
 
import UIKit

enum JobType: String, CaseIterable, Codable {
    case plan = "기획/전략"
    case marketing = "마케팅/홍보"
    case admin = "사무/회계"
    case sales = "인사/영업"
    case design = "디자인/예술"
    case it = "개발/IT"
    case research = "연구/생산"
    case etc = "기타"
    case total = "전체"
    
    var displayName: String {
        return self.rawValue
    }
    
    var englishValue: String {
        switch self {
        case .plan:
            return "plan"
        case .marketing:
            return "marketing"
        case .admin:
            return "admin"
        case .sales:
            return "sales"
        case .design:
            return "design"
        case .it:
            return "it"
        case .research:
            return "research"
        case .etc:
            return "etc"
        case .total:
            return "total"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .plan:
            return UIImage.icPlan.withRenderingMode(.alwaysTemplate)
        case .marketing:
            return UIImage.icMarketing.withRenderingMode(.alwaysTemplate)
        case .admin:
            return UIImage.icAccounting.withRenderingMode(.alwaysTemplate)
        case .sales:
            return UIImage.icSales.withRenderingMode(.alwaysTemplate)
        case .design:
            return UIImage.icDesign.withRenderingMode(.alwaysTemplate)
        case .it:
            return UIImage.icIt.withRenderingMode(.alwaysTemplate)
        case .research:
            return UIImage.icResearch.withRenderingMode(.alwaysTemplate)
        case .etc:
            return UIImage.icExtra.withRenderingMode(.alwaysTemplate)
        case .total:
            return UIImage.icAll.withRenderingMode(.alwaysTemplate)
        }
    }
}

extension JobType {
    static func fromEnglishValue(_ value: String) -> JobType? {
        return JobType.allCases.first { $0.englishValue == value }
    }
}
