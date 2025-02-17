//
//  JobDetailModel.swift
//  Terning-iOS
//
//  Created by 이명진 on 7/8/24.
//

import Foundation

struct JobDetailModel: Codable {
    let companyImage: String
    let dDay: String
    let title: String
    let workingPeriod: String
    var isScrapped: Bool
    let color: String?
    let deadline: String
    let startYearMonth: String
    let scrapCount: Int
    let viewCount: Int
    let company: String
    let companyCategory: String
    let qualification: String
    let jobType: String
    let detail: String
    let url: String
}

struct CompanyInfoModel {
    let companyImage: String?
    let company: String
    let companyCategory: String
}

struct MainInfoModel {
    let dDay: String
    let title: String
    let viewCount: Int
}

struct InfoItem {
    let title: String
    let description: String
}

struct SummaryInfoModel {
    let items: [InfoItem]
}

struct ConditionInfoModel {
    let items: [InfoItem]
}

struct DetailInfoModel {
    let detail: String
}

struct BottomInfoModel {
    let url: String?
    let isScrapped: Bool
    let scrapCount: Int
}
