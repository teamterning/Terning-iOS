//
//  JobCardModel.swift
//  Terning-iOS
//
//  Created by 김민성 on 7/10/24.
//

import UIKit

struct JobCardModel: Codable {
    let intershipAnnouncementId: Int
    let companyImage: String
    let dDay: String
    let title: String
    let workingPeriod: String
    let isScrapped: Bool
    let deadline: String
    let startYearMonth: String
    let totalCount: Int
}
