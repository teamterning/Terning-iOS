//
//  ScrapedAndDeadlineModel.swift
//  Terning-iOS
//
//  Created by 김민성 on 7/10/24.
//

import UIKit

struct ScrapedAndDeadlineModel: Codable {
    let scrapId: Double
    let internshipAnnouncementId: Double
    let companyImage: String
    let title: String
    let dDay: String
    let deadline: String
    let workingPeriod: String
    let startYearMonth: String
    let color: String
}
