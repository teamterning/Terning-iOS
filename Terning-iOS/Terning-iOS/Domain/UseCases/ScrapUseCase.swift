//
//  ScrapUseCaseProtocol.swift
//  Terning-iOS
//
//  Created by 이명진 on 1/3/25.
//

import RxSwift

enum ScrapAction {
    case add(internshipAnnouncementId: Int, color: String)
    case patch(internshipAnnouncementId: Int, color: String)
    case remove(internshipAnnouncementId: Int)
}

protocol ScrapUseCaseProtocol {
    func execute(action: ScrapAction) -> Observable<Void>
}

final class ScrapUseCase: ScrapUseCaseProtocol {
    
    private let repository: ScrapRepositoryInterface
    
    init(repository: ScrapRepositoryInterface) {
        self.repository = repository
    }
    
    func execute(action: ScrapAction) -> Observable<Void> {
        switch action {
        case .add(let id, let color):
            return repository.addScrap(internshipAnnouncementId: id, color: color)
        case .patch(let id, let color):
            return repository.patchScrap(internshipAnnouncementId: id, color: color)
        case .remove(let id):
            return repository.cancelScrap(internshipAnnouncementId: id)
        }
    }
}
