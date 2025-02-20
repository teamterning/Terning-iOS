//
//  FiltersModel.swift
//  Terning-iOS
//
//  Created by 정민지 on 12/28/24.
//

struct FiltersModel: Codable {
    let grade: Grade?
    let workingPeriod: WorkingPeriod?
    let startYear: Int?
    let startMonth: Int?
    let jobType: JobType?
}
