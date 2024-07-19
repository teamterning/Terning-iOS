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
    let hasNext: Bool
    let announcements: [SearchResult]
}

struct SearchResult: Codable {
    let internshipAnnouncementId: Int
    let scrapId: Int?
    let dDay: String
    let deadline: String
    let companyImage: String
    let title: String
    let workingPeriod: String
    let startYearMonth: String
    let color: String?
}
