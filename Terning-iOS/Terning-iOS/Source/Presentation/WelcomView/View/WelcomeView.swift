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
        text: "터치 3번으로\n원하는 대학생 인턴 공고를 띄워드릴게요",
        font: .title1,
        textColor: .terningBlack,
        lineSpacing: 1.2
    ).then {
        $0.numberOfLines = 0
    }
    
    private let welcomeGuideLabel = LabelFactory.build(
        text: "마음에 드는 공고를 스크랩하며\n나만의 인턴 캘린더를 채워보세요",
        font: .body2,
        textColor: .grey300,
        lineSpacing: 1.2
    ).then {
        $0.numberOfLines = 2
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
            welcomeLabel.text = "터치 3번으로\n원하는 대학생 인턴 공고를 띄워드릴게요"
            welcomeGuideLabel.isHidden = true
            logoImageView.image = .icHome
            startButton.setTitle(title: "시작하기")
        case .second:
            welcomeLabel.text = "나에게 딱 맞는 대학생 인턴 공고를\n찾을 준비가 완료되었어요!"
            welcomeGuideLabel.text = "마음에 드는 공고를 스크랩하며\n나만의 인턴 캘린더를 채워보세요"
            welcomeGuideLabel.isHidden = false
            logoImageView.image = .icHomeFill
            startButton.setTitle(title: "내 맞춤 공고 바로 보러가기")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            UIView.animate(withDuration: 0.5) {
                self.startButton.alpha = 1.0
            }
        }
    }
    
    private func setLayout(viewType: WelcomeViewType) {
        addSubviews(
            welcomeLabel,
            welcomeGuideLabel,
            logoImageView,
            startButton
        )
        
        welcomeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(152)
            $0.centerX.equalToSuperview()
        }
        
        welcomeGuideLabel.snp.makeConstraints {
            $0.top.equalTo(welcomeLabel.snp.bottom).offset(11)
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
                $0.top.equalTo(welcomeGuideLabel.snp.bottom).offset(33)
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
