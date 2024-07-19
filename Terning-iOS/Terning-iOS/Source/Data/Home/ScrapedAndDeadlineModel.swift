//
//  ScrapedAndDeadlineModel.swift
//  Terning-iOS
//
//  Created by 김민성 on 7/10/24.
//

import UIKit

struct ScrapedAndDeadlineModel: Codable {
    let scrapId: Double
    let internshipAnnouncementId: Double
    let companyImage: String
    let title: String
    let dDay: String
    let deadLine: String
    let workingPeriod: String
    let startYearMonth: String
    let color: String
}

// dummy data
extension ScrapedAndDeadlineModel {
    static func getScrapedData() -> [ScrapedAndDeadlineModel] {
        return [
            ScrapedAndDeadlineModel(
                scrapId: 1,
                internshipAnnouncementId: 1,
                companyImage: "https://res.cloudinary.com/linkareer/image/fetch/f_auto,q_50/https://api.linkareer.com/attachments/397824",
                title: "[카카오페이] 카카오페이 보험 운영 어시스턴트 채용",
                dDay: "D-DAY",
                deadLine: "2024년 7월 14일",
                workingPeriod: "2개월",
                startYearMonth: "2024년 8월",
                color: "#45D0CC"
            ),
            
            ScrapedAndDeadlineModel(
                scrapId: 2,
                internshipAnnouncementId: 2,
                companyImage: "https://res.cloudinary.com/linkareer/image/fetch/f_auto,q_50/https://api.linkareer.com/attachments/397824",
                title: "[번개장터] Data Analyst",
                dDay: "D-DAY",
                deadLine: "2024년 7월 14일",
                workingPeriod: "3개월",
                startYearMonth: "2024년 8월",
                color: "#45D0CC"
            ),
            
            ScrapedAndDeadlineModel(
                scrapId: 1,
                internshipAnnouncementId: 1,
                companyImage: "https://res.cloudinary.com/linkareer/image/fetch/f_auto,q_50/https://api.linkareer.com/attachments/397824",
                title: "[카카오페이] 카카오페이 보험 운영 어시스턴트 채용",
                dDay: "D-DAY",
                deadLine: "2024년 7월 14일",
                workingPeriod: "2개월",
                startYearMonth: "2024년 8월",
                color: "#ED4E54"
            ),
            
            ScrapedAndDeadlineModel(
                scrapId: 2,
                internshipAnnouncementId: 2,
                companyImage: "https://res.cloudinary.com/linkareer/image/fetch/f_auto,q_50/https://api.linkareer.com/attachments/397824",
                title: "[번개장터] Data Analyst",
                dDay: "D-DAY",
                deadLine: "2024년 7월 14일",
                workingPeriod: "3개월",
                startYearMonth: "2024년 8월",
                color: "#45D0CC"
            )
        ]
    }
}
