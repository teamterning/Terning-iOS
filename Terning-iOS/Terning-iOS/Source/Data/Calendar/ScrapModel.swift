//
//  DailyModel.swift
//  Terning-iOS
//
//  Created by 이명진 on 7/13/24.
//

import Foundation

// MARK: - ScrapsByDeadlineModel

struct ScrapsByDeadlineModel: Codable {
    let scrapsByDeadline: [MonthlyScrapModel]
}

// MARK: - MonthlyScrapModel

struct MonthlyScrapModel: Codable {
    let deadline: String
    let scraps: [DailyScrapModel]
}

// MARK: - DailyScrapModel

struct DailyScrapModel: Codable {
    let scrapId: Int
    let title: String
    let color: String
    let internshipAnnouncementId: Int?
    let dDay: String?
    let workingPeriod: String?
    let companyImage: String?
    let startYear: Int?
    let startMonth: Int?
}

// 더미 데이터 1
func generateDummyData1() -> ScrapsByDeadlineModel {
    let scrapsByDeadline = [
        MonthlyScrapModel(deadline: "2024-07-01", scraps: [
            DailyScrapModel(scrapId: 1, title: "마케팅 인턴 모집", color: "#FF12B4", internshipAnnouncementId: nil, dDay: nil, workingPeriod: nil, companyImage: nil, startYear: nil, startMonth: nil),
            DailyScrapModel(scrapId: 2, title: "개발자 인턴 모집", color: "#FF98F7", internshipAnnouncementId: nil, dDay: nil, workingPeriod: nil, companyImage: nil, startYear: nil, startMonth: nil)
        ]),
        MonthlyScrapModel(deadline: "2024-07-05", scraps: [
            DailyScrapModel(scrapId: 3, title: "디자인 인턴 모집", color: "#1234FF", internshipAnnouncementId: nil, dDay: nil, workingPeriod: nil, companyImage: nil, startYear: nil, startMonth: nil),
            DailyScrapModel(scrapId: 11, title: "데이터 분석 인턴 모집", color: "#00FF00", internshipAnnouncementId: nil, dDay: nil, workingPeriod: nil, companyImage: nil, startYear: nil, startMonth: nil),
            DailyScrapModel(scrapId: 3, title: "디자인 인턴 모집", color: "#1234FF", internshipAnnouncementId: nil, dDay: nil, workingPeriod: nil, companyImage: nil, startYear: nil, startMonth: nil),
            DailyScrapModel(scrapId: 86, title: "데이터 분석 인턴 모집", color: "#00FF00", internshipAnnouncementId: nil, dDay: nil, workingPeriod: nil, companyImage: nil, startYear: nil, startMonth: nil)
        ]),
        MonthlyScrapModel(deadline: "2024-07-10", scraps: [
            DailyScrapModel(scrapId: 5, title: "회계 인턴 모집", color: "#0000FF", internshipAnnouncementId: nil, dDay: nil, workingPeriod: nil, companyImage: nil, startYear: nil, startMonth: nil),
            DailyScrapModel(scrapId: 6, title: "영업 인턴 모집", color: "#FFA500", internshipAnnouncementId: nil, dDay: nil, workingPeriod: nil, companyImage: nil, startYear: nil, startMonth: nil)
        ]),
        MonthlyScrapModel(deadline: "2024-07-15", scraps: [
            DailyScrapModel(scrapId: 7, title: "법률 인턴 모집", color: "#800080", internshipAnnouncementId: nil, dDay: nil, workingPeriod: nil, companyImage: nil, startYear: nil, startMonth: nil),
            DailyScrapModel(scrapId: 8, title: "홍보 인턴 모집", color: "#FFC0CB", internshipAnnouncementId: nil, dDay: nil, workingPeriod: nil, companyImage: nil, startYear: nil, startMonth: nil)
        ]),
        MonthlyScrapModel(deadline: "2024-07-20", scraps: [
            DailyScrapModel(scrapId: 9, title: "연구 인턴 모집", color: "#008000", internshipAnnouncementId: nil, dDay: nil, workingPeriod: nil, companyImage: nil, startYear: nil, startMonth: nil),
            DailyScrapModel(scrapId: 10, title: "기술 인턴 모집", color: "#000080", internshipAnnouncementId: nil, dDay: nil, workingPeriod: nil, companyImage: nil, startYear: nil, startMonth: nil)
        ])
    ]
    return ScrapsByDeadlineModel(scrapsByDeadline: scrapsByDeadline)
}

