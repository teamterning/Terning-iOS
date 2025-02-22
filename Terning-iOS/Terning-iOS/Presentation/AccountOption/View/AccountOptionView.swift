//
//  AccountOptionView.swift
//  Terning-iOS
//
//  Created by 정민지 on 9/4/24.
//

import UIKit

import RxSwift

import SnapKit
import Then

final class AccountOptionView: UIView {
    
    // MARK: - UI Components
    
    private let notchView = UIView().then {
        $0.backgroundColor = .grey300
        $0.layer.cornerRadius = 2.adjustedH
    }
    
    let titleLabel = LabelFactory.build(
        text: "잠깐만요!",
        font: .heading1
    )
    
    let subTitleLabel = LabelFactory.build(
        font: .body4,
        textColor: .grey400
    ).then {
        $0.numberOfLines = 4
    }
    
    lazy var yesButton = TerningCustomButton(
        title: "로그아웃하기",
        font: .button2,
        radius: 10.adjustedH
    )
    
    lazy var noButton = TerningCustomButton(
        title: "취소",
        font: .button2,
        radius: 10.adjustedH
    )
    
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

extension AccountOptionView {
    private func setUI() {
        backgroundColor = .white
        addSubviews(
            notchView,
            titleLabel,
            subTitleLabel,
            yesButton,
            noButton
        )
        
        noButton.setAppearance(normalBackgroundColor: .grey100, pressedBackgroundColor: .grey200, textNormal: .grey400)
    }
    
    private func setLayout() {
        notchView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12.adjustedH)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(4.adjustedH)
            $0.width.equalTo(60.adjusted)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(notchView.snp.bottom).offset(37.adjustedH)
            $0.height.equalTo(24)
            $0.centerX.equalToSuperview()
        }
        subTitleLabel.snp.makeConstraints {
            $0.top.lessThanOrEqualTo(titleLabel.snp.bottom).offset(28.adjustedH)
            $0.bottom.greaterThanOrEqualTo(yesButton.snp.top).offset(-31.adjustedH)
            $0.centerX.equalToSuperview()
        }
        yesButton.snp.makeConstraints {
            $0.height.equalTo(45.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(24.adjusted)
            $0.bottom.equalTo(noButton.snp.top).offset(-8.adjustedH)
        }
        noButton.snp.makeConstraints {
            $0.height.equalTo(45.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(24.adjusted)
            $0.bottom.equalToSuperview().inset(32.adjustedH)
        }
    }
}

// MARK: - Bind

extension AccountOptionView {
    func bind(for viewType: AccountOption) {
        if viewType == .logout {
            subTitleLabel.text = "정말 로그아웃 하시겠어요?"
            yesButton.updateTitle("로그아웃하기")
        } else {
            subTitleLabel.text = "탈퇴 시 계정 및 이용 기록은 모두 삭제되며,\n삭제된 데이터는 복구가 불가능합니다.\n\n탈퇴를 진행할까요?"
            yesButton.updateTitle("탈퇴하기")
        }
    }
}
