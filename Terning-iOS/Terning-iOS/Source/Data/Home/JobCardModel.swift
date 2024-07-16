//
//  JobCardModel.swift
//  Terning-iOS
//
//  Created by 김민성 on 7/10/24.
//

import UIKit

struct JobCardModel {
    let internshipAnnouncementId: Int
    let title: String
    let dDay: String
    let workingPeriod: String
    let companyImage: UIImage
    let isScraped: Bool
}

extension JobCardModel {
    static func getJobCardData() -> [JobCardModel] {
        return [
            JobCardModel(
                internshipAnnouncementId: 1,
                title: "[번개장터] Content Marketer",
                dDay: "D-DAY",
                workingPeriod: "1개월",
                companyImage: UIImage(resource: .icHome)          ,
                isScraped: false
            ),
            
            JobCardModel(
                internshipAnnouncementId: 4,
                title: "[보더엑스] 글로벌 마케팅 AE (채용연계형 인턴십)",
                dDay: "D-8",
                workingPeriod: "3개월",
                companyImage: UIImage(resource: .icHome),
                isScraped: false
            ),
            
            JobCardModel(
                internshipAnnouncementId: 2,
                title: "[카카오페이] 카카오페이 보험 운영 어시스턴트 채용",
                dDay: "D-17",
                workingPeriod: "2개월",
                companyImage: UIImage(resource: .icHome),
                isScraped: true
            ),
            
            JobCardModel(
                internshipAnnouncementId: 3,
                title: "[번개장터] Data Analyst",
                dDay: "지원 마감",
                workingPeriod: "3개월",
                companyImage: UIImage(resource: .icHome),
                isScraped: false
            ),
            
            JobCardModel(
                internshipAnnouncementId: 5,
                title: "[번개장터] Data Analyst",
                dDay: "지원 마감",
                workingPeriod: "3개월",
                companyImage: UIImage(resource: .icHome),
                isScraped: false
            ),
            
            JobCardModel(
                internshipAnnouncementId: 7,
                title: "[카카오페이] 카카오페이 보험 운영 어시스턴트 채용",
                dDay: "D-17",
                workingPeriod: "2개월",
                companyImage: UIImage(resource: .icHome),
                isScraped: true
            ),
            
            JobCardModel(
                internshipAnnouncementId: 6,
                title: "[번개장터] Content Marketer",
                dDay: "D-DAY",
                workingPeriod: "1개월",
                companyImage: UIImage(resource: .icHome),
                isScraped: false
            ),
            
            JobCardModel(
                internshipAnnouncementId: 9,
                title: "[카카오페이] 카카오페이 보험 운영 어시스턴트 채용",
                dDay: "D-17",
                workingPeriod: "2개월",
                companyImage: UIImage(resource: .icHome),
                isScraped: true
            ),
            
            JobCardModel(
                internshipAnnouncementId: 8,
                title: "[보더엑스] 글로벌 마케팅 AE (채용연계형 인턴십)",
                dDay: "D-8",
                workingPeriod: "3개월",
                companyImage: UIImage(resource: .icHome),
                isScraped: false
            ),
            
            JobCardModel(
                internshipAnnouncementId: 10,
                title: "[번개장터] Content Marketer",
                dDay: "D-DAY",
                workingPeriod: "1개월",
                companyImage: UIImage(resource: .icHome),
                isScraped: false
            )
//            JobCardModel(
//                coverImage: UIImage(resource: .icHome),
//                // scrapIcon: UIImage(resource: .ic28Bookmark),
//                daysRemaining: "D-2",
//                title: "[SomeOne] 콘텐츠 마케터 대학생 인턴 채용",
//                period: "2개월",
//                isScraped: false
//            ),
//            
//            JobCardModel(
//                coverImage: UIImage(resource: .icHome),
//                // scrapIcon: UIImage(resource: .ic28Bookmark),
//                daysRemaining: "D-2",
//                title: "[SomeOne] 콘텐츠 마케터 대학생 인턴 채용",
//                period: "2개월",
//                isScraped: false
//            ),
//            
//            JobCardModel(
//                coverImage: UIImage(resource: .icHome),
//                // scrapIcon: UIImage(resource: .ic28Bookmark),
//                daysRemaining: "D-2",
//                title: "[SomeOne] 콘텐츠 마케터 대학생 인턴 채용",
//                period: "2개월",
//                isScraped: false
//            ),
//            
//            JobCardModel(
//                coverImage: UIImage(resource: .icHome),
//                // scrapIcon: UIImage(resource: .ic28Bookmark),
//                daysRemaining: "D-2",
//                title: "[SomeOne] 콘텐츠 마케터 대학생 인턴 채용",
//                period: "2개월",
//                isScraped: false
//            ),
//            
//            JobCardModel(
//                coverImage: UIImage(resource: .icHome),
//                // scrapIcon: UIImage(resource: .ic28Bookmark),
//                daysRemaining: "D-2",
//                title: "[SomeOne] 콘텐츠 마케터 대학생 인턴 채용",
//                period: "2개월",
//                isScraped: false
//            ),
//            
//            JobCardModel(
//                coverImage: UIImage(resource: .icHome),
//                // scrapIcon: UIImage(resource: .ic28Bookmark),
//                daysRemaining: "D-2",
//                title: "[SomeOne] 콘텐츠 마케터 대학생 인턴 채용",
//                period: "2개월",
//                isScraped: false
//            ),
//            
//            JobCardModel(
//                coverImage: UIImage(resource: .icHome),
//                // scrapIcon: UIImage(resource: .ic28Bookmark),
//                daysRemaining: "D-2",
//                title: "[SomeOne] 콘텐츠 마케터 대학생 인턴 채용",
//                period: "2개월",
//                isScraped: false
//            ),
//            
//            JobCardModel(
//                coverImage: UIImage(resource: .icHome),
//                // scrapIcon: UIImage(resource: .ic28Bookmark),
//                daysRemaining: "D-2",
//                title: "[SomeOne] 콘텐츠 마케터 대학생 인턴 채용",
//                period: "2개월",
//                isScraped: false
//            ),
//            
//            JobCardModel(
//                coverImage: UIImage(resource: .icHome),
//                // scrapIcon: UIImage(resource: .ic28Bookmark),
//                daysRemaining: "D-2",
//                title: "[SomeOne] 콘텐츠 마케터 대학생 인턴 채용",
//                period: "2개월",
//                isScraped: false
//            ),
//            
//            JobCardModel(
//                coverImage: UIImage(resource: .icHome),
//                // scrapIcon: UIImage(resource: .ic28Bookmark),
//                daysRemaining: "D-2",
//                title: "[SomeOne] 콘텐츠 마케터 대학생 인턴 채용",
//                period: "2개월",
//                isScraped: false
//            ),
//            
//            JobCardModel(
//                coverImage: UIImage(resource: .icHome),
//                // scrapIcon: UIImage(resource: .ic28Bookmark),
//                daysRemaining: "D-2",
//                title: "[SomeOne] 콘텐츠 마케터 대학생 인턴 채용",
//                period: "2개월",
//                isScraped: false
//            )
        ]
    }
}
