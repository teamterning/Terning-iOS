//
//  JobCardModel.swift
//  Terning-iOS
//
//  Created by 김민성 on 7/10/24.
//

import UIKit

struct JobCardModel: Codable {
    let scrapId: Int?
    let intershipAnnouncementId: Int
    let title: String
    let dDay: String
    let workingPeriod: String
    let companyImage: String
    let isScrapped: Bool
    let deadline: String
    let startYearMonth: String
}
