//
//  SearchResultViewModel.swift
//  Terning-iOS
//
//  Created by 정민지 on 7/17/24.
//

import RxSwift
import RxCocoa

final class SearchResultViewModel: ViewModelType {
    
    // MARK: - Input
    
    struct Input {
        let keyword: Observable<String>
        let sortBy: Observable<String>
        let page: Observable<Int>
        let size: Observable<Int>
        let searchTrigger: Observable<Void>
    }
    
    // MARK: - Output
    
    struct Output {
        let jobCards: Driver<[JobCardModel]>
        let keyword: Driver<String>
    }
    
    // MARK: - Transform
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let jobCards = input.searchTrigger
            .withLatestFrom(Observable.combineLatest(input.keyword, input.sortBy, input.page, input.size))
            .flatMapLatest { keyword, sortBy, page, size in
                self.fetchJobCards(keyword: keyword, sortBy: sortBy, page: page, size: size)
                    .catchAndReturn([])
            }
            .asDriver(onErrorJustReturn: [])
        
        let keyword = input.keyword.asDriver(onErrorJustReturn: "")
        
        return Output(jobCards: jobCards, keyword: keyword)
    }
    
    private func fetchJobCards(keyword: String, sortBy: String, page: Int, size: Int) -> Observable<[JobCardModel]> {
        let dummyData: [JobCardModel] = [
            JobCardModel(
                internshipAnnouncementId: 23,
                title: "[유한킴벌리]그린캠프 w. 대학생 숲 활동가 모집",
                dDay: "D-2",
                workingPeriod: "2개월",
                companyImage: "https://images.unsplash.com/photo-1543852786-1cf6624b9987?q=80&w=2187&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                isScraped: false
            ),
            JobCardModel(
                internshipAnnouncementId: 2,
                title: "[유한킴벌리]그린캠프 w. 대학생 숲 활동가 모집",
                dDay: "D-2",
                workingPeriod: "3개월",
                companyImage: "https://images.unsplash.com/photo-1543852786-1cf6624b9987?q=80&w=2187&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                isScraped: true
            )
        ]
        
        return Observable.just(dummyData)
    }
}
