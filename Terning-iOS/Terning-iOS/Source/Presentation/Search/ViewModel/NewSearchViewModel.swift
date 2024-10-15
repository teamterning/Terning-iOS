//
//  NewSearchViewModel.swift
//  Terning-iOS
//
//  Created by 이명진 on 10/12/24.
//

import UIKit

import RxSwift
import RxCocoa

final class NewSearchViewModel: ViewModelType {
    
    // MARK: - Properties
    
    private let searchProvider = Providers.searchProvider
    
    var advertisements: [UIImage] = []
    
    // MARK: - Input
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let searchButtonTapped: Observable<Void>
        let pageControlTapped: Observable<Int>
    }
    
    // MARK: - Output
    
    struct Output {
        let announcements: Driver<AdvertisementsModel>
        let recommendedByViews: Driver<[RecommendAnnouncement]>
        let recommendedByScraps: Driver<[RecommendAnnouncement]>
        let searchTapped: Driver<Void>
        let pageChanged: Driver<Int>
    }
    
    // MARK: - Transform
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let announcements = input.viewDidLoad
            .do(onNext: {
                // 기본 이미지 배열 추가
                self.advertisements = [
                    UIImage(named: "img_ad_1")!,
                    UIImage(named: "img_ad_2")!,
                    UIImage(named: "img_ad_3")!
                ]
            })
            .map { AdvertisementsModel(advertisements: self.advertisements) }
            .asDriver(onErrorJustReturn: AdvertisementsModel(advertisements: []))
        
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
        
        let pageChanged = input.pageControlTapped
            .asDriver(onErrorJustReturn: 0)
        
        return Output(
            announcements: announcements,
            recommendedByViews: recommendedByViews,
            recommendedByScraps: recommendedByScraps,
            searchTapped: searchTapped,
            pageChanged: pageChanged
        )
    }
}

// MARK: - Methods

extension NewSearchViewModel {
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
