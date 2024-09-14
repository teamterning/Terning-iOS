//
//  CalendarAnnouncementModel.swift
//  Terning-iOS
//
//  Created by 이명진 on 9/14/24.
//

import Foundation

// MARK: - CalendarAnnouncementModel

struct CalendarAnnouncementModel: Codable {
    let deadline: String
    let announcements: [AnnouncementModel]
}
