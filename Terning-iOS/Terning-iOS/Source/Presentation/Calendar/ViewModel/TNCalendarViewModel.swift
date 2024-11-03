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
    
    // MARK: - Properties
    
    var scraps: [Date: [ScrapModel]] = [:] // 스크랩 데이터를 저장할 딕셔너리
    var scrapLists: [Date: [AnnouncementModel]] = [:] // 리스트 데이터를 저장할 딕셔너리
    var calendarDaily: [AnnouncementModel] = [] // 일간 캘린더 데이터를 저장할 딕셔너리
    
    private let calendarRepository: TNCalendarRepositoryInterface
    
    private let dateFormatter = DateFormatter().then {
        $0.dateFormat = "yyyy-MM-dd"
    }
    
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
        let monthData: Driver<Void>
        let monthlyList: Driver<Void>
        let dailyData: Driver<Void>
        let error: Driver<String>
        let successMessage: Driver<String>
        let patchScrapResult: Driver<Void>
        let cancelScrapResult: Driver<Void>
    }
    
    // MARK: - Init
    init(calendarRepository: TNCalendarRepositoryInterface) {
        self.calendarRepository = calendarRepository
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let errorTracker = PublishSubject<String>()
        let successMessageTracker = PublishSubject<String>()
        
        let monthData = input.fetchMonthDataTrigger
            .distinctUntilChanged()
            .flatMapLatest { date -> Observable<[CalendarScrapModel]> in
                let year = Calendar.current.component(.year, from: date)
                let month = Calendar.current.component(.month, from: date)
                
                return self.calendarRepository.fetchMonthData(for: year, month: month)
                    .catch { error in
                        errorTracker.onNext("monthData 오류: \(error.localizedDescription)")
                        return .empty()
                    }
            }
            .do(onNext: { [weak self] scrapsByDeadline in
                guard let self = self else { return }
                self.scraps.removeAll()  // Clear the current scraps
                for item in scrapsByDeadline {
                    if let date = self.dateFormatter.date(from: item.deadline) {
                        self.scraps[date] = item.scraps
                    }
                }
            })
            .map { _ in }
            .asDriver(onErrorJustReturn: ())
        
        let monthlyList = input.fetchMonthlyListTrigger
            .distinctUntilChanged()
            .flatMapLatest { date -> Observable<[CalendarAnnouncementModel]> in
                let year = Calendar.current.component(.year, from: date)
                let month = Calendar.current.component(.month, from: date)
                
                return self.calendarRepository.getMonthlyList(for: year, month: month)
                    .catch { error in
                        errorTracker.onNext("monthlyList 오류: \(error.localizedDescription)")
                        return .empty()
                    }
            }
            .do(onNext: { [weak self] scrapsByDeadline in
                guard let self = self else { return }
                self.scrapLists.removeAll()
                for item in scrapsByDeadline {
                    if let date = self.dateFormatter.date(from: item.deadline) {
                        self.scrapLists[date] = item.announcements
                    }
                }
            })
            .map { _ in }
            .asDriver(onErrorJustReturn: ())
        
        let dailyData = input.fetchDailyDataTrigger
            .distinctUntilChanged()
            .flatMapLatest { date -> Observable<[AnnouncementModel]> in
                let dateString = self.dateFormatter.string(from: date)
                return self.calendarRepository.fetchDailyData(for: dateString)
                    .catch { error in
                        errorTracker.onNext("dailyData 오류: \(error.localizedDescription)")
                        return .empty()
                    }
            }
            .do(onNext: { [weak self] dailyData in
                guard let self = self else { return }
                self.calendarDaily = dailyData
            })
            .map { _ in }
            .asDriver(onErrorJustReturn: ())
        
        let patchScrap = input.patchScrapTrigger
            .flatMapLatest { (intershipAnnouncementId, color) in
                self.calendarRepository.patchScrap(internshipAnnouncementId: intershipAnnouncementId, color: color)
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
                self.calendarRepository.cancelScrap(internshipAnnouncementId: intershipAnnouncementId)
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
