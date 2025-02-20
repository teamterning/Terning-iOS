//
//  LoginView.swift
//  Terning-iOS
//
//  Created by 정민지 on 7/13/24.
//

import UIKit

import Lottie
import SnapKit
import Then

final class LoginView: UIView {
    
    // MARK: - UI Components
    
    private let logoAnimationView = LottieAnimationView().then {
        let animation = LottieAnimation.named("loginAnimation")
        $0.animation = animation
        $0.contentMode = .scaleAspectFit
        $0.loopMode = .autoReverse
        $0.animationSpeed = 1
        $0.play()
    }
    
    let kakaoLoginButton = UIButton(type: .custom).then {
        $0.setImage(.imgKakaoButton, for: .normal)
    }
    
    let appleLoginButton = UIButton(type: .custom).then {
        $0.setImage(.imgAppleButton, for: .normal)
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension LoginView {
    private func setUI() {
        self.addSubviews(
            logoAnimationView,
            kakaoLoginButton,
            appleLoginButton
        )
    }
    
    private func setLayout() {
        logoAnimationView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(111.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(20.adjusted)
            $0.height.equalTo(383.adjustedH)
        }
        
        kakaoLoginButton.snp.makeConstraints {
            $0.top.equalTo(logoAnimationView.snp.bottom).offset(66.adjustedH)
            $0.centerX.equalToSuperview()
        }
        
        appleLoginButton.snp.makeConstraints {
            $0.top.equalTo(kakaoLoginButton.snp.bottom).offset(12.adjustedH)
            $0.centerX.equalToSuperview()
        }
    }
}
