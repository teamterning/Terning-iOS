//
//  ScrapsRepository.swift
//  Terning-iOS
//
//  Created by 이명진 on 8/26/24.
//

import RxSwift

protocol ScrapsRepositoryProtocol {
    func patchScrap(scrapId: Int, color: Int) -> Observable<Void>
    func cancelScrap(scrapId: Int) -> Observable<Void>
}

final class ScrapsRepository: ScrapsRepositoryProtocol {
    
    private let service: ScrapsServiceProtocol
    
    init(service: ScrapsServiceProtocol) {
        self.service = service
    }
    
    func patchScrap(scrapId: Int, color: Int) -> Observable<Void> {
        return service.patchScrap(scrapId: scrapId, color: color)
    }
    
    func cancelScrap(scrapId: Int) -> Observable<Void> {
        return service.cancelScrap(scrapId: scrapId)
    }
}
