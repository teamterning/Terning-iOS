//
//  SignInResponseModel.swift
//  Terning-iOS
//
//  Created by 이명진 on 7/16/24.
//

import Foundation

// MARK: - SignInResponseDto

struct SignInResponseModel: Codable {
    let accessToken, refreshToken: String
    let userId: Int
    let authId: String
    let authType: String
}
