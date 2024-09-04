//
//  JobCardModel.swift
//  Terning-iOS
//
//  Created by 김민성 on 7/10/24.
//

import UIKit

struct JobCardModel: Codable {
    let totalCount: Int
    let result: [JobCard]
}

struct JobCard: Codable {
    let intershipAnnouncementID: Int
    let companyImage: String
    let dDay, title, workingPeriod: String
    let isScrapped: Bool
    let color: String?
    let deadline, startYearMonth: String
}
