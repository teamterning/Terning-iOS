//
//  ValidationMessage.swift
//  Terning-iOS
//
//  Created by 정민지 on 7/10/24.
//

import UIKit

enum ValidationMessage: String {
    case valid = "이용 가능한 이름이에요"
    case tooLong = "이름은 12자리 이내로 설정해 주세요"
    case containsSpecialCharacters = "이름에 특수문자는 입력할 수 없어요"
    case containsSymbols = "이름에 기호는 입력할 수 없어요"
    case defaultMessage = "12자리 이내, 문자/숫자 가능, 특수문자/기호 입력불가"
    
    var textColor: UIColor {
        switch self {
        case .valid:
            return .terningMain
        case .tooLong, .containsSpecialCharacters, .containsSymbols:
            return .warningRed
        default:
            return .grey400
        }
    }
    
    var underlineColor: UIColor {
        switch self {
        case .valid:
            return .terningMain
        case .tooLong, .containsSpecialCharacters, .containsSymbols:
            return .warningRed
        default:
            return .grey400
        }
    }
    
    var iconImage: UIImage? {
        switch self {
        case .valid:
            return UIImage(systemName: "checkmark.circle.fill")
        case .tooLong, .containsSpecialCharacters, .containsSymbols:
            return UIImage(systemName: "exclamationmark.circle.fill")
        default:
            return nil
        }
    }
    
    var iconTintColor: UIColor? {
        switch self {
        case .valid:
            return .terningMain
        case .tooLong, .containsSpecialCharacters, .containsSymbols:
            return .warningRed
        default:
            return nil
        }
    }
}
