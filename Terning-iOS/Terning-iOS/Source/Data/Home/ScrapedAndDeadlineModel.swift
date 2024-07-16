//
//  ScrapedAndDeadlineModel.swift
//  Terning-iOS
//
//  Created by 김민성 on 7/10/24.
//

import UIKit

struct ScrapedAndDeadlineModel {
    let scrapId: Double
    let internshipAnnouncementId: Double
    let companyImage: UIImage // API 연결 할 때 URL string으로 변경
    let title: String
    let dDay: String
    let deadLine: String
    let workingPeriod : String
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
                companyImage: UIImage(resource: .icHomeFill),
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
                companyImage: UIImage(resource: .icHomeFill),
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
                companyImage: UIImage(resource: .icHomeFill),
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
                companyImage: UIImage(resource: .icHomeFill),
                title: "[번개장터] Data Analyst",
                dDay: "D-DAY",
                deadLine: "2024년 7월 14일",
                workingPeriod: "3개월",
                startYearMonth: "2024년 8월",
                color: "#45D0CC"
            )
            
//            ScrapedAndDeadlineModel(
//                color: UIColor(resource: .calYellow).cgColor,
//                title: "[유한킴벌리] 그린캠프 w.대학생 숲활동가 모집3"
//            ),
//            
//            ScrapedAndDeadlineModel(
//                color: UIColor(resource: .calPurple).cgColor,
//                title: "[유한킴벌리] 그린캠프 w.대학생 숲활동가 모집3"
//            ),
//            
//            ScrapedAndDeadlineModel(
//                color: UIColor(resource: .calOrange).cgColor,
//                title: "[유한킴벌리] 그린캠프 w.대학생 숲활동가 모집3"
//            ),
//            
//            ScrapedAndDeadlineModel(
//                color: UIColor(resource: .calBlue1).cgColor,
//                title: "[유한킴벌리] 그린캠프 w.대학생 숲활동가 모집3"
//            )
        ]
    }
}
