//
//  FiltersService.swift
//  Terning-iOS
//
//  Created by 정민지 on 12/28/24.
//

import RxSwift
import Moya
import RxMoya

protocol FiltersServiceProtocol {
    func getFilterDatas() -> Observable<FiltersModel>
    func setFilterDatas(
        grade: String?,
        workingPeriod: String?,
        startYear: Int?,
        startMonth: Int?,
        jobType: String?
    ) -> Observable<Void>
}

final class FiltersService: FiltersServiceProtocol {
    private let provider: MoyaProvider<FiltersTargetType>
    
    init(provider: MoyaProvider<FiltersTargetType>) {
        self.provider = provider
    }
    
    func getFilterDatas() -> RxSwift.Observable<FiltersModel> {
        return provider.rx.request(.getFilterDatas)
            .filterSuccessfulStatusCodes()
            .map(BaseResponse<FiltersModel>.self)
            .compactMap { $0.result }
            .asObservable()
    }
    
    func setFilterDatas(
        grade: String?,
        workingPeriod: String?,
        startYear: Int?,
        startMonth: Int?,
        jobType: String?
    ) -> RxSwift.Observable<Void> {
        return provider.rx.request(
            .setFilterDatas(
                grade: grade,
                workingPeriod: workingPeriod,
                startYear: startYear,
                startMonth: startMonth,
                jobType: jobType
            )
        )
        .filterSuccessfulStatusCodes()
        .map { _ in () }
        .asObservable()
    }
}
