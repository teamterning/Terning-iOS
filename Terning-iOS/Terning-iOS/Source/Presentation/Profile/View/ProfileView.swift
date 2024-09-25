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
    
    let navigationBar = CustomNavigationBar(type: .centerTitleWithLeftButton)
    
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
        $0.image = .profileBasic
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = 40.adjusted
        $0.clipsToBounds = true
        $0.backgroundColor = .grey300
        $0.isUserInteractionEnabled = true
    }
    
    private let profileImageAddButton = UIButton().then {
        $0.setImage(.icPlusCircle, for: .normal)
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
    
    let nameTextField = UITextField().then {
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
    
    let nameCountLabel = LabelFactory.build(
        text: "0/12",
        font: .button3,
        textColor: .grey400,
        lineSpacing: 1.2,
        characterSpacing: 0.002
    )
    
    let nameValidationIconImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.isHidden = true
    }
    
    let nameValidationLabel = LabelFactory.build(
        text: "",
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
            profileImageLabel,
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
                welcomeLabel
            )
        } else {
            addSubviews(
                navigationBar,
                snsAccountLabel,
                snsTypeLabel
            )
            navigationBar.setTitle("프로필 수정")
        }
    }
    
    private func setLayout() {
        profileImageAddButton.snp.makeConstraints {
            $0.width.height.equalTo(28.adjusted)
            $0.trailing.equalTo(profileImageView.snp.trailing).offset(3.adjusted)
            $0.bottom.equalTo(profileImageView.snp.bottom).offset(2.adjustedH)
        }
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(52.adjustedH)
            $0.leading.equalToSuperview().inset(24.adjusted)
        }
        nameTextField.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(25.adjustedH)
            $0.leading.equalToSuperview().inset(24.adjusted)
            $0.trailing.equalTo(nameCountLabel.snp.leading).offset(-5.adjusted)
        }
        nameCountLabel.snp.makeConstraints {
            $0.centerY.equalTo(nameTextField.snp.centerY)
            $0.trailing.equalToSuperview().inset(38.adjusted)
        }
        underLineView.snp.makeConstraints {
            $0.top.equalTo(nameTextField.snp.bottom).offset(7.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(24.adjusted)
            $0.height.equalTo(1.adjustedH)
        }
        nameValidationIconImageView.snp.makeConstraints {
            $0.top.equalTo(underLineView.snp.bottom).offset(6.adjustedH)
            $0.leading.equalToSuperview().inset(24.adjusted)
            $0.width.height.equalTo(12.adjusted)
        }
        nameValidationLabel.snp.makeConstraints {
            $0.top.equalTo(underLineView.snp.bottom).offset(6.adjustedH)
            $0.leading.equalTo(nameValidationIconImageView.snp.trailing).offset(4.adjusted)
            $0.trailing.equalToSuperview().inset(24.adjusted)
        }
        saveButton.snp.makeConstraints {
            $0.height.equalTo(54.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(-5.adjusted)
            $0.bottom.equalToSuperview().inset(44.adjustedH)
        }
        
        if viewType == .setting {
            welcomeLabel.snp.makeConstraints {
                $0.top.equalToSuperview().inset(36.adjustedH)
                $0.leading.equalToSuperview().inset(24.adjusted)
            }
            profileImageLabel.snp.makeConstraints {
                $0.top.equalTo(welcomeLabel.snp.bottom).offset(36.adjustedH)
                $0.leading.equalToSuperview().inset(24.adjusted)
            }
            profileImageView.snp.makeConstraints {
                $0.top.equalTo(profileImageLabel.snp.bottom).offset(20.adjustedH)
                $0.centerX.equalToSuperview()
                $0.width.height.equalTo(80.adjusted)
            }
        } else {
            navigationBar.snp.makeConstraints {
                $0.top.horizontalEdges.equalToSuperview()
                $0.height.equalTo(68.adjustedH)
            }
            profileImageLabel.snp.makeConstraints {
                $0.top.equalTo(navigationBar.snp.bottom).offset(24.adjustedH)
                $0.leading.equalToSuperview().inset(24.adjusted)
            }
            profileImageView.snp.makeConstraints {
                $0.top.equalTo(profileImageLabel.snp.bottom).offset(20.adjustedH)
                $0.centerX.equalToSuperview()
                $0.width.height.equalTo(80.adjusted)
            }
            snsAccountLabel.snp.makeConstraints {
                $0.top.equalTo(nameValidationLabel.snp.bottom).offset(36.adjustedH)
                $0.leading.equalToSuperview().inset(24.adjusted)
            }
            snsTypeLabel.snp.makeConstraints {
                $0.top.equalTo(snsAccountLabel.snp.bottom).offset(10.adjustedH)
                $0.leading.equalToSuperview().inset(24.adjusted)
            }
        }
    }
}

// MARK: - Methods

extension ProfileView {
    func updateProfileImage(imageString: String) {
        profileImageView.image = ProfileImageUtils.imageForProfile(imageString: imageString)
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
                $0.centerY.equalTo(nameValidationIconImageView.snp.centerY)
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
    
    func bind(userInfo: UserProfileInfoModel) {
        nameTextField.text = userInfo.name
        profileImageView.image = ProfileImageUtils.imageForProfile(imageString: userInfo.profileImage)
        if userInfo.authType == "APPLE" {
            snsTypeLabel.text = "애플 로그인"
        } else if userInfo.authType == "KAKAO" {
            snsTypeLabel.text = "카카오 로그인"
        } else {
            snsTypeLabel.text = "정보 없음"
        }
    }
}
