//
//  SearchResultModel.swift
//  Terning-iOS
//
//  Created by 정민지 on 7/18/24.
//

import Foundation

// MARK: - SearchResultModel

struct SearchResultModel: Codable {
    let totalPages: Int
    let totalCount: Int
    let hasNext: Bool
    let announcements: [AnnouncementModel]
}
