//
//  ScrapedAndDeadlineModel.swift
//  Terning-iOS
//
//  Created by 김민성 on 7/10/24.
//

import UIKit

struct UpcomingCardModel: Codable {
    let hasScrapped: Bool
    let scraps: [UpcomingCard]
}

struct UpcomingCard: Codable {
    let internshipAnnouncementId: Double
    let companyImage: String
    let dDay: String
    let title: String
    let workingPeriod: String
    let isScrapped: Bool
    let color: String
    let deadline: String
    let startYearMonth: String
    let companyInfo: String
}
