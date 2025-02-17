//
//  TextViewFactory.swift
//  Terning-iOS
//
//  Created by 이명진 on 2/5/25.
//

import UIKit

struct TextViewFactory {
    /// - Parameters:
    ///   - text: TextView에 보여줄 텍스트
    ///   - font: 텍스트의 폰트
    ///   - backgroundColor: TextView의 배경색
    ///   - textColor: text 색상
    ///   - textAlignment: text 정렬
    ///   - lineSpacing: 행간 (default = 1.3 (130%))
    ///   - characterSpacing: 자간 (default = -0.5 (-0.005))
    ///
    static func build(
        text: String? = "",
        font: UIFont,
        backgroundColor: UIColor = .clear,
        textColor: UIColor = .terningBlack,
        textAlignment: NSTextAlignment = .center,
        lineSpacing: CGFloat = 1.3,
        characterSpacing: CGFloat = -0.005
    ) -> UITextView {
        let textView = UITextView()
        textView.text = text
        textView.font = font
        textView.backgroundColor = backgroundColor
        textView.textColor = textColor
        textView.textAlignment = textAlignment
        textView.setTextViewLineSpacing(lineSpacing: lineSpacing)
        textView.setTextViewCharacterSpacing(characterSpacing)
        return textView
    }
}
