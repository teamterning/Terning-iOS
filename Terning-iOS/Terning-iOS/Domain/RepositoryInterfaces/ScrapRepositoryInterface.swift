//
//  ScrapRepositoryInterface.swift
//  Terning-iOS
//
//  Created by 이명진 on 9/22/24.
//

import RxSwift

protocol ScrapRepositoryInterface {
    func addScrap(internshipAnnouncementId: Int, color: String) -> Observable<Void>
    func patchScrap(internshipAnnouncementId: Int, color: String) -> Observable<Void>
    func cancelScrap(internshipAnnouncementId: Int) -> Observable<Void>
}