// 더미 데이터 2
func generateDummyData2() -> [DailyScrapModel] {
    let dummyData = [
        DailyScrapModel(scrapId: 1, title: "[Someone] 콘텐츠 마케터 대학생 인턴 채용", color: "#FF98F7", internshipAnnouncementId: 101, dDay: "D-5", workingPeriod: "2개월", companyImage: "company.image1", startYear: 2024, startMonth: 8),
        DailyScrapModel(scrapId: 2, title: "마케팅 인턴 모집", color: "#FF12B4", internshipAnnouncementId: 102, dDay: "D-5", workingPeriod: "3개월", companyImage: "company.image2", startYear: 2024, startMonth: 8),
        DailyScrapModel(scrapId: 3, title: "디자인 인턴 모집", color: "#1234FF", internshipAnnouncementId: 103, dDay: "D-6", workingPeriod: "4개월", companyImage: "company.image3", startYear: 2024, startMonth: 8),
        DailyScrapModel(scrapId: 4, title: "데이터 분석 인턴 모집", color: "#00FF00", internshipAnnouncementId: 104, dDay: "D-7", workingPeriod: "5개월", companyImage: "company.image4", startYear: 2024, startMonth: 8),
        DailyScrapModel(scrapId: 5, title: "회계 인턴 모집", color: "#0000FF", internshipAnnouncementId: 105, dDay: "D-8", workingPeriod: "6개월", companyImage: "company.image5", startYear: 2024, startMonth: 8),
        DailyScrapModel(scrapId: 6, title: "영업 인턴 모집", color: "#FFA500", internshipAnnouncementId: 106, dDay: "D-9", workingPeriod: "7개월", companyImage: "company.image6", startYear: 2024, startMonth: 8),
        DailyScrapModel(scrapId: 7, title: "법률 인턴 모집", color: "#800080", internshipAnnouncementId: 107, dDay: "D-10", workingPeriod: "8개월", companyImage: "company.image7", startYear: 2024, startMonth: 8),
        DailyScrapModel(scrapId: 8, title: "홍보 인턴 모집", color: "#FFC0CB", internshipAnnouncementId: 108, dDay: "D-11", workingPeriod: "9개월", companyImage: "company.image8", startYear: 2024, startMonth: 8),
        DailyScrapModel(scrapId: 9, title: "연구 인턴 모집", color: "#008000", internshipAnnouncementId: 109, dDay: "D-12", workingPeriod: "10개월", companyImage: "company.image9", startYear: 2024, startMonth: 8),
        DailyScrapModel(scrapId: 10, title: "기술 인턴 모집", color: "#000080", internshipAnnouncementId: 110, dDay: "D-13", workingPeriod: "11개월", companyImage: "company.image10", startYear: 2024, startMonth: 8)
    ]
    
    return dummyData
}

// 더미 데이터 3
func generateDummyData3() -> ScrapsByDeadlineModel {
    let scrapsByDeadline = [
        MonthlyScrapModel(deadline: "2024-07-05", scraps: [
            DailyScrapModel(scrapId: 1, title: "개발자 인턴 모집", color: "#FF98F7", internshipAnnouncementId: 101, dDay: "D-5", workingPeriod: "2개월", companyImage: "company.image1", startYear: 2024, startMonth: 8),
            DailyScrapModel(scrapId: 2, title: "데이터 분석 인턴 모집", color: "#00FF00", internshipAnnouncementId: 102, dDay: "D-5", workingPeriod: "4개월", companyImage: "company.image2", startYear: 2024, startMonth: 8)
        ]),
        MonthlyScrapModel(deadline: "2024-07-10", scraps: [
            DailyScrapModel(scrapId: 3, title: "마케팅 인턴 모집", color: "#FF12B4", internshipAnnouncementId: 103, dDay: "D-10", workingPeriod: "3개월", companyImage: "company.image3", startYear: 2024, startMonth: 8),
            DailyScrapModel(scrapId: 4, title: "회계 인턴 모집", color: "#0000FF", internshipAnnouncementId: 104, dDay: "D-10", workingPeriod: "6개월", companyImage: "company.image4", startYear: 2024, startMonth: 8)
        ]),
        MonthlyScrapModel(deadline: "2024-07-15", scraps: [
            DailyScrapModel(scrapId: 5, title: "디자인 인턴 모집", color: "#1234FF", internshipAnnouncementId: 105, dDay: "D-15", workingPeriod: "6개월", companyImage: "company.image5", startYear: 2024, startMonth: 8),
            DailyScrapModel(scrapId: 6, title: "법률 인턴 모집", color: "#800080", internshipAnnouncementId: 106, dDay: "D-15", workingPeriod: "6개월", companyImage: "company.image6", startYear: 2024, startMonth: 8)
        ]),
        MonthlyScrapModel(deadline: "2024-07-20", scraps: [
            DailyScrapModel(scrapId: 7, title: "홍보 인턴 모집", color: "#FFC0CB", internshipAnnouncementId: 107, dDay: "D-20", workingPeriod: "6개월", companyImage: "company.image7", startYear: 2024, startMonth: 8),
            DailyScrapModel(scrapId: 8, title: "연구 인턴 모집", color: "#008000", internshipAnnouncementId: 108, dDay: "D-20", workingPeriod: "6개월", companyImage: "company.image8", startYear: 2024, startMonth: 8)
        ]),
        MonthlyScrapModel(deadline: "2024-07-25", scraps: [
            DailyScrapModel(scrapId: 9, title: "기술 인턴 모집", color: "#000080", internshipAnnouncementId: 109, dDay: "D-25", workingPeriod: "6개월", companyImage: "company.image9", startYear: 2024, startMonth: 8),
            DailyScrapModel(scrapId: 10, title: "영업 인턴 모집", color: "#FFA500", internshipAnnouncementId: 110, dDay: "D-25", workingPeriod: "6개월", companyImage: "company.image10", startYear: 2024, startMonth: 8)
        ])
    ]
    return ScrapsByDeadlineModel(scrapsByDeadline: scrapsByDeadline)
}
