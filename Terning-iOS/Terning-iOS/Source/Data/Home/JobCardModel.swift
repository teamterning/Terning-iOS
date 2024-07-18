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
    let companyImage: String
    let isScraped: Bool
}

// dummy data
extension JobCardModel {
    static func getJobCardData() -> [JobCardModel] {
        return [
            JobCardModel(
                internshipAnnouncementId: 1,
                title: "[번개장터] Content Marketer",
                dDay: "D-DAY",
                workingPeriod: "1개월",
                companyImage: "https://images.unsplash.com/photo-1543852786-1cf6624b9987?q=80&w=2187&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                isScraped: false
            ),
            
            JobCardModel(
                internshipAnnouncementId: 4,
                title: "[보더엑스] 글로벌 마케팅 AE (채용연계형 인턴십)",
                dDay: "D-8",
                workingPeriod: "3개월",
                companyImage: "https://images.unsplash.com/photo-1543852786-1cf6624b9987?q=80&w=2187&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                isScraped: false
            ),
            
            JobCardModel(
                internshipAnnouncementId: 2,
                title: "[카카오페이] 카카오페이 보험 운영 어시스턴트 채용",
                dDay: "D-17",
                workingPeriod: "2개월",
                companyImage: "https://images.unsplash.com/photo-1543852786-1cf6624b9987?q=80&w=2187&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                isScraped: true
            ),
            
            JobCardModel(
                internshipAnnouncementId: 3,
                title: "[번개장터] Data Analyst",
                dDay: "지원 마감",
                workingPeriod: "3개월",
                companyImage: "https://images.unsplash.com/photo-1543852786-1cf6624b9987?q=80&w=2187&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                isScraped: false
            ),
            
            JobCardModel(
                internshipAnnouncementId: 5,
                title: "[번개장터] Data Analyst",
                dDay: "지원 마감",
                workingPeriod: "3개월",
                companyImage: "https://images.unsplash.com/photo-1543852786-1cf6624b9987?q=80&w=2187&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                isScraped: false
            ),
            
            JobCardModel(
                internshipAnnouncementId: 7,
                title: "[카카오페이] 카카오페이 보험 운영 어시스턴트 채용",
                dDay: "D-17",
                workingPeriod: "2개월",
                companyImage: "https://images.unsplash.com/photo-1543852786-1cf6624b9987?q=80&w=2187&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                isScraped: true
            ),
            
            JobCardModel(
                internshipAnnouncementId: 6,
                title: "[번개장터] Content Marketer",
                dDay: "D-DAY",
                workingPeriod: "1개월",
                companyImage: "https://images.unsplash.com/photo-1543852786-1cf6624b9987?q=80&w=2187&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                isScraped: false
            ),
            
            JobCardModel(
                internshipAnnouncementId: 9,
                title: "[카카오페이] 카카오페이 보험 운영 어시스턴트 채용",
                dDay: "D-17",
                workingPeriod: "2개월",
                companyImage: "https://images.unsplash.com/photo-1543852786-1cf6624b9987?q=80&w=2187&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                isScraped: true
            ),
            
            JobCardModel(
                internshipAnnouncementId: 8,
                title: "[보더엑스] 글로벌 마케팅 AE (채용연계형 인턴십)",
                dDay: "D-8",
                workingPeriod: "3개월",
                companyImage: "https://images.unsplash.com/photo-1543852786-1cf6624b9987?q=80&w=2187&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                isScraped: false
            ),
            
            JobCardModel(
                internshipAnnouncementId: 10,
                title: "[번개장터] Content Marketer",
                dDay: "D-DAY",
                workingPeriod: "1개월",
                companyImage: "https://images.unsplash.com/photo-1543852786-1cf6624b9987?q=80&w=2187&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                isScraped: false
            )
        ]
    }
}
