//
//  ScrapedAndDeadlineModel.swift
//  Terning-iOS
//
//  Created by 김민성 on 7/10/24.
//

import UIKit

struct UpcomingCardModel: Codable {
    let hasScrapped: Bool
    let scraps: [AnnouncementModel]
}
