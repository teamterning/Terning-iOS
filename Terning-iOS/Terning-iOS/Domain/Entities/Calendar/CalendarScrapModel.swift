//
//  CalendarScrapModel.swift
//  Terning-iOS
//
//  Created by 이명진 on 9/14/24.
//

import Foundation

// MARK: - CalendarScrapModel

struct CalendarScrapModel: Codable {
    let deadline: String
    let scraps: [ScrapModel]
}
