//
//  ScrapsRepository.swift
//  Terning-iOS
//
//  Created by 이명진 on 8/26/24.
//

import RxSwift

protocol ScrapsRepositoryProtocol {
    func addScrap(internshipAnnouncementId: Int, color: String) -> Observable<Void>
    func patchScrap(internshipAnnouncementId: Int, color: String) -> Observable<Void>
    func cancelScrap(internshipAnnouncementId: Int) -> Observable<Void>
}

final class ScrapsRepository: ScrapsRepositoryProtocol {
    
    private let service: ScrapsServiceProtocol
    
    init(service: ScrapsServiceProtocol) {
        self.service = service
    }
    
    func addScrap(internshipAnnouncementId: Int, color: String) -> Observable<Void> {
        return service.addScrap(internshipAnnouncementId: internshipAnnouncementId, color: color)
    }
    
    func patchScrap(internshipAnnouncementId: Int, color: String) -> Observable<Void> {
        return service.patchScrap(internshipAnnouncementId: internshipAnnouncementId, color: color)
    }
    
    func cancelScrap(internshipAnnouncementId: Int) -> Observable<Void> {
        return service.cancelScrap(internshipAnnouncementId: internshipAnnouncementId)
    }
}
