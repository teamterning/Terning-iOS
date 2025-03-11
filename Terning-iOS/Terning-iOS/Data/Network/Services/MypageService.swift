//
//  MypageService.swift
//  Terning-iOS
//
//  Created by 정민지 on 3/11/25.
//

import RxSwift
import Moya
import RxMoya

protocol MypageServiceProtocol {
    func getProfileInfo() -> Observable<UserProfileInfoModel>
    func patchProfileInfo(name: String, profileImage: String) -> Observable<Void>
}

final class MypageService: MypageServiceProtocol {
    
    private let provider: MoyaProvider<MyPageTargetType>
    
    init(provider: MoyaProvider<MyPageTargetType>) {
        self.provider = provider
    }
    
    func getProfileInfo() -> Observable<UserProfileInfoModel> {
        return provider.rx.request(.getProfileInfo)
            .filterSuccessfulStatusCodes()
            .map(BaseResponse<UserProfileInfoModel>.self)
            .compactMap { $0.result }
            .asObservable()
    }
    
    func patchProfileInfo(name: String, profileImage: String) -> Observable<Void> {
        return provider.rx.request(.patchProfileInfo(name: name, profileImage: profileImage))
            .filterSuccessfulStatusCodes()
            .map { _ in () }
            .asObservable()
    }
}
