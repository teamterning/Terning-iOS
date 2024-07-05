//
//  ViewController+.swift
//  Terning-iOS
//
//  Created by 이명진 on 7/5/24.
//

import UIKit
    
extension UIViewController {
    convenience init(backgroundColor: UIColor) {
        self.init()
        self.view.backgroundColor = backgroundColor
    }
}

