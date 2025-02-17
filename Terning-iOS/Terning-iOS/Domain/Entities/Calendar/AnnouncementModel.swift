//
//  AnnouncementModel.swift
//  Terning-iOS
//
//  Created by 이명진 on 9/14/24.
//

import Foundation

// MARK: - AnnouncementModel

struct AnnouncementModel: Codable {
    let internshipAnnouncementId: Int
    let companyImage: String
    let dDay: String
    let title: String
    let workingPeriod: String
    var isScrapped: Bool
    let color: String?
    let deadline: String
    let startYearMonth: String
    let companyInfo: String?
}
