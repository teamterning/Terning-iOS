//
//  FiltersRepositoryInterface.swift
//  Terning-iOS
//
//  Created by 정민지 on 12/28/24.
//

import RxSwift

protocol FiltersRepositoryInterface {
    func getFilterDatas() -> Observable<FiltersModel>
    func setFilterDatas(
        grade: String?,
        workingPeriod: String?,
        startYear: Int?,
        startMonth: Int?,
        jobType: String?
    ) -> Observable<Void>
}
