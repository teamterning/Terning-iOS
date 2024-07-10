//
//  CustomNavigationBar.swift
//  Terning-iOS
//
//  Created by 이명진 on 7/10/24.
//

import UIKit

import SnapKit
import Then

@frozen
enum NavigationBarType {
    case leftButton // 뒤로가기 버튼
    case centerTitleWithLeftButton // 뒤로가기 버튼 + 중앙 타이틀
}

final class CustomNavigationBar: UIView {
    
    // MARK: - Properties
    
    private var naviType: NavigationBarType!
    private var viewController: UIViewController?
    private var leftButtonClosure: (() -> Void)?
    private var isShadow: Bool = true
    
    // MARK: - UI Components
    
    private lazy var centerTitleLabel = createTitleLabel()
    
    let leftButton = UIButton().then {
        $0.setImage(UIImage(resource: .icBackArrow), for: .normal)
    }
    
    // MARK: - Life Cycles
    
    init(_ viewController: UIViewController, type: NavigationBarType, isShadow: Bool = true) {
        super.init(frame: .zero)
        
        self.viewController = viewController
        self.isShadow = isShadow
        self.setUI(type)
        self.setLayout(type)
        self.setAddTarget(type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - UI & Layout

extension CustomNavigationBar {
    private func setUI(_ type: NavigationBarType) {
            addSubviews(leftButton)
            
            self.backgroundColor = .white
            
            if isShadow {
                self.layer.applyShadow(alpha: 0.15, y: 3, blur: 4, spread: 0)
            }
            
            if type == .centerTitleWithLeftButton {
                addSubview(centerTitleLabel)
            }
        }
    
    private func setLayout(_ type: NavigationBarType) {
        
        leftButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
            $0.width.height.equalTo(32)
        }
        
        if type == .centerTitleWithLeftButton {
            centerTitleLabel.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
        }
    }
    
    private func createTitleLabel() -> UILabel {
        return UILabel().then {
            $0.font = .title2
            $0.textColor = .black
        }
    }
}

// MARK: - Custom methods

extension CustomNavigationBar {
    func hideNaviBar(_ isHidden: Bool) {
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut) {
            [
                self.centerTitleLabel,
                self.leftButton
            ].forEach { $0.alpha = isHidden ? 0 : 1 }
        }
    }
    
    /// 내비게이션의 title을 세팅합니다.
    func setTitle(_ title: String) -> Self {
        self.centerTitleLabel.text = title
        return self
    }
    
    /// 기존 뒤로가기 버튼의 Action을 수정하고 싶을때 사용합니다.
    @discardableResult
    func resetLeftButtonAction(_ closure: (() -> Void)? = nil, _ type: NavigationBarType) -> Self {
        self.leftButtonClosure = closure
        self.leftButton.removeTarget(self, action: nil, for: .touchUpInside)
        if closure != nil {
            self.leftButton.addTarget(self, action: #selector(leftButtonDidTap), for: .touchUpInside)
        } else {
            self.setAddTarget(type)
        }
        return self
    }
    
    /// 내비게이션의 title의 font와 textColor를 수정합니다.
    func updateTitleFontAndColor(font: UIFont, color: UIColor) -> Self {
        centerTitleLabel.font = font
        centerTitleLabel.textColor = color
        return self
    }
    
    private func setAddTarget(_ type: NavigationBarType) {
        if type == .centerTitleWithLeftButton {
            leftButton.addTarget(self, action: #selector(popToPreviousVC), for: .touchUpInside)
        }
    }
}

extension CustomNavigationBar {
    @objc
    private func popToPreviousVC() {
        self.viewController?.popOrDismissViewController()
    }
    
    @objc
    private func leftButtonDidTap() {
        self.leftButtonClosure?()
    }
}
