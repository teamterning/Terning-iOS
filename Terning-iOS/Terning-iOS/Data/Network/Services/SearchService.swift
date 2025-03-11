//
//  SearchService.swift
//  Terning-iOS
//
//  Created by 정민지 on 3/10/25.
//

import RxSwift
import Moya
import RxMoya

protocol SearchServiceProtocol {
    func getSearchResult(keyword: String, sortBy: String, page: Int, size: Int) -> Observable<SearchResultModel>
    func getMostViewDatas() -> Observable<[RecommendAnnouncement]>
    func getMostScrapDatas() -> Observable<[RecommendAnnouncement]>
    func getAdvertiseDatas() -> Observable<[BannerModel]>
}

final class SearchService: SearchServiceProtocol {
    
    private let provider: MoyaProvider<SearchTargetType>
    
    init(provider: MoyaProvider<SearchTargetType>) {
        self.provider = provider
    }
    
    func getSearchResult(keyword: String, sortBy: String, page: Int, size: Int) -> Observable<SearchResultModel> {
        return provider.rx.request(.getSearchResult(keyword: keyword, sortBy: sortBy, page: page, size: size))
            .filterSuccessfulStatusCodes()
            .map(BaseResponse<SearchResultModel>.self)
            .compactMap { $0.result }
            .asObservable()
    }
    
    func getMostViewDatas() -> Observable<[RecommendAnnouncement]> {
        return provider.rx.request(.getMostViewDatas)
            .filterSuccessfulStatusCodes()
            .map(BaseResponse<RecommendAnnouncementModel>.self)
            .compactMap { $0.result?.announcements }
            .asObservable()
    }
    
    func getMostScrapDatas() -> Observable<[RecommendAnnouncement]> {
        return provider.rx.request(.getMostScrapDatas)
            .filterSuccessfulStatusCodes()
            .map(BaseResponse<RecommendAnnouncementModel>.self)
            .compactMap { $0.result?.announcements }
            .asObservable()
    }
    
    func getAdvertiseDatas() -> Observable<[BannerModel]> {
        return provider.rx.request(.getAdvertiseDatas)
            .filterSuccessfulStatusCodes()
            .map(BaseResponse<AdvertisementModel>.self)
            .compactMap { $0.result?.banners }
            .asObservable()
    }
}
