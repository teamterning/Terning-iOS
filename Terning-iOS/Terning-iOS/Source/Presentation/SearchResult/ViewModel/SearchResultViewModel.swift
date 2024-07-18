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
        let sortBy: Observable<String>
        let page: Observable<Int>
        let size: Observable<Int>
        let searchTrigger: Observable<Void>
    }
    
    // MARK: - Output
    
    struct Output {
        let SearchResult: Driver<[SearchResult]>
        let keyword: Driver<String>
    }
    
    // MARK: - Transform
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let SearchResult = input.searchTrigger
            .withLatestFrom(Observable.combineLatest(input.keyword, input.sortBy, input.page, input.size))
            .flatMapLatest { keyword, sortBy, page, size in
                self.fetchJobCards(keyword: keyword, sortBy: sortBy, page: page, size: size)
                    .catchAndReturn([])
            }
            .asDriver(onErrorJustReturn: [])
        
        let keyword = input.keyword.asDriver(onErrorJustReturn: "")
        
        return Output(SearchResult: SearchResult, keyword: keyword)
    }
}

extension SearchResultViewModel {
    private func fetchJobCards(keyword: String, sortBy: String, page: Int, size: Int) -> Observable<[SearchResult]> {
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
                               if let data = responseDto.result?.announcements {
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
                       }
                       if status >= 400 {
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
