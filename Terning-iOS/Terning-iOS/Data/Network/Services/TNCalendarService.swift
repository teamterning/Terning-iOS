//
//  TNCalendarService.swift
//  Terning-iOS
//
//  Created by 이명진 on 8/26/24.
//

import RxSwift
import Moya
import RxMoya

protocol TNCalendarServiceProtocol {
    func fetchMonthData(for year: Int, month: Int) -> Observable<[CalendarScrapModel]>
    func fetchDailyData(for date: String) -> Observable<[AnnouncementModel]>
    func fetchMonthlyList(for year: Int, month: Int) -> Observable<[CalendarAnnouncementModel]>
}

final class TNCalendarService: TNCalendarServiceProtocol {
    
    private let provider: MoyaProvider<CalendarTargetType>
    
    init(provider: MoyaProvider<CalendarTargetType>) {
        self.provider = provider
    }
    
    func fetchMonthData(for year: Int, month: Int) -> Observable<[CalendarScrapModel]> {
        return provider.rx.request(.getMonthlyDefault(year: year, month: month))
            .filterSuccessfulStatusCodes()
            .map(BaseResponse<[CalendarScrapModel]>.self)
            .compactMap { $0.result }
            .asObservable()
    }
    
    func fetchDailyData(for date: String) -> Observable<[AnnouncementModel]> {
        return provider.rx.request(.getDaily(date: date))
            .filterSuccessfulStatusCodes()
            .map(BaseResponse<[AnnouncementModel]>.self)
            .compactMap { $0.result }
            .asObservable()
    }
    
    func fetchMonthlyList(for year: Int, month: Int) -> Observable<[CalendarAnnouncementModel]> {
        return provider.rx.request(.getMonthlyList(year: year, month: month))
            .filterSuccessfulStatusCodes()
            .map(BaseResponse<[CalendarAnnouncementModel]>.self)
            .compactMap { $0.result }
            .asObservable()
    }
}
