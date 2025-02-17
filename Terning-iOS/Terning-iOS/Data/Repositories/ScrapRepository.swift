//
//  ScrapRepository.swift
//  Terning-iOS
//
//  Created by 이명진 on 1/3/25.
//

import Foundation
import RxSwift

protocol ScrapRepositoryProtocol {
    func addScrap(internshipAnnouncementId: Int, color: String) -> Observable<Void>
    func patchScrap(internshipAnnouncementId: Int, color: String) -> Observable<Void>
    func cancelScrap(internshipAnnouncementId: Int) -> Observable<Void>
}

final class ScrapRepository: ScrapRepositoryProtocol {
    
    private let service: ScrapServiceProtocol
    
    init(service: ScrapServiceProtocol) {
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
