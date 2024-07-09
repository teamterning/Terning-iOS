//
//  LabelFactory.swift
//  Terning-iOS
//
//  Created by 이명진 on 7/7/24.
//

import UIKit

import Then

struct LabelFactory {
    /// - Parameters:
    ///   - text: Label에 보여줄 텍스트
    ///   - font: 텍스트의 폰트
    ///   - backgroundColor: Label의 배경색
    ///   - textColor: text 색상
    ///   - textAlignment: text 정렬
    ///   - lineSpacing: 행간 (defalut = 1.3 (130%)
    ///   - characterSpacing: 자간 (defalut = -0.5 (-0.005))
    ///
    static func build(
        text: String?,
        font: UIFont,
        backgroundColor: UIColor = .clear,
        textColor: UIColor = .terningBlack,
        textAlignment: NSTextAlignment = .center,
        lineSpacing: CGFloat = 1.3,
        characterSpacing: CGFloat = -0.005) -> UILabel {
            return UILabel().then {
                $0.text = text
                $0.font = font
                $0.backgroundColor = backgroundColor
                $0.textColor = textColor
                $0.textAlignment = textAlignment
                $0.setLineSpacing(lineSpacing: lineSpacing)
                $0.setCharacterSpacing(characterSpacing)
            }
        }
}
