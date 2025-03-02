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

final class ScrapsService {
    
    private let provider: MoyaProvider<ScrapsTargetType>
    
    init(provider: MoyaProvider<ScrapsTargetType>) {
        self.provider = provider
    }
}

extension ScrapsService: ScrapServiceProtocol {
    func addScrap(internshipAnnouncementId: Int, color: String) -> Observable<Void> {
        return request(.addScrap(internshipAnnouncementId: internshipAnnouncementId, color: color))
    }
    
    func patchScrap(internshipAnnouncementId: Int, color: String) -> Observable<Void> {
        return request(.patchScrap(internshipAnnouncementId: internshipAnnouncementId, color: color))
    }
    
    func cancelScrap(internshipAnnouncementId: Int) -> Observable<Void> {
        return request(.removeScrap(internshipAnnouncementId: internshipAnnouncementId))
    }
    
    private func request(_ target: ScrapsTargetType) -> Observable<Void> {
        return provider.rx.request(target)
            .filterSuccessfulStatusCodes()
            .map { _ in () }
            .asObservable()
    }
}
