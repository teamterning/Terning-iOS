//
//  JobDetailRepository.swift
//  Terning-iOS
//
//  Created by 이명진 on 9/22/24.
//

import RxSwift

final class JobDetailRepository: JobDetailRepositoryInterface {
    
    private let scrapService: ScrapServiceProtocol
    
    init(scrapService: ScrapServiceProtocol) {
        self.scrapService = scrapService
    }
    
    func addScrap(internshipAnnouncementId: Int, color: String) -> Observable<Void> {
        return scrapService.addScrap(internshipAnnouncementId: internshipAnnouncementId, color: color)
    }
    
    func patchScrap(internshipAnnouncementId: Int, color: String) -> Observable<Void> {
        return scrapService.patchScrap(internshipAnnouncementId: internshipAnnouncementId, color: color)
    }
    
    func cancelScrap(internshipAnnouncementId: Int) -> Observable<Void> {
        return scrapService.cancelScrap(internshipAnnouncementId: internshipAnnouncementId)
    }
}
