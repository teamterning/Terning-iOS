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
    func patchScrap(internshipAnnouncementId: Int, color: String) -> Observable<Void>
    func cancelScrap(internshipAnnouncementId: Int) -> Observable<Void>
}

final class ScrapsService: ScrapsServiceProtocol {
    
    private let provider: MoyaProvider<ScrapsTargetType>
    
    init(provider: MoyaProvider<ScrapsTargetType>) {
        self.provider = provider
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
