//
//  WelcomeView.swift
//  Terning-iOS
//
//  Created by 정민지 on 7/10/24.
//

import UIKit

import SnapKit
import Then

final class WelcomeView: UIView {
    
    // MARK: - UI Components
    
    private let welcomeLabel = LabelFactory.build(
        text: "터닝에서 내 계획에 딱 맞는\n대학생 인턴 찾기를 도와드릴게요",
        font: .title1,
        textColor: .terningBlack,
        lineSpacing: 1.2
    ).then {
        $0.numberOfLines = 0
    }
    
    private let logoImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }

    private let startButton = CustomButton(title: "시작하기", font: .button0).then {
        $0.alpha = 0.0
    }
    
    // MARK: - Init
    
    init(viewType: WelcomeViewType) {
        super.init(frame: .zero)
        
        setUI(viewType: viewType)
        setLayout(viewType: viewType)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
    
    // MARK: - UI & Layout
    
extension WelcomeView {
    private func setUI(viewType: WelcomeViewType) {
        switch viewType {
        case .first:
            welcomeLabel.text = "터닝에서 내 계획에 딱 맞는\n대학생 인턴 찾기를 도와드릴게요"
            logoImageView.image = .imgOnbording
            startButton.setTitle(title: "시작하기")
        case .second:
            welcomeLabel.text = "이제 딱 맞는 공고와 함께\n터닝을 시작해 볼까요?"
            logoImageView.image = .imgwelcomTh1Ngjin
            startButton.setTitle(title: "내 맞춤 공고 바로 보러가기")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            UIView.animate(withDuration: 0.5) {
                self.startButton.alpha = 1.0
            }
        }
    }
    
    private func setLayout(viewType: WelcomeViewType) {
        addSubviews(
            welcomeLabel,
            logoImageView,
            startButton
        )
        
        welcomeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(152)
            $0.centerX.equalToSuperview()
        }
        
        switch viewType {
        case .first:
            logoImageView.snp.makeConstraints {
                $0.top.equalTo(welcomeLabel.snp.bottom).offset(39)
                $0.horizontalEdges.equalToSuperview().inset(20)
                $0.height.equalTo(388)
            }
        case .second:
            logoImageView.snp.makeConstraints {
                $0.top.equalTo(welcomeLabel.snp.bottom).offset(56)
                $0.horizontalEdges.equalToSuperview().inset(20)
                $0.height.equalTo(340)
            }
        }
        
        startButton.snp.makeConstraints {
            $0.height.equalTo(54)
            $0.horizontalEdges.equalToSuperview().inset(-5)
            $0.bottom.equalToSuperview().inset(44)
        }
    }
}

// MARK: - Methods

extension WelcomeView {
    func setStartButtonAction(target: Any, action: Selector) {
        startButton.addTarget(target, action: action, for: .touchUpInside)
    }
}
