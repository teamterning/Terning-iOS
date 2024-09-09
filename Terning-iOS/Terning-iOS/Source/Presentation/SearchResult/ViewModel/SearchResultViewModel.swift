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
    
    // MARK: - Input
    
    struct Input {
        let keyword: Observable<String>
        let sortTap: Observable<Void>
        let sortBy: Observable<String>
        let page: Observable<Int>
        let size: Observable<Int>
        let searchTrigger: Observable<Void>
    }
    
    // MARK: - Output
    
    struct Output {
        let showSortBottom: Driver<Void>
        let searchResults: Driver<[SearchResult]>
        let keyword: Driver<String>
        let totalPages: Driver<Int>
        let hasNextPage: Driver<Bool>
    }
    
    // MARK: - Transform
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let searchResponse = input.searchTrigger
            .do(onNext: { print("searchTrigger 발생") }) 
            .withLatestFrom(Observable.combineLatest(input.keyword, input.sortBy, input.page, input.size))
            .flatMapLatest { keyword, sortBy, page, size in
                print("Fetching job cards with keyword: \(keyword), sortBy: \(sortBy), page: \(page), size: \(size)")
                
                return self.fetchJobCards(keyword: keyword, sortBy: sortBy, page: page, size: size)
                    .catchAndReturn(SearchResultModel(totalPages: 0, hasNext: false, announcements: []))
            }
            .do(onNext: { response in
                print("Search response received: \(response)")
            })
            .share(replay: 1)

        let searchResults = searchResponse
            .map { $0.announcements }
            .asDriver(onErrorJustReturn: [])

        let totalPages = searchResponse
            .map { $0.totalPages }
            .asDriver(onErrorJustReturn: 0)

        let hasNextPage = searchResponse
            .map { $0.hasNext }
            .asDriver(onErrorJustReturn: false)

        let showSortBottom = input.sortTap.asDriver(onErrorJustReturn: ())
        
        let keyword = input.keyword.asDriver(onErrorJustReturn: "")
        
        return Output(
            showSortBottom: showSortBottom,
            searchResults: searchResults,
            keyword: keyword,
            totalPages: totalPages,
            hasNextPage: hasNextPage
        )
    }

    // MARK: - Networking
    
    private func fetchJobCards(keyword: String, sortBy: String, page: Int, size: Int) -> Observable<SearchResultModel> {
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
                                print("no data")
                                observer.onError(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data available"]))
                            }
                        } catch {
                            print(error.localizedDescription)
                            observer.onError(error)
                        }
                    } else if status >= 400 {
                        print("400 error")
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
