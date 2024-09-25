//
//  JobCardModel.swift
//  Terning-iOS
//
//  Created by 김민성 on 7/10/24.
//

import UIKit

struct JobCardModel: Codable {
    let totalCount: Int
    let result: [AnnouncementModel]
}

struct JobCard: Codable {
    let internshipAnnouncementId: Int
    let companyImage: String
    let dDay: String
    let title: String
    let workingPeriod: String
    let isScrapped: Bool
    let color: String?
    let deadline: String
    let startYearMonth: String
}
