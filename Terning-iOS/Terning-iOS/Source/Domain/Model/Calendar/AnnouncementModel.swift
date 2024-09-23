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
    let dDay, title, workingPeriod: String
    var isScrapped: Bool
    let color: String?
    let deadline, startYearMonth: String
}
