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
            kakaoLoginButtonTapped: loginView.kakaoLoginButton.rx.tap.asObservable(),
            appleLoginButtonTapped: loginView.appleLoginButton.rx.tap.asObservable()
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
        let profileViewVC = UINavigationController(rootViewController: ProfileViewController(viewType: .setting, viewModel: ProfileViewModel()))
        
        guard let window = self.view.window else {
            print("Window is nil")
            return
        }
        ViewControllerUtils.setRootViewController(window: window, viewController: profileViewVC, withAnimation: true)
    }
}
