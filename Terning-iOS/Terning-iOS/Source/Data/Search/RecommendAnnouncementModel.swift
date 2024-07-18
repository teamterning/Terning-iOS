//
//  RecommendAnnouncementModel.swift
//  Terning-iOS
//
//  Created by 정민지 on 7/16/24.
//

import Foundation

// MARK: - RecommendAnnouncementModel

struct RecommendAnnouncementModel: Codable {
    let announcements: [RecommendAnnouncement]?
}

struct RecommendAnnouncement: Codable {
    let internshipAnnouncementId: Int
    let companyImage: String
    let title: String
}
