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

struct MainInfoModel {
    let dDay: String
    let title: String
    let deadline: String
    let workingPeriod: String
    let startDate: String
    let viewCount: Int
}

struct CompanyInfoModel {
    let company: String
    let companyCategory: String
    let companyImage: String?
}

struct SummaryInfoModel {
    let qualification: [String]
    let jobType: [String]
}

struct DetailInfoModel {
    let detail: String
}

struct BottomInfoModel {
    let url: String?
    let scrapId: Int?
    let scrapCount: Int
}
