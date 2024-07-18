//
//  DailyModel.swift
//  Terning-iOS
//
//  Created by 이명진 on 7/13/24.
//

import Foundation

// MARK: - MonthlyScrapModel

struct ScrapsByDeadlineModel: Codable {
    let deadline: String
    let scraps: [DailyScrapModel]
}
// MARK: - DailyScrapModel

struct DailyScrapModel: Codable {
    let scrapId: Int
    let title: String
    let color: String
    let internshipAnnouncementId: Int?
    let dDay: String?
    let workingPeriod: String?
    let companyImage: String?
    let startYear: Int?
    let startMonth: Int?
}
