//
//  FiltersRepository.swift
//  Terning-iOS
//
//  Created by 정민지 on 12/28/24.
//

import RxSwift

final class FiltersRepository: FiltersRepositoryInterface {
    
    private let filtersService: FiltersServiceProtocol
    
    init(filtersService: FiltersServiceProtocol) {
        self.filtersService = filtersService
    }

    func getFilterDatas() -> Observable<FiltersModel> {
        return filtersService.getFilterDatas()
    }
    
    func setFilterDatas(
        grade: String?,
        workingPeriod: String?,
        startYear: Int?,
        startMonth: Int?,
        jobType: String?
    ) -> Observable<Void> {
        return filtersService.setFilterDatas(
            grade: grade,
            workingPeriod: workingPeriod,
            startYear: startYear,
            startMonth: startMonth,
            jobType: jobType
        )
    }
}
