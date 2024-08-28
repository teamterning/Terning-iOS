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
    func fetchMonthData(for year: Int, month: Int) -> Observable<[ScrapsByDeadlineModel]>
    func fetchDailyData(for date: String) -> Observable<[DailyScrapModel]>
    func getMonthlyList(for year: Int, month: Int) -> Observable<[ScrapsByDeadlineModel]>
}

final class TNCalendarService: TNCalendarServiceProtocol {
    
    private let provider: MoyaProvider<CalendarTargetType>
    
    init(provider: MoyaProvider<CalendarTargetType>) {
        self.provider = provider
    }
    
    func fetchMonthData(for year: Int, month: Int) -> Observable<[ScrapsByDeadlineModel]> {
        return provider.rx.request(.getMonthlyDefault(year: year, month: month))
            .filterSuccessfulStatusCodes()
            .map(BaseResponse<[ScrapsByDeadlineModel]>.self)
            .compactMap { $0.result }
            .asObservable()
    }
    
    func fetchDailyData(for date: String) -> Observable<[DailyScrapModel]> {
        return provider.rx.request(.getDaily(date: date))
            .filterSuccessfulStatusCodes()
            .map(BaseResponse<[DailyScrapModel]>.self)
            .compactMap { $0.result }
            .asObservable()
    }
    
    func getMonthlyList(for year: Int, month: Int) -> Observable<[ScrapsByDeadlineModel]> {
        return provider.rx.request(.getMonthlyList(year: year, month: month))
            .filterSuccessfulStatusCodes()
            .map(BaseResponse<[ScrapsByDeadlineModel]>.self)
            .compactMap { $0.result }
            .asObservable()
    }
}
