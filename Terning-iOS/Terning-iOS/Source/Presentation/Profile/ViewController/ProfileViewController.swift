//
//  ProfileViewController.swift
//  Terning-iOS
//
//  Created by 정민지 on 7/10/24.
//

import UIKit

import RxSwift

import SnapKit

@frozen
enum ProfileViewType {
    case setting
    case fix
}

final class ProfileViewController: UIViewController {
    
    // MARK: - Properties
    private let authProvider = Providers.authProvider
    private let viewType: ProfileViewType
    private let viewModel: ProfileViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Components
    private lazy var profileView = ProfileView(viewType: viewType)
    
    private var userName: String = ""
    private var imageIndex: Int = 0
    private var authType: String = UserManager.shared.authType ?? ""
    
    // MARK: - Init
    init(viewType: ProfileViewType, viewModel: ProfileViewModel) {
        self.viewType = viewType
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
        setDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        profileView.bind(index: imageIndex)
    }
}

// MARK: - UI & Layout
extension ProfileViewController {
    private func setUI() {
        view.addSubview(profileView)
    }
    
    private func setLayout() {
        profileView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
}

// MARK: - Public Methods
extension ProfileViewController {
    public func setUserData(userName: String, snsType: String) {
        profileView.getNameTextField().text = userName
        if snsType == "APPLE" {
            profileView.getSnsTypeLabel().text = "Apple 로그인"
        } else if snsType == "KAKAO" {
            profileView.getSnsTypeLabel().text = "Kakao 로그인"
        } else {
            profileView.getSnsTypeLabel().text = "정보 없음"
        }
    }
}

// MARK: - Methods
extension ProfileViewController {
    private func setDelegate() {
        profileView.getNameTextField().delegate = self
        profileView.setAddTarget(target: self, action: #selector(profileAddButtonTapped))
        profileView.saveButton.addTarget(self, action: #selector(saveButtonDidTap), for: .touchUpInside)
        
        self.hideKeyboardWhenTappedAround()
    }
}

// MARK: - Bind
extension ProfileViewController {
    private func bindViewModel() {
        let input = ProfileViewModel.Input(
            name: profileView.getNameTextField().rx.text.orEmpty.asObservable()
        )
        let output = viewModel.transform(input: input, disposeBag: disposeBag)
        
        output.nameCountText
            .bind(to: profileView.getNameCountLabel().rx.text)
            .disposed(by: disposeBag)
        
        output.isNameValid
            .subscribe(onNext: { [weak self] isValid in
                self?.profileView.getSaveButton().setEnabled(isValid)
            })
            .disposed(by: disposeBag)
        
        output.nameValidationMessage
            .subscribe(onNext: { [weak self] message in
                self?.profileView.updateValidationUI(message: message)
            })
            .disposed(by: disposeBag)
        
        output.text
            .subscribe(onNext: { [weak self] text in
                self?.userName = text
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
        let contentViewController = ProfileImageViewController(viewModel: ProfileImageViewModel(), initialSelectedIndex: imageIndex)
        
        contentViewController.selectedIndex
            .subscribe(onNext: { [weak self] index in
                self?.imageIndex = index
            })
            .disposed(by: disposeBag)
        
        contentViewController.profileImageView.saveButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.profileView.bind(index: self?.imageIndex ?? 0)
            })
            .disposed(by: disposeBag)
        
        let bottomSheetVC = CustomBottomSheetViewController(
            bottomType: .low,
            contentViewController: contentViewController,
            upScroll: false
        )
        
        bottomSheetVC.modalPresentationStyle = .overFullScreen
        self.present(bottomSheetVC, animated: false)
    }
    
    @objc
    private func saveButtonDidTap() {
        self.signUp(
            name: userName,
            profileImage: imageIndex,
            authType: authType
        )
        self.pushToWelcome()
    }
}

// MARK: - Network Calls
extension ProfileViewController {
    private func signUp(name: String, profileImage: Int, authType: String) {
        LoadingIndicator.showLoading()
        
        authProvider.request(.signUp(name: name, profileImage: profileImage, authType: authType)) { result in
            LoadingIndicator.hideLoading()
            
            switch result {
            case .success(let result):
                let status = result.statusCode
                if 200..<300 ~= status {
                    do {
                        let responseDto = try result.map(BaseResponse<SignInResponseModel>.self)
                        guard let model = responseDto.result else { return }
                        
                        if responseDto.status == 201 {
                            UserManager.shared.accessToken = model.accessToken
                            UserManager.shared.refreshToken = model.refreshToken
                            UserManager.shared.userId = model.userId
                            UserManager.shared.authType = model.authType
                        } else {
                            self.showToast(message: "status 가 201이 아님")
                        }
                    } catch {
                        self.showToast(message: "에러 발생")
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
                self.showToast(message: "사용자 등록 에러")
            }
        }
    }
    
    private func pushToWelcome() {
        let welcomeViewController = WelcomeViewController(viewType: .first)
        self.navigationController?.pushViewController(welcomeViewController, animated: true)
    }
}
