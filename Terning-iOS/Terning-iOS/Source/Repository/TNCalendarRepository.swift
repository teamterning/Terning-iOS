//
//  TNCalendarRepository.swift
//  Terning-iOS
//
//  Created by 이명진 on 8/26/24.
//

import RxSwift

protocol TNCalendarRepositoryProtocol {
    func fetchMonthData(for year: Int, month: Int) -> Observable<[ScrapsByDeadlineModel]>
    func fetchDailyData(for date: String) -> Observable<[DailyScrapModel]>
    func getMonthlyList(for year: Int, month: Int) -> Observable<[ScrapsByDeadlineModel]>
}

final class TNCalendarRepository: TNCalendarRepositoryProtocol {
    
    private let service: TNCalendarServiceProtocol
    
    init(service: TNCalendarServiceProtocol) {
        self.service = service
    }
    
    func fetchMonthData(for year: Int, month: Int) -> Observable<[ScrapsByDeadlineModel]> {
        return service.fetchMonthData(for: year, month: month)
    }
    
    func fetchDailyData(for date: String) -> Observable<[DailyScrapModel]> {
        return service.fetchDailyData(for: date)
    }
    
    func getMonthlyList(for year: Int, month: Int) -> Observable<[ScrapsByDeadlineModel]> {
        return service.getMonthlyList(for: year, month: month)
    }
}

