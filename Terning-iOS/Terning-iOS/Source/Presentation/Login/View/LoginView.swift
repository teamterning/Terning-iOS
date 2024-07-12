//
//  LoginView.swift
//  Terning-iOS
//
//  Created by 정민지 on 7/13/24.
//

import UIKit

import SnapKit

final class LoginView: UIView {

    // MARK: - UI Components
    
    private let logoImageView = UIImageView().then {
        $0.image = .icHome
        $0.contentMode = .scaleAspectFit
        $0.layer.masksToBounds = true
    }
    
    private var kakaoLoginButton = UIButton().then {
        $0.setImage(.iosBtnBoxKakao, for: .normal)
    }
    
    private var appleLoginButton = UIButton().then {
        $0.setImage(.iosBtnBoxApple, for: .normal)
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
        kakaoLoginButton.configuration = .plain()
        kakaoLoginButton.configurationUpdateHandler = { button in
            var config = button.configuration
            config?.image = button.isHighlighted ? .iosBtnBoxKakao : .iosBtnBoxKakao
            button.configuration = config
        }
        
        appleLoginButton.configuration = .plain()
        appleLoginButton.configurationUpdateHandler = { button in
            var config = button.configuration
            config?.image = button.isHighlighted ? .iosBtnBoxApple : .iosBtnBoxApple
            button.configuration = config
        }
        
        self.addSubviews(
            logoImageView,
            kakaoLoginButton,
            appleLoginButton
        )
    }
    
    private func setLayout() {
        logoImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(111)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(383)
        }
        
        kakaoLoginButton.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom).offset(66)
            $0.centerX.equalToSuperview()
        }
        
        appleLoginButton.snp.makeConstraints {
            $0.top.equalTo(kakaoLoginButton.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
        }
        
    }
}
