//
//  SearchViewModel.swift
//  Terning-iOS
//
//  Created by 정민지 on 7/15/24.
//

import UIKit

import RxSwift
import RxCocoa

import RxMoya

final class SearchViewModel: ViewModelType {
    
    // MARK: - Properties
    
    private let searchProvider = Providers.searchProvider
    
    var advertisements: [BannerModel] = []
    
    // MARK: - Input
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let searchButtonTapped: Observable<Void>
    }
    
    // MARK: - Output
    
    struct Output {
        let announcements: Driver<[BannerModel]>
        let recommendedByViews: Driver<[RecommendAnnouncement]>
        let recommendedByScraps: Driver<[RecommendAnnouncement]>
        let searchTapped: Driver<Void>
    }
    
    // MARK: - Transform
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let announcements = input.viewDidLoad
            .flatMapLatest { _ in
                self.fetchAdveriseData()
                    .do(onNext: { fetchedAdvertisements in
                        self.advertisements = fetchedAdvertisements
                    })
                    .catchAndReturn([])
            }
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
    
    private func fetchAdveriseData() -> Observable<[BannerModel]> {
        return Observable.create { observer in
            let request = self.searchProvider.request(.getAdvertiseDatas) { result in
                switch result {
                case .success(let response):
                    let status = response.statusCode
                    if 200..<300 ~= status {
                        do {
                            let responseDto = try response.map(BaseResponse<AdvertisementModel>.self)
                            if let banners = responseDto.result?.banners {
                                observer.onNext(banners)
                                observer.onCompleted()
                            } else {
                                print("No banner data available")
                                observer.onError(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "배너 데이터 없음"]))
                            }
                        } catch {
                            print(error.localizedDescription)
                            observer.onError(error)
                        }
                    } else if status >= 400 {
                        print("Server error with status code: \(status)")
                        observer.onError(NSError(domain: "", code: status, userInfo: [NSLocalizedDescriptionKey: "에러 상태 코드: \(status)"]))
                    }
                case .failure(let error):
                    print("Network error: \(error.localizedDescription)")
                    observer.onError(error)
                }
            }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
