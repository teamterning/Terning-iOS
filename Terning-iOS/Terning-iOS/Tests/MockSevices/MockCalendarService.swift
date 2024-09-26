//
//  MockCalendarService.swift
//  Terning-iOS
//
//  Created by 이명진 on 9/17/24.
//

import RxSwift

final class MockCalendarService: TNCalendarServiceProtocol {
    
    func fetchMonthData(for year: Int, month: Int) -> Observable<[CalendarScrapModel]> {
        
        let mockData: [CalendarScrapModel] = [
            CalendarScrapModel(deadline: "2024-09-01", scraps: [
                ScrapModel(scrapId: 101, title: "[네이버] 채용 전환형 인턴 (개발)", color: "#ED4E54"),
                ScrapModel(scrapId: 102, title: "[당근] 마케팅 인턴 모집", color: "#F3A649"),
                ScrapModel(scrapId: 103, title: "[토스] 디자인 인턴", color: "#84D558"),
                ScrapModel(scrapId: 104, title: "[네이버] 데이터 분석 인턴", color: "#4AA9F2"),
                ScrapModel(scrapId: 105, title: "[네이버] 경영지원 인턴", color: "#9B64E2")
            ]),
            CalendarScrapModel(deadline: "2024-09-03", scraps: [
                ScrapModel(scrapId: 106, title: "[투썸] UX/UI 디자이너 인턴", color: "#F260AC")
            ]),
            CalendarScrapModel(deadline: "2024-09-07", scraps: [
                ScrapModel(scrapId: 110, title: "[삼성] AI 연구 인턴", color: "#F3A649"),
                ScrapModel(scrapId: 111, title: "[삼성] 기계학습 엔지니어 인턴", color: "#84D558")
            ]),
            CalendarScrapModel(deadline: "2024-09-11", scraps: [
                ScrapModel(scrapId: 107, title: "[LG] 프론트엔드 개발 인턴", color: "#4AA9F2"),
                ScrapModel(scrapId: 108, title: "[카카오] 백엔드 개발 인턴", color: "#9B64E2"),
                ScrapModel(scrapId: 109, title: "[카카오페이] HR 인턴 모집", color: "#ED4E54")
            ]),
            CalendarScrapModel(deadline: "2024-09-20", scraps: [
                ScrapModel(scrapId: 120, title: "[회사20] 스마트 팩토리 엔지니어 인턴", color: "#F260AC"),
                ScrapModel(scrapId: 121, title: "[회사21] IoT 엔지니어 인턴", color: "#84D558"),
                ScrapModel(scrapId: 122, title: "[회사22] 컴퓨터 비전 연구 인턴", color: "#ED4E54"),
                ScrapModel(scrapId: 123, title: "[회사23] 네트워크 엔지니어 인턴", color: "#F3A649")
            ])
        ]
        
        return Observable.just(mockData)
        
    }
    
