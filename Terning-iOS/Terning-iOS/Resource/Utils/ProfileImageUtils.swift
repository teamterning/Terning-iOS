//
//  ProfileImageUtils.swift
//  Terning-iOS
//
//  Created by 정민지 on 9/8/24.
//

import UIKit

struct ProfileImageUtils {
    static func imageForProfile(imageString: String) -> UIImage? {
        switch imageString {
        case "basic":
            return .profileBasic
        case "lucky":
            return .profileLucky
        case "smart":
            return .profileSmart
        case "glass":
            return .profileGlass
        case "calendar":
            return .profileCalendar
        case "passion":
            return .profilePassion
        default:
            return .profileBasic
        }
    }
    
    static let imageStrings = [
        "basic",
        "lucky",
        "smart",
        "glass",
        "calendar",
        "passion"
    ]
}

extension ProfileImageUtils {
    static func imageForProfile(index: Int) -> UIImage? {
        guard index >= 0 && index < imageStrings.count else {
            return .profileBasic
        }
        let imageString = imageStrings[index]
        return imageForProfile(imageString: imageString)
    }
}

extension ProfileImageUtils {
    static func stringForProfile(index: Int) -> String {
        guard index >= 0 && index < imageStrings.count else {
            return "basic"
        }
        
        return imageStrings[index]
    }
}
