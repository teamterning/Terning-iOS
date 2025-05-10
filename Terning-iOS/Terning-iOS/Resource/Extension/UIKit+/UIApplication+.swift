//
//  UIApplication+.swift
//  Terning-iOS
//
//  Created by 이명진 on 5/10/25.
//

import UIKit

extension UIApplication {
    /// 현재 포그라운드에 있는 Scene의 최상단 window 를 반환합니다.
    var currentKeyWindow: UIWindow? {
        return self.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first(where: { $0.activationState == .foregroundActive })?
            .windows
            .first(where: { $0.isKeyWindow })
    }
    
    /// 현재 화면에서 가장 위에 표시되고 있는 ViewController를 반환합니다.
    var topMostViewController: UIViewController? {
        return self.currentKeyWindow?.rootViewController?.topMostViewController()
    }
}
