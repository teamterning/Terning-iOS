//
//  UserFilteringInfoModel.swift
//  Terning-iOS
//
//  Created by 김민성 on 7/17/24.
//

import UIKit

struct UserFilteringInfoModel: Codable {
    let grade: String?
    let workingPeriod: String?
    let startYear: Int?
    let startMonth: Int?
    let jobType: String?
}
