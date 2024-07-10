//
//  ProfileViewController.swift
//  Terning-iOS
//
//  Created by 정민지 on 7/10/24.
//

import UIKit
import SnapKit
import RxSwift

@frozen
enum ProfileViewType {
    case setting
    case fix
}

final class ProfileViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewType: ProfileViewType
    private let viewModel: ProfileViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Components
    
    private lazy var profileView = ProfileView(viewType: viewType)
    
    // MARK: - Init
    
    init(viewType: ProfileViewType, viewModel: ProfileViewModel) {
        
        self.viewType = viewType
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setUI()
        setLayout()
        bindViewModel()
        setDelegate()
    }
}
    
// MARK: - UI & Layout
extension ProfileViewController {
    private func setUI() {
        view.addSubview(profileView)
    }
    
    private func setLayout() {
        profileView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - Methods

extension ProfileViewController {
    private func setDelegate() {
        profileView.getNameTextField().delegate = self
        profileView.setAddTarget(target: self, action: #selector(profileAddButtonTapped))
    }
}
    
// MARK: - Bind

extension ProfileViewController {
    private func bindViewModel() {
        let input = ProfileViewModel.Input(name: profileView.getNameTextField().rx.text.orEmpty.asObservable())
        let output = viewModel.transform(input: input)
        
        output.nameCountText
            .bind(to: profileView.getNameCountLabel().rx.text)
            .disposed(by: disposeBag)
        
        output.isNameValid
            .subscribe(onNext: { [weak self] isValid in
                self?.profileView.getSaveButton().isEnabled = isValid
                self?.profileView.getSaveButton().backgroundColor = isValid ? .terningMain : .grey200
            })
            .disposed(by: disposeBag)
        
        output.nameValidationMessage
            .subscribe(onNext: { [weak self] message in
                self?.profileView.updateValidationUI(message: message)
            })
            .disposed(by: disposeBag)
    }
}


// MARK: - UITextFieldDelegate
extension ProfileViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text else { return true }
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        if !viewModel.validateInput(newText: newText) {
            return false
        }
        
        viewModel.nameRelay.accept(newText)
        return true
    }
}

// MARK: - @objc func

extension ProfileViewController {
    @objc
    private func profileAddButtonTapped() {
        // TODO: 커스텀 모달 화면으로 이동
    }
}