    func fetchDailyData(for date: String) -> Observable<[AnnouncementModel]> {
        let dailyMockData: [String: [AnnouncementModel]] = [
            "2024-09-01": [
                AnnouncementModel(internshipAnnouncementId: 101, companyImage: "https://bit.ly/4eZ13uV", dDay: "D-5", title: "[네이버] 채용 전환형 인턴 (개발)", workingPeriod: "3개월", isScrapped: true, color: "#ED4E54", deadline: "2024-09-01", startYearMonth: "2024년 9월", companyInfo: "네이버"),
                AnnouncementModel(internshipAnnouncementId: 102, companyImage: "https://bit.ly/4eZ13uV", dDay: "D-5", title: "[당근] 마케팅 인턴 모집", workingPeriod: "3개월", isScrapped: true, color: "#F3A649", deadline: "2024-09-01", startYearMonth: "2024년 9월", companyInfo: "당근"),
                AnnouncementModel(internshipAnnouncementId: 103, companyImage: "https://bit.ly/4eZ13uV", dDay: "D-5", title: "[토스] 디자인 인턴", workingPeriod: "3개월", isScrapped: true, color: "#84D558", deadline: "2024-09-01", startYearMonth: "2024년 9월", companyInfo: "토스"),
                AnnouncementModel(internshipAnnouncementId: 104, companyImage: "https://bit.ly/4eZ13uV", dDay: "D-5", title: "[네이버] 데이터 분석 인턴", workingPeriod: "3개월", isScrapped: true, color: "#4AA9F2", deadline: "2024-09-01", startYearMonth: "2024년 9월", companyInfo: "네이버"),
                AnnouncementModel(internshipAnnouncementId: 105, companyImage: "https://bit.ly/4eZ13uV", dDay: "D-5", title: "[네이버] 경영지원 인턴", workingPeriod: "3개월", isScrapped: true, color: "#9B64E2", deadline: "2024-09-01", startYearMonth: "2024년 9월", companyInfo: "네이버")
            ],
            "2024-09-03": [
                AnnouncementModel(internshipAnnouncementId: 106, companyImage: "https://bit.ly/4eZ13uV", dDay: "D-3", title: "[투썸] UX/UI 디자이너 인턴", workingPeriod: "3개월", isScrapped: true, color: "#F260AC", deadline: "2024-09-03", startYearMonth: "2024년 9월", companyInfo: "투썸")
            ],
            "2024-09-07": [
                AnnouncementModel(internshipAnnouncementId: 110, companyImage: "https://bit.ly/4eZ13uV", dDay: "D-day", title: "[삼성] AI 연구 인턴", workingPeriod: "3개월", isScrapped: true, color: "#F3A649", deadline: "2024-09-07", startYearMonth: "2024년 9월", companyInfo: "삼성"),
                AnnouncementModel(internshipAnnouncementId: 111, companyImage: "https://bit.ly/4eZ13uV", dDay: "D-day", title: "[삼성] 기계학습 엔지니어 인턴", workingPeriod: "3개월", isScrapped: true, color: "#84D558", deadline: "2024-09-07", startYearMonth: "2024년 9월", companyInfo: "삼성")
            ],
            "2024-09-11": [
                AnnouncementModel(internshipAnnouncementId: 107, companyImage: "https://bit.ly/4eZ13uV", dDay: "D-1", title: "[LG] 프론트엔드 개발 인턴", workingPeriod: "3개월", isScrapped: true, color: "#4AA9F2", deadline: "2024-09-11", startYearMonth: "2024년 9월", companyInfo: "LG"),
                AnnouncementModel(internshipAnnouncementId: 108, companyImage: "https://bit.ly/4eZ13uV", dDay: "D-1", title: "[카카오] 백엔드 개발 인턴", workingPeriod: "3개월", isScrapped: true, color: "#9B64E2", deadline: "2024-09-11", startYearMonth: "2024년 9월", companyInfo: "카카오"),
                AnnouncementModel(internshipAnnouncementId: 109, companyImage: "https://bit.ly/4eZ13uV", dDay: "D-1", title: "[카카오페이] HR 인턴 모집", workingPeriod: "3개월", isScrapped: true, color: "#ED4E54", deadline: "2024-09-11", startYearMonth: "2024년 9월", companyInfo: "카카오페이")
            ],
            "2024-09-20": [
                AnnouncementModel(internshipAnnouncementId: 120, companyImage: "https://bit.ly/4eZ13uV", dDay: "D-5", title: "[회사20] 스마트 팩토리 엔지니어 인턴", workingPeriod: "3개월", isScrapped: true, color: "#F260AC", deadline: "2024-09-20", startYearMonth: "2024년 9월", companyInfo: "회사20"),
                AnnouncementModel(internshipAnnouncementId: 121, companyImage: "https://bit.ly/4eZ13uV", dDay: "D-5", title: "[회사21] IoT 엔지니어 인턴", workingPeriod: "3개월", isScrapped: true, color: "#84D558", deadline: "2024-09-20", startYearMonth: "2024년 9월", companyInfo: "회사21"),
                AnnouncementModel(internshipAnnouncementId: 122, companyImage: "https://bit.ly/4eZ13uV", dDay: "D-5", title: "[회사22] 컴퓨터 비전 연구 인턴", workingPeriod: "3개월", isScrapped: true, color: "#ED4E54", deadline: "2024-09-20", startYearMonth: "2024년 9월", companyInfo: "회사22"),
                AnnouncementModel(internshipAnnouncementId: 123, companyImage: "https://bit.ly/4eZ13uV", dDay: "D-5", title: "[회사23] 네트워크 엔지니어 인턴", workingPeriod: "3개월", isScrapped: true, color: "#F3A649", deadline: "2024-09-20", startYearMonth: "2024년 9월", companyInfo: "회사23")
            ]
        ]
        
        return Observable.just(dailyMockData[date] ?? [])
    }
    
