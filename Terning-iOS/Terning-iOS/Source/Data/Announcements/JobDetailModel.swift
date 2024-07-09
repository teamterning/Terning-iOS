//
//  JobDetailModel.swift
//  Terning-iOS
//
//  Created by 이명진 on 7/8/24.
//

import Foundation

struct JobDetailModel: Codable {
    let dDay: String
    let title: String
    let deadline: String
    let workingPeriod: String
    let startDate: String
    let viewCount: Int
    let company: String
    let companyCategory: String
    let companyImage: String
    let qualification: String
    let jobType: String
    let detail: String
    let url: String
    let isScrap: Bool
}
