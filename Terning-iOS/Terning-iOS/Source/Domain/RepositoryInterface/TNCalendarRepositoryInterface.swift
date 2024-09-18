//
//  TNCalendarInterface.swift
//  Terning-iOS
//
//  Created by 이명진 on 9/18/24.
//

import RxSwift

protocol TNCalendarRepositoryInterface {
    func fetchMonthData(for year: Int, month: Int) -> Observable<[CalendarScrapModel]>
    func fetchDailyData(for date: String) -> Observable<[AnnouncementModel]>
    func getMonthlyList(for year: Int, month: Int) -> Observable<[CalendarAnnouncementModel]>
    func addScrap(internshipAnnouncementId: Int, color: String) -> Observable<Void>
    func patchScrap(internshipAnnouncementId: Int, color: String) -> Observable<Void>
    func cancelScrap(internshipAnnouncementId: Int) -> Observable<Void>
}
