//
//  JobDetailModel.swift
//  Terning-iOS
//
//  Created by 이명진 on 7/8/24.
//

import Foundation

struct JobDetailModel: Codable {
    let dDay: String
    let title: String
    let deadline: String
    let workingPeriod: String
    let startDate: String
    let scrapCount: Int
    let viewCount: Int
    let company: String
    let companyCategory: String
    let companyImage: String
    let qualification: String
    let jobType: String
    let detail: String
    let url: String
    let scrapId: Int?
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
    let scrapId: Int?
    let scrapCount: Int
}
