//
//  TNCalendarRepository.swift
//  Terning-iOS
//
//  Created by 이명진 on 8/26/24.
//

import RxSwift

final class TNCalendarRepository: TNCalendarRepositoryInterface {
    
    private let calendarService: TNCalendarServiceProtocol
    private let scrapService: ScrapServiceProtocol
    
    init(calendarService: TNCalendarServiceProtocol, scrapService: ScrapServiceProtocol) {
        self.calendarService = calendarService
        self.scrapService = scrapService
    }
    
    func fetchMonthData(for year: Int, month: Int) -> Observable<[CalendarScrapModel]> {
        return calendarService.fetchMonthData(for: year, month: month)
    }
    
    func fetchDailyData(for date: String) -> Observable<[AnnouncementModel]> {
        return calendarService.fetchDailyData(for: date)
    }
    
    func getMonthlyList(for year: Int, month: Int) -> Observable<[CalendarAnnouncementModel]> {
        return calendarService.fetchMonthlyList(for: year, month: month)
    }
    
    func addScrap(internshipAnnouncementId: Int, color: String) -> Observable<Void> {
        return scrapService.addScrap(internshipAnnouncementId: internshipAnnouncementId, color: color)
    }
    
    func patchScrap(internshipAnnouncementId: Int, color: String) -> Observable<Void> {
        return scrapService.patchScrap(internshipAnnouncementId: internshipAnnouncementId, color: color)
    }
    
    func cancelScrap(internshipAnnouncementId: Int) -> Observable<Void> {
        return scrapService.cancelScrap(internshipAnnouncementId: internshipAnnouncementId)
    }
}
