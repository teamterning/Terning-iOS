//
//  SearchResultViewModel.swift
//  Terning-iOS
//
//  Created by 정민지 on 7/17/24.
//

import UIKit

import RxSwift
import RxCocoa

final class SearchResultViewModel: ViewModelType {
    
    // MARK: - Properties
    
    private let searchProvider = Providers.searchProvider
    private let scrapUseCase: ScrapUseCaseProtocol
    
    // MARK: - Input
    
    struct Input {
        let keyword: Observable<String>
        let sortTap: Observable<Void>
        let sortBy: Observable<String>
        let page: Observable<Int>
        let size: Observable<Int>
        let searchTrigger: Observable<Void>
        let addScrapTrigger: Observable<(Int, String)>
        let cancelScrapTrigger: Observable<Int>
    }
    
    // MARK: - Output
    
    struct Output {
        let showSortBottom: Driver<Void>
        let searchResults: Driver<[AnnouncementModel]>
        let keyword: Driver<String>
        let totalCounts: Driver<Int>
        let hasNextPage: Driver<Bool>
        let error: Driver<String>
        let successMessage: Driver<String>
        let addScrapResult: Driver<Void>
        let cancelScrapResult: Driver<Void>
    }
    
    // MARK: - Init
    
    init(scrapUseCase: ScrapUseCaseProtocol) {
        self.scrapUseCase = scrapUseCase
    }
    
    // MARK: - Transform
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let errorTracker = PublishSubject<String>()
        let successMessageTracker = PublishSubject<String>()
        
        let searchResponse = input.searchTrigger
            .withLatestFrom(Observable.combineLatest(input.keyword, input.sortBy, input.page, input.size))
            .flatMapLatest { keyword, sortBy, page, size in
                return self.fetchJobCards(keyword: keyword, sortBy: sortBy, page: page, size: size)
                    .catchAndReturn(SearchResultModel(totalPages: 0, totalCount: 0, hasNext: false, announcements: []))
            }
            .share(replay: 1)
        
        let searchResults = searchResponse
            .map { $0.announcements }
            .asDriver(onErrorJustReturn: [])
        
        let totalCounts = searchResponse
            .map { $0.totalCount }
            .asDriver(onErrorJustReturn: 0)
        
        let hasNextPage = searchResponse
            .map { $0.hasNext }
            .asDriver(onErrorJustReturn: false)
        
        let showSortBottom = input.sortTap.asDriver(onErrorJustReturn: ())
        
        let keyword = input.keyword.asDriver(onErrorJustReturn: "")
        
        let addScrap = input.addScrapTrigger
            .flatMapLatest { (intershipAnnouncementId, color) in
                self.scrapUseCase.execute(action: .add(internshipAnnouncementId: intershipAnnouncementId, color: color))
                    .do(onNext: {
                        successMessageTracker.onNext("관심 공고가 캘린더에 스크랩되었어요!")
                    })
                    .catch { error in
                        errorTracker.onNext("스크랩 오류: \(error.localizedDescription)")
                        return .empty()
                    }
            }
            .asDriver(onErrorDriveWith: .empty())
        
        let cancelScrap = input.cancelScrapTrigger
            .flatMapLatest { intershipAnnouncementId in
                
                self.scrapUseCase.execute(action: .remove(internshipAnnouncementId: intershipAnnouncementId))
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
            showSortBottom: showSortBottom,
            searchResults: searchResults,
            keyword: keyword,
            totalCounts: totalCounts,
            hasNextPage: hasNextPage,
            error: error,
            successMessage: successMessage,
            addScrapResult: addScrap,
            cancelScrapResult: cancelScrap
        )
    }
}

// MARK: - API

extension SearchResultViewModel {
    func fetchJobCards(keyword: String, sortBy: String, page: Int, size: Int) -> Observable<SearchResultModel> {
        return Observable.create { observer in
            let request = self.searchProvider.request(
                .getSearchResult(
                    keyword: keyword,
                    sortBy: sortBy,
                    page: page,
                    size: size
                )
            ) { result in
                switch result {
                case .success(let response):
                    let status = response.statusCode
                    if 200..<300 ~= status {
                        do {
                            let responseDto = try response.map(BaseResponse<SearchResultModel>.self)
                            if let data = responseDto.result {
                                observer.onNext(data)
                                observer.onCompleted()
                            } else {
                                observer.onError(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data available"]))
                            }
                        } catch {
                            print(error.localizedDescription)
                            observer.onError(error)
                        }
                    } else if status >= 400 {
                        observer.onError(NSError(domain: "", code: status, userInfo: [NSLocalizedDescriptionKey: "Error with status code: \(status)"]))
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    observer.onError(error)
                }
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
