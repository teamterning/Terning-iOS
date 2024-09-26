//
//  JobCardModel.swift
//  Terning-iOS
//
//  Created by 김민성 on 7/10/24.
//

import UIKit

struct JobCardModel: Codable {
    let totalCount: Int
    let result: [AnnouncementModel]
}
