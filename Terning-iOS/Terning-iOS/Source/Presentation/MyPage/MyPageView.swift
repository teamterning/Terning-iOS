//
//  MyPageView.swift
//  Terning-iOS
//
//  Created by 김민성 on 7/17/24.
//

import UIKit

import SnapKit
import Then

class MyPageView: UIView {
    
    // MARK: - UICompoenents
    
    let userNameLabel = LabelFactory.build(
        text: "남지우님",
        font: .heading1,
        textColor: .terningBlack,
        textAlignment: .left
    )
    
    let profileImage = UIImageView().then {
        $0.image = UIImage(resource: .icHome)
        $0.makeBorder(width: 1, color: .calBlue1)
    }
    
    let profileEditLabel = LabelFactory.build(
        text: "프로필 수정",
        font: .button3,
        textColor: .grey400
    )
    
    let profileEditImage = UIImageView().then {
        $0.image = UIImage(resource: .icFrontArrow)
    }
    
    lazy var profileEditStack = UIStackView(
        arrangedSubviews: [
            profileEditLabel,
            profileEditImage
        ]
    ).then {
        $0.axis = .horizontal
        $0.spacing = 0
        $0.alignment = .center
        $0.distribution = .fillProportionally
        $0.isUserInteractionEnabled = true
    }
    
    let bottomView = UIView().then {
        $0.backgroundColor = UIColor(hex: "F8F8F8")
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.makeBorder(width: 0, color: .clear, cornerRadius: 30)
        $0.clipsToBounds = true
        $0.layer.applyShadow(color: .black, alpha: 0.25, x: 0, y: -2, blur: 4, spread: 0)
    }
    
    let bottomSubView = UIView().then {
        $0.backgroundColor = .white
        $0.makeBorder(width: 0, color: .clear, cornerRadius: 10)
        $0.clipsToBounds = true
        $0.layer.applyShadow(color: .black, alpha: 0.25, x: 0, y: 0, blur: 4, spread: 0)
    }
    
    let noticeImage = UIImageView().then {
        $0.image = UIImage(resource: .icHomeFill)
    }
    
    let noticeLabel = LabelFactory.build(
        text: "공지사항",
        font: .body5,
        textColor: .black,
        textAlignment: .left
    )
    
    lazy var noticeButton = UIButton().then {
        $0.setImage(UIImage(resource: .icFrontArrow), for: .normal)
    }
    
    lazy var noticeStack = UIStackView(
        arrangedSubviews: [
            noticeImage,
            noticeLabel
        ]
    ).then {
        $0.axis = .horizontal
        $0.spacing = 12
        $0.distribution = .fillProportionally
    }
    
    let sendOpinionImage = UIImageView().then {
        $0.image = UIImage(resource: .icHomeFill)
    }
    
    let sendOpinionLabel = LabelFactory.build(
        text: "의견 보내기",
        font: .body5,
        textColor: .black,
        textAlignment: .left
    )
    
    lazy var sendOpinionButton = UIButton().then {
        $0.setImage(UIImage(resource: .icFrontArrow), for: .normal)
    }
    
    lazy var sendOpinionStack = UIStackView(
        arrangedSubviews: [
            sendOpinionImage,
            sendOpinionLabel
        ]
    ).then {
        $0.axis = .horizontal
        $0.spacing = 12
        $0.alignment = .fill
        $0.distribution = .fillProportionally
    }
    
    let versionInfoImage = UIImageView().then {
        $0.image = UIImage(resource: .icHomeFill)
    }
    
    let versionInfoLabel = LabelFactory.build(
        text: "버전정보",
        font: .body5,
        textColor: .black,
        textAlignment: .left
    )
    
    let versionInfo = LabelFactory.build(
        text: "1.1.0",
        font: .button4,
        textColor: .grey400
    )
    
    lazy var versionInfoStack = UIStackView(
        arrangedSubviews: [
            versionInfoImage,
            versionInfoLabel
        ]
    ).then {
        $0.axis = .horizontal
        $0.spacing = 12
        $0.alignment = .fill
        $0.distribution = .fillProportionally
    }

