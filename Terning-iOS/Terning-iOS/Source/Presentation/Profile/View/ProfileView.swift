//
//  ProfileView.swift
//  Terning-iOS
//
//  Created by 정민지 on 7/10/24.
//

import UIKit

import SnapKit
import Then

final class ProfileView: UIView {
    
    // MARK: - Properties
    
    private let viewType: ProfileViewType
    
    // MARK: - UI Components
    
    private let welcomeLabel = LabelFactory.build(
        text: "반가워요!\n이름을 알려주세요",
        font: .heading2,
        textAlignment: .left
    ).then {
        $0.numberOfLines = 0
    }
    
    private let profileImageLabel = LabelFactory.build(
        text: "프로필 이미지",
        font: .body2,
        textColor: .grey500,
        lineSpacing: 1.2,
        characterSpacing: 0.002
    )
    
    let profileImageView = UIImageView().then {
        $0.image = .profile0
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = 40
        $0.clipsToBounds = true
        $0.backgroundColor = .grey300
        $0.isUserInteractionEnabled = true
    }
    
    private let profileImageAddButton = UIButton().then {
        $0.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        $0.tintColor = .grey400
        $0.layer.cornerRadius = 14
        $0.clipsToBounds = true
    }
    
    private let nameLabel = LabelFactory.build(
        text: "이름",
        font: .body2,
        textColor: .grey500,
        lineSpacing: 1.2,
        characterSpacing: 0.002
    )
    
    private let nameTextField = UITextField().then {
        $0.borderStyle = .none
        $0.textColor = .terningBlack
        $0.font = .detail0
        $0.attributedPlaceholder = NSAttributedString(
            string: "이름을 입력해주세요",
            attributes: [
                .foregroundColor: UIColor.grey300,
                .font: UIFont.detail1
            ]
        )
    }
    
    private let underLineView = UIView().then {
        $0.backgroundColor = .grey500
    }
    
    private let nameCountLabel = LabelFactory.build(
        text: "0/12",
        font: .button3,
        textColor: .grey400,
        lineSpacing: 1.2,
        characterSpacing: 0.002
    )
    
