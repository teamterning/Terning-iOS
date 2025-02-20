//
//  SplashViewController.swift
//  Terning-iOS
//
//  Created by 이명진 on 7/18/24.
//

import UIKit

import SnapKit
import Then

final class SplashVC: UIViewController {
    
    // MARK: - UI Components
    
    private let backgroundImageView = UIImageView().then {
        $0.image = .imgSplash
        $0.contentMode = .scaleAspectFill
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUI()
        self.setNavigationBar()
        self.setLayout()
        self.checkDidSignIn()
    }
}

// MARK: - Methods

extension SplashVC {
    private func checkDidSignIn() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if UserManager.shared.hasAccessToken {
                UserManager.shared.getNewToken { [weak self] result in
                    print("❤️❤️ 자동 로그인 시도 중 ❤️❤️")
                    switch result {
                    case .success:
                        print("SplashVC-토큰 재발급 성공")
                        self?.pushToTabBarController()
                    case .failure(let error):
                        print("토큰 재발급 실패: \(error.localizedDescription)")
                        self?.pushToSignInView()
                    }
                }
            } else {
                print("토큰 없음, 로그인 페이지로 이동")
                self.pushToSignInView()
            }
        }
    }
    
    private func pushToSignInView() {
        let signInVC = LoginViewController(
            viewModel: LoginViewModel(
                loginRepository: LoginRepository(
                    loginService: LoginService()
                )
            )
        )
        self.navigationController?.pushViewController(signInVC, animated: true)
    }
    
    private func pushToTabBarController() {
        let tabBarController = TNTabBarController()
        guard let window = self.view.window else { return }
        ViewControllerUtils.setRootViewController(window: window, viewController: tabBarController, withAnimation: true)
    }
}

// MARK: - UI & Layout

extension SplashVC {
    private func setUI() {
        view.backgroundColor = .clear
    }
    
    private func setNavigationBar() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    private func setLayout() {
        view.addSubviews(backgroundImageView)
        
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
