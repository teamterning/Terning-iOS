//
//  WelcomeView.swift
//  Terning-iOS
//
//  Created by 정민지 on 7/10/24.
//

import UIKit

import SnapKit
import Then
import Lottie

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
    
    private let logoAnimationView = LottieAnimationView().then {
        $0.contentMode = .scaleAspectFit
        $0.loopMode = .loop
        $0.animationSpeed = 1
    }

    private let startButton = CustomButton(title: "시작하기", font: .button0).then {
        $0.alpha = 0.0
    }
    
    private let skipButton = UIButton().then {
        $0.backgroundColor = .clear
        $0.tintColor = .grey500

        let title = "계획 나중에 입력하기"
        let attributedTitle = NSAttributedString(
            string: title,
            attributes: [
                .font: UIFont.detail3,
                .underlineStyle: NSUnderlineStyle.single.rawValue,
                .foregroundColor: UIColor.grey500
            ]
        )
        $0.setAttributedTitle(attributedTitle, for: .normal)
    }.then {
        $0.alpha = 0.0
    }

    // MARK: - Init
    
    init(viewType: WelcomeViewType) {
        super.init(frame: .zero)
        
        setUI(viewType: viewType)
        setHierarchy(viewType: viewType)
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
            let animation = LottieAnimation.named("beforeOnboarding")
            logoAnimationView.animation = animation
            logoAnimationView.play()
            startButton.setTitle(title: "시작하기")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                UIView.animate(withDuration: 0.5) {
                    self.skipButton.alpha = 1.0
                }
            }
        case .second:
            welcomeLabel.text = "나에게 딱 맞는 공고가 준비됐어요!\n터닝을 시작해 볼까요?"
            let animation = LottieAnimation.named("afterOnboarding")
            logoAnimationView.animation = animation
            logoAnimationView.play()
            startButton.setTitle(title: "내 맞춤 공고 바로 보러가기")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            UIView.animate(withDuration: 0.5) {
                self.startButton.alpha = 1.0
            }
        }
    }
    
    private func setHierarchy(viewType: WelcomeViewType) {
        addSubviews(
            welcomeLabel,
            logoAnimationView,
            startButton
        )
        if viewType == .first {
            addSubview(skipButton)
        }
    }
    
    private func setLayout(viewType: WelcomeViewType) {
        welcomeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(152)
            $0.centerX.equalToSuperview()
        }
        
        switch viewType {
        case .first:
            logoAnimationView.snp.makeConstraints {
                $0.top.equalTo(welcomeLabel.snp.bottom).offset(39.adjustedH)
                $0.horizontalEdges.equalToSuperview().inset(24.adjusted)
                $0.height.equalTo(388.adjustedH)
            }
            skipButton.snp.makeConstraints {
                $0.height.equalTo(14.adjustedH)
                $0.centerX.equalToSuperview()
                $0.bottom.equalToSuperview().inset(44.adjustedH)
            }
        case .second:
            logoAnimationView.snp.makeConstraints {
                $0.top.equalTo(welcomeLabel.snp.bottom).offset(56.adjustedH)
                $0.horizontalEdges.equalToSuperview().inset(24.adjusted)
                $0.height.equalTo(340.adjustedH)
            }
        }
        
        startButton.snp.makeConstraints {
            $0.height.equalTo(54.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(24.adjusted)
            $0.bottom.equalToSuperview().inset(78.adjustedH)
        }
    }
}

// MARK: - Methods

extension WelcomeView {
    func setStartButtonAction(target: Any, action: Selector) {
        startButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    func setSkipButtonAction(target: Any, action: Selector) {
        guard skipButton.superview != nil else { return }
        skipButton.addTarget(target, action: action, for: .touchUpInside)
    }
}
