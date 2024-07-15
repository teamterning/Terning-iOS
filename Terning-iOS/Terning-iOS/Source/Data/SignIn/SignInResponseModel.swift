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
    let userId: String
    let authType: String
}

