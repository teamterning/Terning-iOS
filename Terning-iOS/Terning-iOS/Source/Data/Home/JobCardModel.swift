//
//  JobCardModel.swift
//  Terning-iOS
//
//  Created by 김민성 on 7/10/24.
//

import UIKit

struct JobCardModel: Codable {
    let scrapId: Int?
    let internshipAnnouncementId: Int
    let title: String
    let dDay: String
    let workingPeriod: String
    let companyImage: String
    let isScraped: Bool
    let deadline: String
    let startYearMonth: String
}

// dummy data
extension JobCardModel {
    static func getJobCardData() -> [JobCardModel] {
        return [
            JobCardModel(
                scrapId: 1,
                internshipAnnouncementId: 1,
                title: "[번개장터] Content Marketer",
                dDay: "D-DAY",
                workingPeriod: "1개월",
                companyImage: "https://res.cloudinary.com/linkareer/image/fetch/f_auto,q_50/https://api.linkareer.com/attachments/397824",
                isScraped: false,
                deadline: "2024-08-21",
                startYearMonth: "String"
            ),
            
            JobCardModel(
                scrapId: 1,
                internshipAnnouncementId: 1,
                title: "[번개장터] Content Marketer",
                dDay: "D-DAY",
                workingPeriod: "1개월",
                companyImage: "https://res.cloudinary.com/linkareer/image/fetch/f_auto,q_50/https://api.linkareer.com/attachments/397824",
                isScraped: false,
                deadline: "2024-08-21",
                startYearMonth: "String"
            ),
            
            JobCardModel(
                scrapId: 1,
                internshipAnnouncementId: 1,
                title: "[번개장터] Content Marketer",
                dDay: "D-DAY",
                workingPeriod: "1개월",
                companyImage: "https://res.cloudinary.com/linkareer/image/fetch/f_auto,q_50/https://api.linkareer.com/attachments/397824",
                isScraped: false,
                deadline: "2024-08-21",
                startYearMonth: "String"
            ),
        ]
    }
}
