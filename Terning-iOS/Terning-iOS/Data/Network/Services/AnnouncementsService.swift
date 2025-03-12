//
//  AnnouncementsService.swift
//  Terning-iOS
//
//  Created by 정민지 on 3/11/25.
//

import RxSwift
import Moya
import RxMoya

protocol AnnouncementsServiceProtocol {
    func getDetailAnnouncements(internshipAnnouncementId: Int) -> Observable<JobDetailModel>
}

final class AnnouncementsService: AnnouncementsServiceProtocol {
    
    private let provider: MoyaProvider<AnnouncementsTargetType>
    
    init(provider: MoyaProvider<AnnouncementsTargetType>) {
        self.provider = provider
    }
    
    func getDetailAnnouncements(internshipAnnouncementId: Int) -> Observable<JobDetailModel> {
        return provider.rx.request(.getAnnouncements(internshipAnnouncementId: internshipAnnouncementId))
            .filterSuccessfulStatusCodes()
            .map(BaseResponse<JobDetailModel>.self)
            .compactMap { $0.result }
            .asObservable()
    }
}
