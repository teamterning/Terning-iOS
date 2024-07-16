//
//  UserFilteringInfoModel.swift
//  Terning-iOS
//
//  Created by 김민성 on 7/17/24.
//

import UIKit

struct UserFilteringInfoModel {
    let grade: Int
    let workingPeriod: Int
    let startYear: Int
    let startMonth: Int
}

extension UserFilteringInfoModel {
    static func getUserFilteringInfo() -> [UserFilteringInfoModel]{
        return [
            UserFilteringInfoModel(
                grade: 1,
                workingPeriod: 2,
                startYear: 2024,
                startMonth: 5
            )
        ]
    }
}
