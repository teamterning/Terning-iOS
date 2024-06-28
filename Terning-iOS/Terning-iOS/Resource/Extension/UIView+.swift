//
//  UIView+.swift
//  Terning-iOS
//
//  Created by 이명진 on 6/20/24.
//

import UIKit

extension UIView {
    
    /// UIView 여러 개 인자로 받아서 한 번에 addSubview 합니다.
    func addSubviews(_ views: UIView...) {
        views.forEach { self.addSubview($0) }
    }
    
}
