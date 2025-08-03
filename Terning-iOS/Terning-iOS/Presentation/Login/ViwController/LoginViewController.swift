//
//  ViewController.swift
//  Terning-iOS
//
//  Created by 정민지 on 7/13/24.
//

import UIKit

import RxSwift
import RxCocoa

import SnapKit

import KakaoSDKAuth
import KakaoSDKUser

final class LoginViewController: UIViewController {
    
    // MARK: - UI Components
    
    private let loginView = LoginView()
    private let viewModel: LoginViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    
    init(viewModel: LoginViewModel) {
        
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setUI()
        setLayout()
        bindViewModel()
        observeRateLimit()
    }
}

// MARK: - UI & Layout

extension LoginViewController {
    private func setUI() {
        view.addSubview(loginView)
    }
    
    private func setLayout() {
        loginView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - Bind

extension LoginViewController {
    private func bindViewModel() {
        let input = LoginViewModel.Input(
            kakaoLoginDidTap: loginView.kakaoLoginButton.rx.tap.asObservable(),
            appleLoginDidTap: loginView.appleLoginButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input, disposeBag: disposeBag)
        
        output.loginSuccess
            .drive(onNext: { [weak self] success in
                print(success)
                if success {
                    self?.navigateToNextScreen()
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Methods

extension LoginViewController {
    private func navigateToNextScreen() {
        if let userId = UserManager.shared.userId, !String(userId).isEmpty {
            print("🏠 홈 화면으로 이동")
            let tabBarController = TNTabBarController()
            guard let window = self.view.window else {
                return
            }
            
            ViewControllerUtils.setRootViewController(window: window, viewController: tabBarController, withAnimation: true)
        } else {
            print("🤦 프로필 설정 화면으로 이동")
            let profileViewVC = UINavigationController(rootViewController: ProfileViewController(viewType: .setting, viewModel: ProfileViewModel()))// 온보딩 화면으로 이동
            guard let window = self.view.window else {
                return
            }
            
            ViewControllerUtils.setRootViewController(window: window, viewController: profileViewVC, withAnimation: true)
        }
    }
    
    private func observeRateLimit() {
        NotificationCenter.default.addObserver(
            forName: .didReceiveRateLimit,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.loginView.kakaoLoginButton.isEnabled = false
            self?.loginView.appleLoginButton.isEnabled = false

            self?.showToast(message: "요청이 너무 많습니다. 잠시 후 다시 시도해 주세요.")

            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                self?.loginView.kakaoLoginButton.isEnabled = true
                self?.loginView.appleLoginButton.isEnabled = true
            }
        }
    }
}
