//
//  TodayScrapModel.swift
//  Terning-iOS
//
//  Created by 이명진 on 7/13/24.
//

import Foundation

struct TodayScrapModel: Codable {
    let todayScraps: [TodayScrap]
}

struct TodayScrap: Codable {
    let scrapId: Int
    let internshipAnnouncementId: Int
    let title: String
    let dDay: String
    let workingPeriod: String
    let color: String
    let companyImage: String
}
