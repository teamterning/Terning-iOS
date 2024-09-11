//
//  ProfileViewController.swift
//  Terning-iOS
//
//  Created by 정민지 on 7/10/24.
//

import UIKit

import RxSwift

import SnapKit
import RxRelay

@frozen
enum ProfileViewType {
    case setting
    case fix
}

final class ProfileViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewType: ProfileViewType
    private let viewModel: ProfileViewModelType
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Components
    
    private lazy var rootView = ProfileView(viewType: viewType)
    
    private var userName: String = ""
    private let imageStringSubject: BehaviorSubject<String>
    private var authType: String = UserManager.shared.authType ?? ""
    
    private var imageString = "basic"
    
    // MARK: - Init
    
    init(viewType: ProfileViewType, viewModel: ProfileViewModelType) {
        self.viewType = viewType
        self.viewModel = viewModel
        self.imageStringSubject = BehaviorSubject<String>(value: viewModel.userInfo?.profileImage ?? "basic")

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setLayout()
        bindViewModel()
        setDelegate()
    }
}

// MARK: - UI & Layout

extension ProfileViewController {
    private func setUI() {
        view.backgroundColor = .white
        view.addSubview(rootView)
    }
    
    private func setLayout() {
        rootView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
}

// MARK: - Methods

extension ProfileViewController {
    private func setDelegate() {
        rootView.nameTextField.delegate = self
        rootView.setAddTarget(target: self, action: #selector(profileAddButtonTapped))
        
        self.hideKeyboardWhenTappedAround()
        
        rootView.navigationBar.leftButtonAction = { [weak self] in
            guard let self = self else { return }
            self.popOrDismissViewController(animated: true)
        }
    }
    
    private func pushToWelcome() {
        let welcomeViewController = WelcomeViewController(viewType: .first)
        OnboardingData.shared.userName = self.userName
        self.navigationController?.pushViewController(welcomeViewController, animated: true)
    }
}

// MARK: - Bind

extension ProfileViewController {
    private func bindViewModel() {
        let input = ProfileViewModelInput(
            userInfo: Observable.just(viewModel.userInfo ?? UserProfileInfoModel(name: "", profileImage: "basic", authType: "")),
            name: rootView.nameTextField.rx.text.orEmpty.asObservable(), 
            imageStringSubject: imageStringSubject.asObservable(),
            saveButtonTap: rootView.saveButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input, disposeBag: disposeBag)
        
        output.userInfo
            .drive(onNext: { [weak self] userInfo in
                self?.rootView.bind(userInfo: userInfo)
            })
            .disposed(by: disposeBag)
        
        output.nameCountText
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: rootView.nameCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.nameValidationMessage
            .subscribe(onNext: { [weak self] message in
                self?.rootView.updateValidationUI(message: message)
            })
            .disposed(by: disposeBag)
        
        output.text
            .subscribe(onNext: { [weak self] text in
                self?.userName = text
            })
            .disposed(by: disposeBag)
        
        output.isSaveButtonEnabled
            .subscribe(onNext: { [weak self] isEnabled in
                self?.rootView.saveButton.setEnabled(isEnabled)
            })
            .disposed(by: disposeBag)
        
        output.saveAlert
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                
                switch self.viewType {
                case .fix:
                    self.navigationController?.popViewController(animated: true)
                case .setting:
                    self.pushToWelcome()
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - UITextFieldDelegate

extension ProfileViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text else { return true }
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        if !viewModel.validateInput(newText: newText) {
            return false
        }
        
        viewModel.nameRelay.accept(newText)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - @objc func

extension ProfileViewController {
    @objc
    private func profileAddButtonTapped() {
        guard let currentImageString = try? imageStringSubject.value() else {
            return }
        
        let contentVC = ProfileImageViewController(viewModel: ProfileImageViewModel(), initialSelectedImageString: currentImageString)
        
        contentVC.onImageSelected = { [weak self] selectedImageIndex in
            let selectedImageString = ProfileImageUtils.stringForProfile(index: selectedImageIndex)
            self?.rootView.updateProfileImage(imageString: selectedImageString)
            self?.imageStringSubject.onNext(selectedImageString)
            self?.viewModel.imageStringRelay.accept(selectedImageString)
        }
        
        presentCustomBottomSheet(contentVC, heightFraction: 320)
    }
}

// MARK: - UIAdaptivePresentationControllerDelegate

extension ProfileViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        removeModalBackgroundView()
    }
}
