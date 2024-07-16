//
//  SearchViewModel.swift
//  Terning-iOS
//
//  Created by 정민지 on 7/15/24.
//

import RxSwift
import RxCocoa

final class SearchViewModel {
    private let disposeBag = DisposeBag()
    
    // MARK: - Input
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let searchButtonTapped: Observable<Void>
        let pageControlTapped: Observable<Int>
    }
    
    // MARK: - Output
    
    struct Output {
        let announcements: Driver<AdvertisementsModel>
        let recommendedByViews: Driver<[RecommendAnnouncementModel]>
        let recommendedByScraps: Driver<[RecommendAnnouncementModel]>
        let searchTapped: Driver<Void>
        let pageChanged: Driver<Int>
    }
    
    // MARK: - Transform
    
    func transform(_ input: Input) -> Output {
        let announcements = input.viewDidLoad
            .flatMapLatest { _ in
                self.fetchAdvertisement()
                    .catchAndReturn(AdvertisementsModel(advertisements: []))
            }
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

extension SearchViewModel {
    private func fetchAdvertisement() -> Observable<AdvertisementsModel> {
        let data = AdvertisementsModel(advertisements: [
            "https://helpx.adobe.com/content/dam/help/en/photoshop/using/quick-actions/remove-background-before-qa1.png",
            "https://helpx.adobe.com/content/dam/help/en/photoshop/using/quick-actions/remove-background-before-qa1.png",
            "https://helpx.adobe.com/content/dam/help/en/photoshop/using/quick-actions/remove-background-before-qa1.png"
        ])
        return Observable.just(data)
    }
    
    private func fetchRecommendedByViews() -> Observable<[RecommendAnnouncementModel]> {
        let data = [
            RecommendAnnouncementModel(id: 1, image: "https://helpx.adobe.com/content/dam/help/en/photoshop/using/quick-actions/remove-background-before-qa1.png", title: "[유한킴벌리] 허걱 대박이다"),
            RecommendAnnouncementModel(id: 2, image: "https://helpx.adobe.com/content/dam/help/en/photoshop/using/quick-actions/remove-background-before-qa1.png", title: "[Someone] 레전드 사건 발생"),
            RecommendAnnouncementModel(id: 3, image: "https://helpx.adobe.com/content/dam/help/en/photoshop/using/quick-actions/remove-background-before-qa1.png", title: "[Someone] 레전드 사건 발생"),
            RecommendAnnouncementModel(id: 4, image: "https://helpx.adobe.com/content/dam/help/en/photoshop/using/quick-actions/remove-background-before-qa1.png", title: "[Someone] 레전드 사건 발생"), RecommendAnnouncementModel(id: 5, image: "https://helpx.adobe.com/content/dam/help/en/photoshop/using/quick-actions/remove-background-before-qa1.png", title: "[Someone] 레전드 사건 발생")
        ]
        return Observable.just(data)
    }
    
    private func fetchRecommendedByScraps() -> Observable<[RecommendAnnouncementModel]> {
        let data = [
            RecommendAnnouncementModel(id: 3, image: "https://helpx.adobe.com/content/dam/help/en/photoshop/using/quick-actions/remove-background-before-qa1.png", title: "[유한킴벌리] 안녕하세요 저는"),
            RecommendAnnouncementModel(id: 4, image: "https://helpx.adobe.com/content/dam/help/en/photoshop/using/quick-actions/remove-background-before-qa1.png", title: "[Someone] 터닝 입니다.ㅇㄴㅇㄹㄴㅇㄹㄴㅇㄹㄴㅇㄹㄴㅇㄹㄴㅇㄹㄴㅇㄹㄴㅇㄹㄴㅇㄹ")
        ]
        return Observable.just(data)
    }
}
