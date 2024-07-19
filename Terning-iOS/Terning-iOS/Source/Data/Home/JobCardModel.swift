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
                isScraped: false
            ),
            
            JobCardModel(
                scrapId: 2,
                internshipAnnouncementId: 4,
                title: "[보더엑스] 글로벌 마케팅 AE (채용연계형 인턴십)",
                dDay: "D-8",
                workingPeriod: "3개월",
                companyImage: "https://res.cloudinary.com/linkareer/image/fetch/f_auto,q_50/https://api.linkareer.com/attachments/397824",
                isScraped: false
            ),
            
            JobCardModel(
                scrapId: 3,
                internshipAnnouncementId: 2,
                title: "[카카오페이] 카카오페이 보험 운영 어시스턴트 채용",
                dDay: "D-17",
                workingPeriod: "2개월",
                companyImage: "https://res.cloudinary.com/linkareer/image/fetch/f_auto,q_50/https://api.linkareer.com/attachments/397824",
                isScraped: true
            ),
            
            JobCardModel(
                scrapId: 4,
                internshipAnnouncementId: 3,
                title: "[번개장터] Data Analyst",
                dDay: "지원 마감",
                workingPeriod: "3개월",
                companyImage: "https://res.cloudinary.com/linkareer/image/fetch/f_auto,q_50/https://api.linkareer.com/attachments/397824",
                isScraped: false
            ),
            
            JobCardModel(
                scrapId: 5,
                internshipAnnouncementId: 5,
                title: "[번개장터] Data Analyst",
                dDay: "지원 마감",
                workingPeriod: "3개월",
                companyImage: "https://res.cloudinary.com/linkareer/image/fetch/f_auto,q_50/https://api.linkareer.com/attachments/397824",
                isScraped: false
            ),
            
            JobCardModel(
                scrapId: 6,
                internshipAnnouncementId: 7,
                title: "[카카오페이] 카카오페이 보험 운영 어시스턴트 채용",
                dDay: "D-17",
                workingPeriod: "2개월",
                companyImage: "https://res.cloudinary.com/linkareer/image/fetch/f_auto,q_50/https://api.linkareer.com/attachments/397824",
                isScraped: true
            ),
            
            JobCardModel(
                scrapId: 7,
                internshipAnnouncementId: 6,
                title: "[번개장터] Content Marketer",
                dDay: "D-DAY",
                workingPeriod: "1개월",
                companyImage: "https://res.cloudinary.com/linkareer/image/fetch/f_auto,q_50/https://api.linkareer.com/attachments/397824",
                isScraped: false
            ),
            
            JobCardModel(
                scrapId: 8,
                internshipAnnouncementId: 9,
                title: "[카카오페이] 카카오페이 보험 운영 어시스턴트 채용",
                dDay: "D-17",
                workingPeriod: "2개월",
                companyImage: "https://res.cloudinary.com/linkareer/image/fetch/f_auto,q_50/https://api.linkareer.com/attachments/397824",
                isScraped: true
            ),
            
            JobCardModel(
                scrapId: 9,
                internshipAnnouncementId: 8,
                title: "[보더엑스] 글로벌 마케팅 AE (채용연계형 인턴십)",
                dDay: "D-8",
                workingPeriod: "3개월",
                companyImage: "https://res.cloudinary.com/linkareer/image/fetch/f_auto,q_50/https://api.linkareer.com/attachments/397824",
                isScraped: false
            ),
            
            JobCardModel(
                scrapId: 10,
                internshipAnnouncementId: 10,
                title: "[번개장터] Content Marketer",
                dDay: "D-DAY",
                workingPeriod: "1개월",
                companyImage: "https://res.cloudinary.com/linkareer/image/fetch/f_auto,q_50/https://api.linkareer.com/attachments/397824",
                isScraped: false
            )
        ]
    }
}
