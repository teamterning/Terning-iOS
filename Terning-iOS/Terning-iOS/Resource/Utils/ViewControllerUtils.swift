//
//  ViewControllerUtils.swift
//  Terning-iOS
//
//  Created by 이명진 on 7/14/24.
//

import UIKit

/**
 
 - Description:
 
 RootViewController를 만들어주는 유틸입니다. SnapShot을 찍어서 전환합니다.
 
 */

struct ViewControllerUtils {
    static func setRootViewController(window: UIWindow, viewController: UIViewController, withAnimation: Bool) {
        if !withAnimation {
            window.rootViewController = viewController
            window.makeKeyAndVisible()
            return
        }
        
        if let snapshot = window.snapshotView(afterScreenUpdates: true) {
            viewController.view.addSubview(snapshot)
            window.rootViewController = viewController
            window.makeKeyAndVisible()
            
            UIView.animate(withDuration: 0.4, animations: {
                snapshot.layer.opacity = 0
            }, completion: { _ in
                snapshot.removeFromSuperview()
            })
        }
    }
}