    private let nameValidationIconImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.isHidden = true
    }
    
    private let nameValidationLabel = LabelFactory.build(
        text: "12자리 이내, 문자/숫자 가능, 특수문자/기호 입력불가",
        font: .detail3,
        textColor: .grey400,
        textAlignment: .left,
        lineSpacing: 1.2,
        characterSpacing: 0.002
    )
    
    private let snsAccountLabel = LabelFactory.build(
        text: "연동 계정",
        font: .body5,
        textColor: .grey500,
        lineSpacing: 1.2,
        characterSpacing: 0.002
    )
    
    private let snsTypeLabel = LabelFactory.build(
        text: "Apple 로그인",
        font: .detail0,
        textColor: .terningBlack,
        lineSpacing: 1.0,
        characterSpacing: 0.002
    )
    
    let saveButton = CustomButton(title: "저장하기")
    
    // MARK: - Init
    
    init(viewType: ProfileViewType) {
        
        self.viewType = viewType
        
        super.init(frame: .zero)
        
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension ProfileView {
    private func setUI() {
        addSubviews(
            profileImageView,
            profileImageAddButton,
            nameLabel,
            nameTextField,
            nameCountLabel,
            underLineView,
            nameValidationIconImageView,
            nameValidationLabel,
            saveButton
        )
        
        if viewType == .setting {
            addSubviews(
                welcomeLabel,
                profileImageLabel
            )
        } else {
            addSubviews(
                snsAccountLabel,
                snsTypeLabel
            )
        }
    }
    
    private func setLayout() {
        profileImageAddButton.snp.makeConstraints {
            $0.width.height.equalTo(28)
            $0.trailing.equalTo(profileImageView.snp.trailing).offset(3)
            $0.bottom.equalTo(profileImageView.snp.bottom).offset(2)
        }
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(52)
            $0.leading.equalToSuperview().inset(24)
        }
        nameTextField.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(25)
            $0.leading.equalToSuperview().inset(24)
            $0.trailing.equalTo(nameCountLabel.snp.leading).offset(-5)
        }
        nameCountLabel.snp.makeConstraints {
            $0.centerY.equalTo(nameTextField.snp.centerY)
            $0.trailing.equalToSuperview().inset(38)
        }
        underLineView.snp.makeConstraints {
            $0.top.equalTo(nameTextField.snp.bottom).offset(7)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(1)
        }
        nameValidationIconImageView.snp.makeConstraints {
            $0.top.equalTo(underLineView.snp.bottom).offset(6)
            $0.leading.equalToSuperview().inset(24)
            $0.width.height.equalTo(12)
        }
        nameValidationLabel.snp.makeConstraints {
            $0.top.equalTo(underLineView.snp.bottom).offset(5)
            $0.leading.equalTo(nameValidationIconImageView.snp.trailing).offset(4)
            $0.trailing.equalToSuperview().inset(24)
        }
        saveButton.snp.makeConstraints {
            $0.height.equalTo(54)
            $0.horizontalEdges.equalToSuperview().inset(-5)
            $0.bottom.equalToSuperview().inset(44)
        }
        
        if viewType == .setting {
            welcomeLabel.snp.makeConstraints {
                $0.top.equalToSuperview().inset(70)
                $0.leading.equalToSuperview().inset(24)
            }
            profileImageLabel.snp.makeConstraints {
                $0.top.equalTo(welcomeLabel.snp.bottom).offset(46)
                $0.leading.equalToSuperview().inset(24)
            }
            profileImageView.snp.makeConstraints {
                $0.top.equalTo(profileImageLabel.snp.bottom).offset(15)
                $0.centerX.equalToSuperview()
                $0.width.height.equalTo(80)
            }
        } else {
            profileImageView.snp.makeConstraints {
                $0.top.equalToSuperview().inset(44)
                $0.centerX.equalToSuperview()
                $0.width.height.equalTo(80)
            }
            snsAccountLabel.snp.makeConstraints {
                $0.top.equalTo(nameValidationLabel.snp.bottom).offset(36)
                $0.leading.equalToSuperview().inset(24)
            }
            snsTypeLabel.snp.makeConstraints {
                $0.top.equalTo(snsAccountLabel.snp.bottom).offset(10)
                $0.leading.equalToSuperview().inset(24)
            }
        }
    }
}

// MARK: - Methods

extension ProfileView {
    func bind(index: Int) {
        let profileImages: [UIImage] = [
            .profile0,
            .profile1,
            .profile2,
            .profile3,
            .profile4,
            .profile5
        ]
        
        profileImageView.image = profileImages[index]
    }
    
    func updateValidationUI(message: ValidationMessage) {
        nameValidationLabel.text = message.rawValue
        nameValidationLabel.textColor = message.textColor
        underLineView.backgroundColor = message.underlineColor
        nameValidationIconImageView.image = message.iconImage
        nameValidationIconImageView.tintColor = message.iconTintColor
        nameValidationIconImageView.isHidden = message == .defaultMessage
        
        updateValidationLabelConstraints()
        layoutIfNeeded()
    }
    
    private func updateValidationLabelConstraints() {
        nameValidationLabel.snp.removeConstraints()
        if nameValidationIconImageView.isHidden {
            nameValidationLabel.snp.makeConstraints {
                $0.top.equalTo(underLineView.snp.bottom).offset(5)
                $0.horizontalEdges.equalToSuperview().inset(24)
            }
        } else {
            nameValidationLabel.snp.makeConstraints {
                $0.top.equalTo(underLineView.snp.bottom).offset(5)
                $0.leading.equalTo(nameValidationIconImageView.snp.trailing).offset(4)
                $0.trailing.equalToSuperview().inset(24)
            }
        }
    }
}

// MARK: - Public Methods

extension ProfileView {
    public func setAddTarget(target: Any, action: Selector) {
        profileImageAddButton.addTarget(target, action: action, for: .touchUpInside)
        let tapGestureRecognizer = UITapGestureRecognizer(target: target, action: action)
        profileImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    public func getNameTextField() -> UITextField {
        return nameTextField
    }
    
    public func getSaveButton() -> CustomButton {
        return saveButton
    }
    
    public func getNameCountLabel() -> UILabel {
        return nameCountLabel
    }
    
    public func getSnsTypeLabel() -> UILabel {
        return snsTypeLabel
    }
}
