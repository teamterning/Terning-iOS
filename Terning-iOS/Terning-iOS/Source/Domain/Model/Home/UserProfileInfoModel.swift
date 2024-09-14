//
//  UserProfileInfoModel.swift
//  Terning-iOS
//
//  Created by 김민성 on 7/17/24.
//

import UIKit

struct UserProfileInfoModel: Codable {
    var name: String
    var profileImage: String
    var authType: String
}

extension UserProfileInfoModel {
    static func getUserProfileInfo() -> [UserProfileInfoModel] {
        return [
            UserProfileInfoModel(
                name: "회원",
                profileImage: "basic",
                authType: "kakao"
            )
        ]
    }
}
