//
//  CustomNavigationBar.swift
//  Terning-iOS
//
//  Created by 이명진 on 7/10/24.
//

import UIKit

import RxSwift
import RxCocoa

import SnapKit
import Then

@frozen
enum NavigationBarType {
    case leftButton // 뒤로가기 버튼
    case centerTitleWithLeftButton // 뒤로가기 버튼 + 중앙 타이틀
    case calendar // 캘린더 전용 네비게이션
}

final class CustomNavigationBar: UIView {
    
    // MARK: - Properties
    
    private var naviType: NavigationBarType!
    private var isShadow: Bool = false
    private let disposeBag = DisposeBag()
    var leftButtonAction: (() -> Void)?
    
    // MARK: - UI Components
    
    private var centerTitleLabel = LabelFactory.build(
        font: .title2,
        textColor: .terningBlack
    )
    
    private let leftButton = UIButton().then {
        $0.setImage(UIImage(resource: .icBackArrow), for: .normal)
    }
    
    private let calendarBackButton = UIButton().then {
        $0.setImage(UIImage(resource: .icBackArrowGreen), for: .normal)
    }
    
    private let calendarFrontButton = UIButton().then {
        $0.setImage(UIImage(resource: .icFrontArrow), for: .normal)
    }
    
    private let calendarListButton = UIButton().then {
        $0.setImage(UIImage(resource: .icCalendar), for: .normal)
        $0.setImage(UIImage(resource: .icCalendarFill), for: .selected)
    }
    
    // MARK: - Observables
    
    var calendarBackButtonDidTap: Observable<Void> {
        return calendarBackButton.rx.tap.asObservable()
    }
    
    var calendarFrontButtonDidTap: Observable<Void> {
        return calendarFrontButton.rx.tap.asObservable()
    }
    
    var calendarListButtonDidTap: Observable<Void> {
        return calendarListButton.rx.tap.asObservable()
    }
    
    // MARK: - Life Cycles
    
    init(type: NavigationBarType, isShadow: Bool = false, leftButtonAction: (() -> Void)? = nil) {
        super.init(frame: .zero)
        
        self.naviType = type
        self.isShadow = isShadow
        self.leftButtonAction = leftButtonAction
        self.setUI(type)
        self.setLayout(type)
        self.bindAction(type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension CustomNavigationBar {
    private func setUI(_ type: NavigationBarType) {
        self.backgroundColor = .white
        
        switch type {
        case .leftButton:
            self.addSubview(leftButton)
        case .centerTitleWithLeftButton:
            self.addSubviews(leftButton, centerTitleLabel)
        case .calendar:
            self.addSubviews(centerTitleLabel, calendarBackButton, calendarFrontButton, calendarListButton)
        }
        
        if isShadow {
            self.layer.applyShadow(color: .terningBlack, alpha: 0.15, y: 3, blur: 4, spread: 0)
        }
    }
    
    private func setLayout(_ type: NavigationBarType) {
        switch type {
        case .leftButton:
            leftButton.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.equalToSuperview().inset(20)
                $0.width.height.equalTo(32)
            }
            
        case .centerTitleWithLeftButton:
            leftButton.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.equalToSuperview().inset(20)
                $0.width.height.equalTo(32)
            }
            centerTitleLabel.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
            
        case .calendar:
            centerTitleLabel.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
            calendarBackButton.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.trailing.equalTo(centerTitleLabel.snp.leading).offset(-8)
                $0.width.height.equalTo(28)
            }
            calendarFrontButton.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.equalTo(centerTitleLabel.snp.trailing).offset(8)
                $0.width.height.equalTo(28)
            }
            calendarListButton.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.equalTo(calendarFrontButton.snp.trailing).offset(59)
                $0.width.height.equalTo(28)
            }
        }
    }
    
    private func bindAction(_ type: NavigationBarType) {
        if type == .leftButton || type == .centerTitleWithLeftButton {
            leftButton.rx.tap
                .subscribe(onNext: { [weak self] in
                    self?.leftButtonAction?()
                })
                .disposed(by: disposeBag)
        }
    }
}

// MARK: - Custom Methods

extension CustomNavigationBar {
    /// 내비게이션의 title을 세팅합니다.
    @discardableResult
    func setTitle(_ title: String) -> Self {
        self.centerTitleLabel.text = title
        return self
    }
    
    /// 내비게이션의 title의 font와 textColor를 수정합니다.
    func updateTitleFontAndColor(font: UIFont, color: UIColor) -> Self {
        centerTitleLabel.font = font
        centerTitleLabel.textColor = color
        return self
    }
}
