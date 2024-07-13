//
//  PassThroughView.swift
//  Terning-iOS
//
//  Created by 김민성 on 7/14/24.
//

import UIKit

class PassThroughView: UIView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        
        return hitView == self ? nil : hitView
    }
}
