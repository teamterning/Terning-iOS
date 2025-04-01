//
//  SceneDelegate.swift
//  Terning-iOS
//
//  Created by 이명진 on 6/19/24.
//

import UIKit
import KakaoSDKAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    private var pendingDeeplinkURL: URL?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        let vc = UINavigationController(rootViewController: SplashVC())
        //        let vc = TNTabBarController()
        window.rootViewController = vc
        self.window = window
        window.makeKeyAndVisible()
        
        if let url = connectionOptions.urlContexts.first?.url {
            self.pendingDeeplinkURL = url
        }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.handleOpenUrl(url: url)
            } else {
                handleDeeplink(url)
            }
        }
    }
    
    func processPendingDeeplinkIfNeeded() {
        if let url = pendingDeeplinkURL {
            handleDeeplink(url)
            pendingDeeplinkURL = nil
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let url = self.pendingDeeplinkURL {
                self.handleDeeplink(url)
                self.pendingDeeplinkURL = nil
            }
        }
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}

// MARK: - Methods

extension SceneDelegate {
    private func handleDeeplink(_ url: URL) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let action = components.queryItems?.first(where: { $0.name == "action" })?.value,
              let id = components.queryItems?.first(where: { $0.name == "id" })?.value,
              action == "jobDetail" else {
            return
        }
        
        if UserManager.shared.hasAccessToken {
            routeToJobDetail(jobId: id)
        } else {
            pendingDeeplinkURL = url
            
            guard let window = self.window else { return }
            
            let loginViewController = LoginViewController(
                viewModel: LoginViewModel(
                    loginRepository: LoginRepository(
                        loginService: LoginService()
                    )
                )
            )
            
            ViewControllerUtils.setRootViewController(window: window, viewController: loginViewController, withAnimation: true)
        }
    }
    
    private func routeToJobDetail(jobId: String) {
        guard let tabBar = window?.rootViewController as? TNTabBarController else { return }
        
        tabBar.selectedIndex = 0
        
        guard let nav = tabBar.viewControllers?.first as? UINavigationController else { return }
        
        if let topVC = nav.topViewController as? JobDetailViewController {
            let currentId = topVC.internshipAnnouncementId.value
            if "\(currentId)" == jobId { return } else {
                nav.popViewController(animated: false)
            }
        }
        
        let jobDetailVC = JobDetailViewController(
            viewModel: JobDetailViewModel(
                scrapUseCase: ScrapUseCase(
                    repository: ScrapRepository(
                        service: ScrapsService(
                            provider: Providers.scrapsProvider
                        )
                    )
                )
            )
        )
        
        jobDetailVC.hidesBottomBarWhenPushed = true
        jobDetailVC.internshipAnnouncementId.accept(Int(jobId) ?? 0)
        
        nav.pushViewController(jobDetailVC, animated: true)
    }
}
