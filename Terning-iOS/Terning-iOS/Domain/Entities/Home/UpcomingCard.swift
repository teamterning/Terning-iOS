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

extension UpcomingCardModel {
    
    /// 스크랩 한게 있고, 마감 공고가 있음
    static func mockDataHasScrappedYesAnnouncement() -> [AnnouncementModel] {
        return [
            AnnouncementModel(internshipAnnouncementId: 101, companyImage: "https://bit.ly/4eZ13uV", dDay: "D-5", title: "[네이버] 채용 전환형 인턴 (개발)", workingPeriod: "3개월", isScrapped: true, color: "#ED4E54", deadline: "2024-09-01", startYearMonth: "2024년 9월", companyInfo: "네이버"),
            AnnouncementModel(internshipAnnouncementId: 102, companyImage: "https://bit.ly/4eZ13uV", dDay: "D-5", title: "[당근] 마케팅 인턴 모집", workingPeriod: "3개월", isScrapped: true, color: "#F3A649", deadline: "2024-09-01", startYearMonth: "2024년 9월", companyInfo: "당근"),
            AnnouncementModel(internshipAnnouncementId: 103, companyImage: "https://bit.ly/4eZ13uV", dDay: "D-5", title: "[토스] 디자인 인턴", workingPeriod: "3개월", isScrapped: true, color: "#84D558", deadline: "2024-09-01", startYearMonth: "2024년 9월", companyInfo: "토스"),
            AnnouncementModel(internshipAnnouncementId: 104, companyImage: "https://bit.ly/4eZ13uV", dDay: "D-5", title: "[네이버] 데이터 분석 인턴", workingPeriod: "3개월", isScrapped: true, color: "#4AA9F2", deadline: "2024-09-01", startYearMonth: "2024년 9월", companyInfo: "네이버"),
            AnnouncementModel(internshipAnnouncementId: 105, companyImage: "https://bit.ly/4eZ13uV", dDay: "D-5", title: "[네이버] 경영지원 인턴", workingPeriod: "3개월", isScrapped: true, color: "#9B64E2", deadline: "2024-09-01", startYearMonth: "2024년 9월", companyInfo: "네이버")]
    }
    
    /// 스크랩 한건 있지만 마감 공고가 없음
    static func mockDataHasScrappedNoAnnouncement() -> [AnnouncementModel] {
        return []
    }
}