    func fetchMonthlyList(for year: Int, month: Int) -> Observable<[CalendarAnnouncementModel]> {
        let monthlyMockData: [CalendarAnnouncementModel] = [
            CalendarAnnouncementModel(
                deadline: "2024-09-01",
                announcements: [
                    AnnouncementModel(internshipAnnouncementId: 101, companyImage: "https://bit.ly/4eZ13uV", dDay: "D-5", title: "[네이버] 채용 전환형 인턴 (개발)", workingPeriod: "3개월", isScrapped: true, color: "#ED4E54", deadline: "2024-09-01", startYearMonth: "2024년 9월", companyInfo: "네이버"),
                    AnnouncementModel(internshipAnnouncementId: 102, companyImage: "https://bit.ly/4eZ13uV", dDay: "D-5", title: "[당근] 마케팅 인턴 모집", workingPeriod: "3개월", isScrapped: true, color: "#F3A649", deadline: "2024-09-01", startYearMonth: "2024년 9월", companyInfo: "당근"),
                    AnnouncementModel(internshipAnnouncementId: 103, companyImage: "https://bit.ly/4eZ13uV", dDay: "D-5", title: "[토스] 디자인 인턴", workingPeriod: "3개월", isScrapped: true, color: "#84D558", deadline: "2024-09-01", startYearMonth: "2024년 9월", companyInfo: "토스"),
                    AnnouncementModel(internshipAnnouncementId: 104, companyImage: "https://bit.ly/4eZ13uV", dDay: "D-5", title: "[네이버] 데이터 분석 인턴", workingPeriod: "3개월", isScrapped: true, color: "#4AA9F2", deadline: "2024-09-01", startYearMonth: "2024년 9월", companyInfo: "네이버"),
                    AnnouncementModel(internshipAnnouncementId: 105, companyImage: "https://bit.ly/4eZ13uV", dDay: "D-5", title: "[네이버] 경영지원 인턴", workingPeriod: "3개월", isScrapped: true, color: "#9B64E2", deadline: "2024-09-01", startYearMonth: "2024년 9월", companyInfo: "네이버")
                ]
            ),
            CalendarAnnouncementModel(
                deadline: "2024-09-03",
                announcements: [
                    AnnouncementModel(internshipAnnouncementId: 106, companyImage: "https://bit.ly/4eZ13uV", dDay: "D-3", title: "[투썸] UX/UI 디자이너 인턴", workingPeriod: "3개월", isScrapped: true, color: "#F260AC", deadline: "2024-09-03", startYearMonth: "2024년 9월", companyInfo: "투썸")
                ]
            ),
            CalendarAnnouncementModel(
                deadline: "2024-09-07",
                announcements: [
                    AnnouncementModel(internshipAnnouncementId: 110, companyImage: "https://bit.ly/4eZ13uV", dDay: "D-day", title: "[삼성] AI 연구 인턴", workingPeriod: "3개월", isScrapped: true, color: "#F3A649", deadline: "2024-09-07", startYearMonth: "2024년 9월", companyInfo: "삼성"),
                    AnnouncementModel(internshipAnnouncementId: 111, companyImage: "https://bit.ly/4eZ13uV", dDay: "D-day", title: "[삼성] 기계학습 엔지니어 인턴", workingPeriod: "3개월", isScrapped: true, color: "#84D558", deadline: "2024-09-07", startYearMonth: "2024년 9월", companyInfo: "삼성")
                ]
            ),
            CalendarAnnouncementModel(
                deadline: "2024-09-11",
                announcements: [
                    AnnouncementModel(internshipAnnouncementId: 107, companyImage: "https://bit.ly/4eZ13uV", dDay: "D-1", title: "[LG] 프론트엔드 개발 인턴", workingPeriod: "3개월", isScrapped: true, color: "#4AA9F2", deadline: "2024-09-11", startYearMonth: "2024년 9월", companyInfo: "LG"),
                    AnnouncementModel(internshipAnnouncementId: 108, companyImage: "https://bit.ly/4eZ13uV", dDay: "D-1", title: "[카카오] 백엔드 개발 인턴", workingPeriod: "3개월", isScrapped: true, color: "#9B64E2", deadline: "2024-09-11", startYearMonth: "2024년 9월", companyInfo: "카카오"),
                    AnnouncementModel(internshipAnnouncementId: 109, companyImage: "https://bit.ly/4eZ13uV", dDay: "D-1", title: "[카카오페이] HR 인턴 모집", workingPeriod: "3개월", isScrapped: true, color: "#ED4E54", deadline: "2024-09-11", startYearMonth: "2024년 9월", companyInfo: "카카오페이")
                ]
            ),
            CalendarAnnouncementModel(
                deadline: "2024-09-20",
                announcements: [
                    AnnouncementModel(internshipAnnouncementId: 120, companyImage: "https://bit.ly/4eZ13uV", dDay: "D-5", title: "[회사20] 스마트 팩토리 엔지니어 인턴", workingPeriod: "3개월", isScrapped: true, color: "#F260AC", deadline: "2024-09-20", startYearMonth: "2024년 9월", companyInfo: "회사20"),
                    AnnouncementModel(internshipAnnouncementId: 121, companyImage: "https://bit.ly/4eZ13uV", dDay: "D-5", title: "[회사21] IoT 엔지니어 인턴", workingPeriod: "3개월", isScrapped: true, color: "#84D558", deadline: "2024-09-20", startYearMonth: "2024년 9월", companyInfo: "회사21"),
                    AnnouncementModel(internshipAnnouncementId: 122, companyImage: "https://bit.ly/4eZ13uV", dDay: "D-5", title: "[회사22] 컴퓨터 비전 연구 인턴", workingPeriod: "3개월", isScrapped: true, color: "#ED4E54", deadline: "2024-09-20", startYearMonth: "2024년 9월", companyInfo: "회사22"),
                    AnnouncementModel(internshipAnnouncementId: 123, companyImage: "https://bit.ly/4eZ13uV", dDay: "D-5", title: "[회사23] 네트워크 엔지니어 인턴", workingPeriod: "3개월", isScrapped: true, color: "#F3A649", deadline: "2024-09-20", startYearMonth: "2024년 9월", companyInfo: "회사23")
                ]
            )
        ]
        
        return Observable.just(monthlyMockData)
    }
    
}
