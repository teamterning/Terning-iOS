//
//  TNCalendarViewModel.swift
//  Terning-iOS
//
//  Created by 이명진 on 8/26/24.
//

import Foundation
import RxSwift
import RxCocoa

final class TNCalendarViewModel: ViewModelType {
    // Input
    struct Input {
        let fetchMonthDataTrigger: Observable<Date>
    }
    
    // Output
    struct Output {
        let monthData: Driver<[Date: [DailyScrapModel]]>
        let error: Driver<String>
    }
    
    private let repository: TNCalendarRepositoryProtocol
    private let dateFormatter = DateFormatter().then {
        $0.dateFormat = "yyyy-MM-dd"
    }
    
    init(repository: TNCalendarRepositoryProtocol) {
        self.repository = repository
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let errorTracker = PublishSubject<String>()
        
        let monthData = input.fetchMonthDataTrigger
            .flatMapLatest { date -> Observable<[ScrapsByDeadlineModel]> in
                let year = Calendar.current.component(.year, from: date)
                let month = Calendar.current.component(.month, from: date)
                
                return self.repository.fetchMonthData(for: year, month: month)
                    .catch { error in
                        errorTracker.onNext("데이터를 불러오는 중 오류가 발생했습니다. \(error.localizedDescription)")
                        return .empty()
                    }
            }
            .map { scrapsByDeadline -> [Date: [DailyScrapModel]] in
                var scraps: [Date: [DailyScrapModel]] = [:]
                
                for item in scrapsByDeadline {
                    if let date = self.dateFormatter.date(from: item.deadline) {
                        scraps[date] = item.scraps
                    }
                }
                
                return scraps
            }
            .asDriver(onErrorJustReturn: [:])
        
        let error = errorTracker.asDriver(onErrorJustReturn: "알 수 없는 오류가 발생했습니다.")
        
        return Output(monthData: monthData, error: error)
    }
}
