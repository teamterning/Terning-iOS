//
//  UITextView+.swift
//  Terning-iOS
//
//  Created by 이명진 on 2/5/25.
//

import UIKit

extension UITextView {
    func setTextViewLineSpacing(lineSpacing: CGFloat) {
        guard let text = self.text else { return }
        let attributedStr = NSMutableAttributedString(string: text)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = lineSpacing
        attributedStr.addAttribute(.paragraphStyle, value: style, range: NSMakeRange(0, attributedStr.length))
        self.attributedText = attributedStr
    }
    
    func setTextViewCharacterSpacing(_ spacing: CGFloat) {
        guard let text = self.text else { return }
        let attributedStr = NSMutableAttributedString(string: text, attributes: [.kern: spacing])
        self.attributedText = attributedStr
    }
}
