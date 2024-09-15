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
    
    // MARK: - Input
    
    struct Input {
        let fetchMonthDataTrigger: Observable<Date>
        let fetchMonthlyListTrigger: Observable<Date>
        let fetchDailyDataTrigger: Observable<Date>
        let patchScrapTrigger: Observable<(Int, String)>
        let cancelScrapTrigger: Observable<Int>
    }
    
    // MARK: - Output
    
    struct Output {
        let monthData: Driver<[Date: [ScrapModel]]>
        let monthlyList: Driver<[Date: [AnnouncementModel]]>
        let dailyData: Driver<[AnnouncementModel]>
        let error: Driver<String>
        let successMessage: Driver<String>
        let patchScrapResult: Driver<Void>
        let cancelScrapResult: Driver<Void>
    }
    
    private let calendarRepository: TNCalendarRepositoryProtocol
    private let scrapRepository: ScrapsRepositoryProtocol
    
    private let dateFormatter = DateFormatter().then {
        $0.dateFormat = "yyyy-MM-dd"
    }
    
    // MARK: - Init
    
    init(calendarRepository: TNCalendarRepositoryProtocol, scrapRepository: ScrapsRepositoryProtocol) {
        self.calendarRepository = calendarRepository
        self.scrapRepository = scrapRepository
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let errorTracker = PublishSubject<String>()
        let successMessageTracker = PublishSubject<String>()
        
        let monthData = input.fetchMonthDataTrigger
            .flatMapLatest { date -> Observable<[CalendarScrapModel]> in
                let year = Calendar.current.component(.year, from: date)
                let month = Calendar.current.component(.month, from: date)
                
                return self.calendarRepository.fetchMonthData(for: year, month: month)
                    .catch { error in
                        errorTracker.onNext("monthData 오류: \(error.localizedDescription)")
                        return .empty()
                    }
            }
            .map { scrapsByDeadline -> [Date: [ScrapModel]] in
                var scraps: [Date: [ScrapModel]] = [:]
                
                for item in scrapsByDeadline {
                    if let date = self.dateFormatter.date(from: item.deadline) {
                        scraps[date] = item.scraps
                    }
                }
                
                return scraps
            }
            .asDriver(onErrorJustReturn: [:])
        
        
        let monthlyList = input.fetchMonthlyListTrigger
            .flatMapLatest { date -> Observable<[CalendarAnnouncementModel]> in
                let year = Calendar.current.component(.year, from: date)
                let month = Calendar.current.component(.month, from: date)
                
                return self.calendarRepository.getMonthlyList(for: year, month: month)
                    .catch { error in
                        errorTracker.onNext("monthlyList 오류: \(error.localizedDescription)")
                        return .empty()
                    }
            }
            .map { scrapsByDeadline -> [Date: [AnnouncementModel]] in
                var scrapLists: [Date: [AnnouncementModel]] = [:]
                
                for item in scrapsByDeadline {
                    if let date = self.dateFormatter.date(from: item.deadline) {
                        scrapLists[date] = item.announcements
                    }
                }
                
                return scrapLists
            }
            .asDriver(onErrorJustReturn: [:])
        
        let dailyData = input.fetchDailyDataTrigger
            .flatMapLatest { date -> Observable<[AnnouncementModel]> in
                let dateString = self.dateFormatter.string(from: date)
                return self.calendarRepository.fetchDailyData(for: dateString)
                    .catch { error in
                        errorTracker.onNext("dailyData 오류: \(error.localizedDescription)")
                        return .empty()
                    }
            }
            .asDriver(onErrorJustReturn: [])
        
        let patchScrap = input.patchScrapTrigger
            .flatMapLatest { (intershipAnnouncementId, color) in
                self.scrapRepository.patchScrap(internshipAnnouncementId: intershipAnnouncementId, color: color)
                    .do(onNext: {
                        successMessageTracker.onNext("스크랩 수정 완료!")
                    })
                    .catch { error in
                        errorTracker.onNext("스크랩 수정 오류: \(error.localizedDescription)")
                        return .empty()
                    }
            }
            .asDriver(onErrorDriveWith: .empty())
        
        let cancelScrap = input.cancelScrapTrigger
            .flatMapLatest { intershipAnnouncementId in
                self.scrapRepository.cancelScrap(internshipAnnouncementId: intershipAnnouncementId)
                    .do(onNext: {
                        successMessageTracker.onNext("관심 공고가 캘린더에서 사라졌어요!")
                    })
                    .catch { error in
                        errorTracker.onNext("스크랩 취소 오류: \(error.localizedDescription)")
                        return .empty()
                    }
            }
            .asDriver(onErrorDriveWith: .empty())
        
        let error = errorTracker.asDriver(onErrorJustReturn: "알 수 없는 오류가 발생했습니다.")
        let successMessage = successMessageTracker.asDriver(onErrorJustReturn: "")
        
        return Output(
            monthData: monthData,
            monthlyList: monthlyList,
            dailyData: dailyData,
            error: error,
            successMessage: successMessage,
            patchScrapResult: patchScrap,
            cancelScrapResult: cancelScrap
        )
        
    }
}