    lazy var logoutButton = LabelFactory.build(
        text: "로그아웃",
        font: .button4,
        textColor: .grey350
    ).then {
        $0.isUserInteractionEnabled = true
    }
    
    let verticalBar = UIImageView().then {
        $0.image = UIImage(resource: .myPageVerticalBar)
    }
    
    lazy var leaveButton = LabelFactory.build(
        text: "탈퇴하기",
        font: .button4,
        textColor: .grey350
    ).then {
        $0.isUserInteractionEnabled = true
    }
    
    lazy var sessionEndStack = UIStackView(
        arrangedSubviews: [
            logoutButton,
            verticalBar,
            leaveButton
        ]
    ).then {
        $0.axis = .horizontal
        $0.spacing = 4
        $0.alignment = .center
        $0.distribution = .fillProportionally
    }
    
    // MARK: LifeCycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierarchy()
        setLayout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension MyPageView {
    
    func setUI() {
        backgroundColor = .white
    }
    
    func setHierarchy() {
        addSubviews(
            profileImage,
            userNameLabel,
            profileEditStack,
            bottomView,
            bottomSubView,
            noticeStack,
            noticeButton,
            sendOpinionStack,
            sendOpinionButton,
            versionInfoStack,
            versionInfo,
            sessionEndStack
        )
    }
    
    func setLayout() {
        userNameLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(77)
            $0.leading.equalToSuperview().offset(20)
        }
        
        profileImage.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(57)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(363)
        }
        
        profileEditImage.snp.makeConstraints {
            $0.height.width.equalTo(20)
        }

        profileEditStack.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(25)
            $0.trailing.equalToSuperview().inset(12)
            $0.width.equalTo(85)
        }

        bottomView.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(224)
        }
        
        bottomSubView.snp.makeConstraints {
            $0.top.equalTo(bottomView.snp.top).inset(25)
            $0.bottom.equalTo(bottomView.snp.bottom).inset(46)
            $0.horizontalEdges.equalTo(bottomView).inset(20)
        }
        
        noticeImage.snp.makeConstraints {
            $0.width.height.equalTo(28)
        }
        
        noticeStack.snp.makeConstraints {
            $0.top.equalTo(bottomSubView.snp.top).inset(15)
            $0.leading.equalTo(bottomSubView).inset(20)
        }
        
        noticeButton.snp.makeConstraints {
            $0.top.equalTo(bottomSubView.snp.top).inset(19)
            $0.height.width.equalTo(24)
            $0.trailing.equalTo(bottomSubView.snp.trailing).inset(20)
        }

        sendOpinionImage.snp.makeConstraints {
            $0.width.height.equalTo(28)
        }
        
        sendOpinionStack.snp.makeConstraints {
            $0.top.equalTo(noticeStack.snp.bottom).offset(20)
            $0.leading.equalTo(bottomSubView).inset(20)
        }
        
        sendOpinionButton.snp.makeConstraints {
            $0.top.equalTo(noticeButton.snp.bottom).offset(24)
            $0.height.width.equalTo(24)
            $0.trailing.equalTo(bottomSubView.snp.trailing).inset(20)
        }
        
        versionInfoImage.snp.makeConstraints {
            $0.height.width.equalTo(28)
        }
        
        versionInfoStack.snp.makeConstraints {
            $0.top.equalTo(sendOpinionStack.snp.bottom).offset(20)
            $0.leading.equalTo(bottomSubView).inset(20)
        }
        
        versionInfo.snp.makeConstraints {
            $0.top.equalTo(sendOpinionButton.snp.top).offset(50)
            $0.trailing.equalTo(bottomSubView.snp.trailing).inset(22)
        }
        
        sessionEndStack.snp.makeConstraints {
            $0.top.equalTo(bottomView.snp.top).offset(196)
            $0.centerX.equalTo(bottomView)
        }
    }
}

// MARK: - Methods

extension MyPageView {
    
    // MARK: - Methods

    func bind(model: UserProfileInfoModel) {
        userNameLabel.text = "\(model.name)님"
    }
}
