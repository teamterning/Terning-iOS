//
//  CALayer+.swift
//  Terning-iOS
//
//  Created by 이명진 on 6/29/24.
//

import UIKit

/**
 
 - Description:
 
 View의 Layer 계층(CALayer)에 shadow를 간편하게 입힐 수 있는 메서드입니다.
 피그마에 나와있는 shadow 속성 값을 그대로 기입하면 됩니다!
 
 */

public extension CALayer {
    func applyShadow(
        color: UIColor = .black,
        alpha: Float = 0.05, // 피그마 디자인 시스템에 있는 기본 alpha 값 입니다.
        x: CGFloat = 0,
        y: CGFloat = 2,
        blur: CGFloat = 4, // 흐림 정도
        spread: CGFloat = 0) { // 그림자의 범위
            
            masksToBounds = false
            shadowColor = color.cgColor
            shadowOpacity = alpha
            shadowOffset = CGSize(width: x, height: y)
            shadowRadius = blur / 2
            if spread == 0 {
                shadowPath = nil
            } else {
                let dx = -spread
                let rect = bounds.insetBy(dx: dx, dy: dx)
                shadowPath = UIBezierPath(rect: rect).cgPath
            }
        }
}
