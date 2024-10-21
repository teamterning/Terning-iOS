//
//  SearchViewModel.swift
//  Terning-iOS
//
//  Created by 정민지 on 7/15/24.
//

import UIKit

import RxSwift
import RxCocoa

final class SearchViewModel: ViewModelType {
    
    // MARK: - Properties
    
    private let searchProvider = Providers.searchProvider
    
    var advertisements: [Advertisement] = []
    
    // MARK: - Input
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let searchButtonTapped: Observable<Void>
    }
    
    // MARK: - Output
    
    struct Output {
        let announcements: Driver<[Advertisement]>
        let recommendedByViews: Driver<[RecommendAnnouncement]>
        let recommendedByScraps: Driver<[RecommendAnnouncement]>
        let searchTapped: Driver<Void>
    }
    
    // MARK: - Transform
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let announcements = input.viewDidLoad
            .do(onNext: {
                self.advertisements = [
                    Advertisement(image: .imgAd1, url: "https://www.instagram.com/p/DBWCO97TRds/?igsh=bDhjMGxlMGliNDc2"),
                    Advertisement(image: .imgAd2, url: "https://www.instagram.com/terning_official/"),
                    Advertisement(image: .imgAd3, url: "https://forms.gle/4btEwEbUQ3JSjTKP7")
                ]
            })
            .map { self.advertisements }
            .asDriver(onErrorJustReturn: [])
        
        let recommendedByViews = input.viewDidLoad
            .flatMapLatest { _ in
                self.fetchRecommendedByViews()
                    .catchAndReturn([])
            }
            .asDriver(onErrorJustReturn: [])
        
        let recommendedByScraps = input.viewDidLoad
            .flatMapLatest { _ in
                self.fetchRecommendedByScraps()
                    .catchAndReturn([])
            }
            .asDriver(onErrorJustReturn: [])
        
        let searchTapped = input.searchButtonTapped
            .asDriver(onErrorJustReturn: ())
        
        return Output(
            announcements: announcements,
            recommendedByViews: recommendedByViews,
            recommendedByScraps: recommendedByScraps,
            searchTapped: searchTapped
        )
    }
}

// MARK: - Methods

extension SearchViewModel {
    private func fetchRecommendedByViews() -> Observable<[RecommendAnnouncement]> {
        return Observable.create { observer in
            let request = self.searchProvider.request(.getMostViewDatas) { result in
                switch result {
                case .success(let response):
                    let status = response.statusCode
                    if 200..<300 ~= status {
                        do {
                            let responseDto = try response.map(BaseResponse<RecommendAnnouncementModel>.self)
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
    
    private func fetchRecommendedByScraps() -> Observable<[RecommendAnnouncement]> {
        return Observable.create { observer in
            let request = self.searchProvider.request(.getMostScrapDatas) { result in
                switch result {
                case .success(let response):
                    let status = response.statusCode
                    if 200..<300 ~= status {
                        do {
                            let responseDto = try response.map(BaseResponse<RecommendAnnouncementModel>.self)
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
