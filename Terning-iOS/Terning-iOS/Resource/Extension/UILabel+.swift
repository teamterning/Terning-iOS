//
//  UILabel+.swift
//  Terning-iOS
//
//  Created by 이명진 on 7/5/24.
//

import UIKit

extension UILabel {
    
    /// - ## 행간 조정 메서드
    ///
    ///   적용 되어 있는 Label 의 행간이 130% 라면 1.3 라고 넣으면 됩니다.  음수 값은 지정할 수 없습니다.
    func setLineSpacing(lineSpacing: CGFloat) {
        if let text = self.text {
            let attributedStr = NSMutableAttributedString(string: text)
            let style = NSMutableParagraphStyle()
            style.lineSpacing = lineSpacing
            attributedStr.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSMakeRange(0, attributedStr.length))
            self.attributedText = attributedStr
        }
    }
    
    /// - ## 행간 조정 메서드2
    ///
    ///   setLineSpacing 함수와 동일 하지만 메서드 체이닝 방식으로 설정 해야 합니다.
    ///
    func setLineSpacingWithChaining(lineSpacing: CGFloat) -> UILabel {
        let label = self
        if let text = self.text {
            let style = NSMutableParagraphStyle()
            style.lineSpacing = lineSpacing
            let attributes: [NSAttributedString.Key: Any] = [
                .paragraphStyle: style
            ]
            label.attributedText = NSAttributedString(string: text, attributes: attributes)
        }
        return label
    }
    
    /// - ## 자간 설정 메서드
    ///
    ///  적용 되어 있는 Label 의 자간이 -0.5% 라고 되어있으면
    func setCharacterSpacing(_ spacing: CGFloat) {
        let attributedStr = NSMutableAttributedString(string: self.text ?? "")
        attributedStr.addAttribute(NSAttributedString.Key.kern, value: spacing, range: NSMakeRange(0, attributedStr.length))
        self.attributedText = attributedStr
    }
    
    /// - ## 자간과 행간을 모두 조정하는 메서드
    func setLineAndCharacterSpacing(lineSpacing: CGFloat, characterSpacing: CGFloat) {
        if let text = self.text {
            let attributedStr = NSMutableAttributedString(string: text)
            let style = NSMutableParagraphStyle()
            style.lineSpacing = lineSpacing
            attributedStr.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSMakeRange(0, attributedStr.length))
            attributedStr.addAttribute(NSAttributedString.Key.kern, value: characterSpacing, range: NSMakeRange(0, attributedStr.length))
            self.attributedText = attributedStr
        }
    }
    
    /// - ## 라벨 일부 font 변경해주는 함수
    /// targerString에는 바꾸고자 하는 특정 문자열을 넣어주세요
    ///
    /// font에는 targetString에 적용하고자 하는 UIFont를 넣어주세요
    func partFontChange(targetString: String, font: UIFont) {
        let fullText = self.text ?? ""
        let range = (fullText as NSString).range(of: targetString)
        let attributedString = NSMutableAttributedString(string: fullText)
        attributedString.addAttribute(.font, value: font, range: range)
        self.attributedText = attributedString
    }
    
    /// - ## 라벨 일부 textColor 변경해주는 함수
    /// targetString에는 바꾸고자 하는 특정 문자열을 넣어주세요
    ///
    /// textColor에는 targetString에 적용하고자 하는 특정 UIColor에 넣어주세요
    func partColorChange(targetString: String, textColor: UIColor) {
        let fullText = self.text ?? ""
        let range = (fullText as NSString).range(of: targetString)
        let attributedString = NSMutableAttributedString(string: fullText)
        attributedString.addAttribute(.foregroundColor, value: textColor, range: range)
        self.attributedText = attributedString
    }
    
    // 일부 텍스트의 컬러와 폰트를 조정하는 메서드
    func setAttributedText(targetFontList: [String: UIFont],
                           targetColorList: [String: UIColor]) {
        let fullText = self.text ?? ""
        let attributedString = NSMutableAttributedString(string: fullText)
        for dic in targetFontList {
            let range = (fullText as NSString).range(of: dic.key)
            attributedString.addAttribute(.font, value: dic.value, range: range)
        }
        
        for dic in targetColorList {
            let range = (fullText as NSString).range(of: dic.key)
            attributedString.addAttribute(.foregroundColor, value: dic.value, range: range)
        }
        self.attributedText = attributedString
    }
    
    /// 텍스트와 자간 값을 설정하는 메서드
    ///
    /// - Parameters:
    ///   - text: 설정할 텍스트
    ///   - spacing: 자간 값 (기본 값은 -0.005)
    func setText(_ text: String, characterSpacing spacing: CGFloat = 0.002) {
        self.text = text
        self.setCharacterSpacing(spacing)
    }
}
