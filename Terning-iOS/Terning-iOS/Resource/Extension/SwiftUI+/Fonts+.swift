//
//  Fonts+.swift
//  Terning-iOS
//
//  Created by 이명진 on 12/2/24.
//

import SwiftUI

public extension Font {
  init(uiFont: UIFont) {
    self = Font(uiFont as CTFont)
  }
}

public extension Font {
    static let heading1 = Font(uiFont: UIFont.heading1)
    static let heading2 = Font(uiFont: UIFont.heading2)
    static let title1 = Font(uiFont: UIFont.title1)
    static let title2 = Font(uiFont: UIFont.title2)
    static let title3 = Font(uiFont: UIFont.title3)
    static let title4 = Font(uiFont: UIFont.title4)
    static let title5 = Font(uiFont: UIFont.title5)
    static let body0 = Font(uiFont: UIFont.body0)
    static let body1 = Font(uiFont: UIFont.body1)
    static let body2 = Font(uiFont: UIFont.body2)
    static let body3 = Font(uiFont: UIFont.body3)
    static let body4 = Font(uiFont: UIFont.body4)
    static let body5 = Font(uiFont: UIFont.body5)
    static let body6 = Font(uiFont: UIFont.body6)
    static let body7 = Font(uiFont: UIFont.body7)
    static let button0 = Font(uiFont: UIFont.button0)
    static let button1 = Font(uiFont: UIFont.button1)
    static let button2 = Font(uiFont: UIFont.button2)
    static let button3 = Font(uiFont: UIFont.button3)
    static let button4 = Font(uiFont: UIFont.button4)
    static let button5 = Font(uiFont: UIFont.button5)
    static let button6 = Font(uiFont: UIFont.button6)
    static let detail0 = Font(uiFont: UIFont.detail0)
    static let detail1 = Font(uiFont: UIFont.detail1)
    static let detail2 = Font(uiFont: UIFont.detail2)
    static let detail3 = Font(uiFont: UIFont.detail3)
    static let detail4 = Font(uiFont: UIFont.detail4)
    static let detail5 = Font(uiFont: UIFont.detail5)
    static let calendar = Font(uiFont: UIFont.calendar)
}
