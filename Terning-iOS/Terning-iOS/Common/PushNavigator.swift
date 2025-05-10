//
//  PushNavigator.swift
//  Terning-iOS
//
//  Created by 이명진 on 4/25/25.
//

import UIKit

final class PushNavigator: NSObject {
    
    // MARK: - PushDestinationType
    
    enum PushDestinationType: String {
        case HOME, CALENDAR, SEARCH
        
        var tabIndex: Int {
            switch self {
            case .HOME:
                return 0
            case .CALENDAR:
                return 1
            case .SEARCH:
                return 2
            }
        }
    }
    
    // MARK: - Properties
    
    private static var pendingDestination: PushDestinationType?
    
    
    // MARK: - static Methods
    
    /// 푸시 클릭시 호출: 목적지를 저장하고 바로 적용 시도
    static func handlePush(type: String) {
        guard let destination = PushDestinationType(rawValue: type) else {
            print("❌ 유효하지 않은 type: \(type)")
            return
        }
        
        guard UserManager.shared.hasAccessToken else {
            print("🚫 로그인 필요 !! - 푸시 무시")
            return
        }
        
        print("📦 PushDestination 저장됨: \(destination)")
        
        // 토큰 갱신 성공해야만 진행
        UserManager.shared.getNewToken { result in
            switch result {
            case .success:
                pendingDestination = destination
                applyPendingPushIfNeeded()
            case .failure:
                print("❗️ 토큰 만료 - 로그인 화면 이동 ❗️")
                moveToLogin()
            }
        }
    }
    
    /// TabBarController가 있을 때 적용
    static func applyPendingPushIfNeeded() {
        guard let destination = pendingDestination else {
            print("❗️ 적용할 pending push 없음 ❗️")
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            guard let window = UIApplication.shared.currentKeyWindow,
                  let tabBar = window.rootViewController as? TNTabBarController
            else {
                print("❌ TabBarController 없음 - push 미적용")
                return
            }
            
            print("🚀 TabBarController 있음, 푸시 적용 - 이동할 탭: \(destination) 🚀")
            tabBar.selectedIndex = destination.tabIndex
            pendingDestination = nil
        }
    }
    
    /// 로그인 이동
    private static func moveToLogin() {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.currentKeyWindow else { return }
            
            let loginVC = LoginViewController(
                viewModel: LoginViewModel(
                    loginRepository: LoginRepository(
                        loginService: LoginService()
                    )
                )
            )
            ViewControllerUtils.setRootViewController(window: window, viewController: loginVC, withAnimation: true)
        }
    }
}
