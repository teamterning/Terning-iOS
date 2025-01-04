//
//  HomeViewModel.swift
//  Terning-iOS
//
//  Created by 이명진 on 12/27/24.
//

import RxSwift
import RxCocoa
import Foundation

final class HomeViewModel: ViewModelType {
    private let homeDataRelay = PublishRelay<[AnnouncementModel]>()
    private let soonDeadlineRelay = PublishRelay<[AnnouncementModel]>()
    private let hasScrapRelay = PublishRelay<Bool>()
    private let errorRelay = PublishRelay<String>()
    private let hasNextRelay = PublishRelay<Bool>()
    private let annoncementCountRelay = PublishRelay<Int>()
    
    struct Input {
        let sortAndPage: BehaviorSubject<(String, Int)>
        let soonDeadlineAnnouncementSubject: BehaviorSubject<Void>
        
        let addScrap: PublishSubject<(Int, String)> // (ID, Color)
        let patchScrap: PublishSubject<(Int, String)>
        let cancelScrap: PublishSubject<Int> // ID만 필요
    }
    
    struct Output {
        let jobModel: Observable<[AnnouncementModel]>
        let soonDeadlineAnnouncementModel: Observable<[AnnouncementModel]>
        let hasNext: Observable<Bool>
        let hasScrap: Observable<Bool>
        let announcementCount: Observable<Int>
        let error: Driver<String>
    }
    
    private let useCase: HomeUseCaseProtocol
    private let scrapUseCase: ScrapUseCaseProtocol
    
    init(useCase: HomeUseCaseProtocol, scrapUseCase: ScrapUseCaseProtocol) {
        self.useCase = useCase
        self.scrapUseCase = scrapUseCase
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        input.sortAndPage
            .subscribe(onNext: { [weak self] sort, page in
                guard let self = self else { return }
                Task {
                    do {
                        let data = try await self.useCase.execute(sortBy: sort, page: page)
                        
                        self.homeDataRelay.accept(data.result)
                        self.hasNextRelay.accept(data.hasNext)
                        self.annoncementCountRelay.accept(data.totalCount)
                    } catch {
                        self.errorRelay.accept(error.localizedDescription)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        input.soonDeadlineAnnouncementSubject
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                Task {
                    do {
                        let data = try await self.useCase.executeToday()
                        
                        self.hasScrapRelay.accept(data.hasScrapped)
                        self.soonDeadlineRelay.accept(data.scraps)
                    } catch {
                        self.errorRelay.accept(error.localizedDescription)
                    }
                }
            }).disposed(by: disposeBag)
        
        input.addScrap
            .subscribe(onNext: { [weak self] id, color in
                guard let self = self else { return }
                self.scrapUseCase.addScrap(internshipAnnouncementId: id, color: color)
                    .subscribe(onNext: {
                        print("Scrap 추가 성공")
                    }, onError: { error in
                        self.errorRelay.accept(error.localizedDescription)
                    })
                    .disposed(by: disposeBag)
            })
            .disposed(by: disposeBag)
        
        input.patchScrap
            .subscribe(onNext: { [weak self] id, color in
                guard let self = self else { return }
                self.scrapUseCase.patchScrap(internshipAnnouncementId: id, color: color)
                    .subscribe(onNext: {
                        print("Scrap 변경 성공")
                    }, onError: { error in
                        self.errorRelay.accept(error.localizedDescription)
                    })
                    .disposed(by: disposeBag)
            })
            .disposed(by: disposeBag)
        
        input.cancelScrap
            .subscribe(onNext: { [weak self] id in
                guard let self = self else { return }
                self.scrapUseCase.cancelScrap(internshipAnnouncementId: id)
                    .subscribe(onNext: {
                        print("Scrap 취소 성공")
                    }, onError: { error in
                        self.errorRelay.accept(error.localizedDescription)
                    })
                    .disposed(by: disposeBag)
            })
            .disposed(by: disposeBag)
        
        return Output(
            jobModel: homeDataRelay.asObservable(),
            soonDeadlineAnnouncementModel: soonDeadlineRelay.asObservable(),
            hasNext: hasNextRelay.asObservable(),
            hasScrap: hasScrapRelay.asObservable(),
            announcementCount: annoncementCountRelay.asObservable(),
            error: errorRelay.asDriver(onErrorJustReturn: "Unknown error")
        )
    }
}
