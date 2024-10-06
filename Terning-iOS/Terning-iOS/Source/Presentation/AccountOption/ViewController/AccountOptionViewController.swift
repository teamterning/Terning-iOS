//
//  AccountOptionViewController.swift
//  Terning-iOS
//
//  Created by 정민지 on 9/4/24.
//

import UIKit

import RxSwift
import RxCocoa

@frozen
public enum AccountOption {
    case logout
    case withdraw
}

final class AccountOptionViewController: UIViewController {
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private let viewModel: AccountOptionViewModelType
    private let rootView = AccountOptionView()
    
    // MARK: - Init
    
    init(viewModel: AccountOptionViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        bindViewType()
        bindViewModel()
    }
}

// MARK: - UI & Layout

extension AccountOptionViewController {
    private func setUI() {
        view.backgroundColor = .white
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius = 30
        view.layer.masksToBounds = true
    }
}

// MARK: - Bind

extension AccountOptionViewController {
    private func bindViewType() {
        rootView.bind(for: viewModel.accountOption)
    }
    
    private func bindViewModel() {
        let input = AccountOptionViewModelInput(
            yesButtonTap: rootView.yesButton.rx.tap.asObservable(),
            noButtonTap: rootView.noButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input, disposeBag: disposeBag)
        
        output.showSplashScreen
            .drive(onNext: { [weak self] in
                if self?.viewModel.accountOption == .logout {
                    self?.navigateToLoginVC()
                } else {
                    self?.navigateToSplashVC()
                }
            })
            .disposed(by: disposeBag)
        
        output.dismissModal
            .drive(onNext: { [weak self] in
                self?.presentingViewController?.removeModalBackgroundView()
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Methods

extension AccountOptionViewController {
    private func navigateToLoginVC() {
        let LoginVC = LoginViewController(
            viewModel: LoginViewModel(
                loginRepository: LoginRepository(
                    loginService: LoginService()
                )
            )
        )
        guard let window = self.view.window else {
            print("Window is nil")
            return
        }
        ViewControllerUtils.setRootViewController(window: window, viewController: LoginVC, withAnimation: true)
    }
    private func navigateToSplashVC() {
        let splashVC = UINavigationController(rootViewController: SplashVC())
        guard let window = self.view.window else {
            print("Window is nil")
            return
        }
        ViewControllerUtils.setRootViewController(window: window, viewController: splashVC, withAnimation: true)
    }
}
