//
//  ScrapsService.swift
//  Terning-iOS
//
//  Created by 이명진 on 8/26/24.
//

import RxSwift
import Moya
import RxMoya

protocol ScrapServiceProtocol {
    func addScrap(internshipAnnouncementId: Int, color: String) -> Observable<Void>
    func patchScrap(internshipAnnouncementId: Int, color: String) -> Observable<Void>
    func cancelScrap(internshipAnnouncementId: Int) -> Observable<Void>
}

final class ScrapsService: ScrapServiceProtocol {
    
    private let provider: MoyaProvider<ScrapsTargetType>
    
    init(provider: MoyaProvider<ScrapsTargetType>) {
        self.provider = provider
    }
    
    func addScrap(internshipAnnouncementId: Int, color: String) -> RxSwift.Observable<Void> {
        return provider.rx.request(.addScrap(internshipAnnouncementId: internshipAnnouncementId, color: color))
            .filterSuccessfulStatusCodes()
            .map { _ in () }
            .asObservable()
    }
    
    func patchScrap(internshipAnnouncementId: Int, color: String) -> Observable<Void> {
        return provider.rx.request(.patchScrap(internshipAnnouncementId: internshipAnnouncementId, color: color))
            .filterSuccessfulStatusCodes()
            .map { _ in () }
            .asObservable()
    }
    
    func cancelScrap(internshipAnnouncementId: Int) -> Observable<Void> {
        return provider.rx.request(.removeScrap(internshipAnnouncementId: internshipAnnouncementId))
            .filterSuccessfulStatusCodes()
            .map { _ in () }
            .asObservable()
    }
}
