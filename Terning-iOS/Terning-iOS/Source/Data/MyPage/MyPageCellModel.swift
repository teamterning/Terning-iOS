//
//  MyPageCellModel.swift
//  Terning-iOS
//
//  Created by 정민지 on 9/7/24.
//

import UIKit

struct MyPageBasicCellModel {
    let image: UIImage?
    let title: String
    let accessoryType: AccessoryType
}

struct MyPageProfileModel {
    let imageIndex: Int
    let name: String?
    let authType: String?
}
