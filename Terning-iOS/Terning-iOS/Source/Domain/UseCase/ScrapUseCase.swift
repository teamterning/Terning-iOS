//
//  ScrapUseCaseProtocol.swift
//  Terning-iOS
//
//  Created by 이명진 on 1/3/25.
//

import Foundation
import RxSwift

protocol ScrapUseCaseProtocol {
    func addScrap(internshipAnnouncementId: Int, color: String) -> Observable<Void>
    func patchScrap(internshipAnnouncementId: Int, color: String) -> Observable<Void>
    func cancelScrap(internshipAnnouncementId: Int) -> Observable<Void>
}

final class ScrapUseCase: ScrapUseCaseProtocol {
    
    private let repository: ScrapRepositoryProtocol
    
    init(repository: ScrapRepositoryProtocol) {
        self.repository = repository
    }
    
    func addScrap(internshipAnnouncementId: Int, color: String) -> Observable<Void> {
        return repository.addScrap(internshipAnnouncementId: internshipAnnouncementId, color: color)
    }
    
    func patchScrap(internshipAnnouncementId: Int, color: String) -> Observable<Void> {
        return repository.patchScrap(internshipAnnouncementId: internshipAnnouncementId, color: color)
    }
    
    func cancelScrap(internshipAnnouncementId: Int) -> Observable<Void> {
        return repository.cancelScrap(internshipAnnouncementId: internshipAnnouncementId)
    }
}
