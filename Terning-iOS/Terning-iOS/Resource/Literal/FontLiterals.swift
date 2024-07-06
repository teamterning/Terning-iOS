//
//  FontLiterals.swift
//  Terning-iOS
//
//  Created by 이명진 on 7/5/24.
//

import UIKit

extension UIFont {
    @nonobjc class var heading1: UIFont {
        return UIFont.font(.pretendardSemiBold, ofSize: 24)
    }
    
    @nonobjc class var heading2: UIFont {
        return UIFont.font(.pretendardSemiBold, ofSize: 22)
    }
    
    @nonobjc class var title1: UIFont {
        return UIFont.font(.pretendardSemiBold, ofSize: 20)
    }
    
    @nonobjc class var title2: UIFont {
        return UIFont.font(.pretendardSemiBold, ofSize: 18)
    }
    
    @nonobjc class var title3: UIFont {
        return UIFont.font(.pretendardMedium, ofSize: 18)
    }
    
    @nonobjc class var title4: UIFont {
        return UIFont.font(.pretendardSemiBold, ofSize: 16)
    }
    
    @nonobjc class var title5: UIFont {
        return UIFont.font(.pretendardMedium, ofSize: 15)
    }
    
    @nonobjc class var body0: UIFont {
        return UIFont.font(.pretendardMedium, ofSize: 20)
    }
    
    @nonobjc class var body1: UIFont {
        return UIFont.font(.pretendardMedium, ofSize: 16)
    }
    
    @nonobjc class var body2: UIFont {
        return UIFont.font(.pretendardMedium, ofSize: 15)
    }
    
    @nonobjc class var body3: UIFont {
        return UIFont.font(.pretendardRegular, ofSize: 14)
    }
    
    @nonobjc class var body4: UIFont {
        return UIFont.font(.pretendardMedium, ofSize: 14)
    }
    
    @nonobjc class var body5: UIFont {
        return UIFont.font(.pretendardMedium, ofSize: 14)
    }
    
    @nonobjc class var body6: UIFont {
        return UIFont.font(.pretendardMedium, ofSize: 12)
    }
    
    @nonobjc class var body7: UIFont {
        return UIFont.font(.pretendardLight, ofSize: 12)
    }
    
    @nonobjc class var button0: UIFont {
        return UIFont.font(.pretendardSemiBold, ofSize: 16)
    }
    
    @nonobjc class var button1: UIFont {
        return UIFont.font(.pretendardMedium, ofSize: 16)
    }
    
    @nonobjc class var button2: UIFont {
        return UIFont.font(.pretendardMedium, ofSize: 16)
    }
    
    @nonobjc class var button3: UIFont {
        return UIFont.font(.pretendardMedium, ofSize: 14)
    }
    
    @nonobjc class var button4: UIFont {
        return UIFont.font(.pretendardMedium, ofSize: 12)
    }
    
    @nonobjc class var button5: UIFont {
        return UIFont.font(.pretendardMedium, ofSize: 11)
    }
    
    @nonobjc class var button6: UIFont {
        return UIFont.font(.pretendardMedium, ofSize: 10)
    }
    
    @nonobjc class var detail0: UIFont {
        return UIFont.font(.pretendardSemiBold, ofSize: 14)
    }
    
    @nonobjc class var detail1: UIFont {
        return UIFont.font(.pretendardRegular, ofSize: 14)
    }
    
    @nonobjc class var detail2: UIFont {
        return UIFont.font(.pretendardLight, ofSize: 13)
    }
    
    @nonobjc class var detail3: UIFont {
        return UIFont.font(.pretendardLight, ofSize: 12)
    }
    
    @nonobjc class var detail4: UIFont {
        return UIFont.font(.pretendardLight, ofSize: 11)
    }
    
    @nonobjc class var detail5: UIFont {
        return UIFont.font(.pretendardLight, ofSize: 10)
    }
    
    @nonobjc class var calendar: UIFont {
        return UIFont.font(.pretendardRegular, ofSize: 16)
    }
}

enum FontName: String {
    case pretendardLight = "Pretendard-Light"
    case pretendardMedium = "Pretendard-Medium"
    case pretendardRegular = "Pretendard-Regular"
    case pretendardSemiBold = "Pretendard-SemiBold"
}

extension UIFont {
    static func font(_ style: FontName, ofSize size: CGFloat) -> UIFont {
        guard let customFont = UIFont(name: style.rawValue, size: size) else {
            print("🍎 \(style.rawValue) font 가 등록되지 않았습니다.! 🍎")
            print("🍎 기본 폰트 출력 ! 🍎")
            return UIFont.systemFont(ofSize: size)
        }
        return customFont
    }
}
