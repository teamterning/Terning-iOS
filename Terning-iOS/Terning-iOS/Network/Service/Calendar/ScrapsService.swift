//
//  ScrapsService.swift
//  Terning-iOS
//
//  Created by 이명진 on 8/26/24.
//

import RxSwift
import Moya
import RxMoya

protocol ScrapsServiceProtocol {
    func patchScrap(scrapId: Int, color: Int) -> Observable<Void>
    func cancelScrap(scrapId: Int) -> Observable<Void>
}

final class ScrapsService: ScrapsServiceProtocol {
    
    private let provider: MoyaProvider<ScrapsTargetType>
    
    init(provider: MoyaProvider<ScrapsTargetType>) {
        self.provider = provider
    }
    
    func patchScrap(scrapId: Int, color: Int) -> Observable<Void> {
        return provider.rx.request(.patchScrap(scrapId: scrapId, color: color))
            .filterSuccessfulStatusCodes()
            .map { _ in () }
            .asObservable()
    }
    
    func cancelScrap(scrapId: Int) -> Observable<Void> {
        return provider.rx.request(.removeScrap(scrapId: scrapId))
            .filterSuccessfulStatusCodes()
            .map { _ in () }
            .asObservable()
    }
}
