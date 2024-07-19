//
//  JobCardModel.swift
//  Terning-iOS
//
//  Created by 김민성 on 7/10/24.
//

import UIKit

struct JobCardModel: Codable {
    let scrapId: Int?
    let internshipAnnouncementId: Int
    let title: String
    let dDay: String
    let workingPeriod: String
    let companyImage: String
    let isScraped: Bool
    let deadline: String
    let startYearMonth: String
    let color: String?
}
