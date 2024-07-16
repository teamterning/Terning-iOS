//
//  Config.swift
//  Terning-iOS
//
//  Created by 이명진 on 7/16/24.
//

import UIKit

struct Config {
    private init() {}
    
    // terning Main Server
    static var baseURL: String {
        return "https://www.terning-official.p-e.kr/api/v1"
    }
    
    static var defaultHeader: [String: String] {
        return ["Content-Type": "application/json"]
    }
    
    static var userIdHeader: [String: String] {
        return [
            "Content-Type": "application/json",
            "User-Id": Config.userId
        ]
    }
    
    static var headerWithAccessTokenAndRefreshToken: [String: String] {
        return [
            "Content-Type": "application/json",
            "accessToken": Config.accessToken,
            "refreshToken": Config.refreshToken
        ]
    }
    
    static var headerWithAccessToken: [String: String] {
        return [
            "Content-Type": "application/json",
            "accessToken": Config.accessToken
        ]
    }
    
    static var accessToken: String {
        return  UserManager.shared.accessToken ?? ""
    }
    
    static var refreshToken: String {
        return  UserManager.shared.refreshToken ?? ""
    }
    
    static var userId: String {
        return UserManager.shared.userId ?? ""
    }
    
    static var authType: String {
        guard let authType = UserManager.shared.authType else { return "" }
        
        return authType
    }
    
    static var kakaoDeveloperName: String {
        return "Terning"
    }
    
    static var appleDeveloperName: String {
        return "이명진"
    }
}
