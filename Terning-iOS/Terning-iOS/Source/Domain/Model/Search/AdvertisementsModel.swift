//
//  AdvertisementsModel.swift
//  Terning-iOS
//
//  Created by 정민지 on 7/16/24.
//

import UIKit

// MARK: - AdvertisementsModel

struct AdvertisementModel: Codable {
    let banners: [BannerModel]
}

struct BannerModel: Codable {
    let imageUrl: String
    let link: String
}
