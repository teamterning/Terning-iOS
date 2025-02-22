//
//  TerningCustomButton.swift
//  Terning-iOS
//
//  Created by 이명진 on 2/22/25.
//

import UIKit

final class TerningCustomButton: UIButton {
    
    // MARK: - Properties
    
    private var title: String
    private let font: UIFont
    private var radius: CGFloat
    var buttonDidTap: (() -> Void)?
    
    // MARK: - Init
    
    init(
        title: String,
        font: UIFont = .button0,
        radius: CGFloat = 0
    ) {
        self.title = title
        self.font = font
        self.radius = radius
        super.init(frame: .zero)
        
        setUI()
        setAddTarget()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
    private func setUI() {
        configuration = UIButton.Configuration.plain()
        configuration?.background.cornerRadius = self.radius
        setAppearance()
    }
    
    // MARK: - Methods
    
    private func setAddTarget() {
        self.addTarget(self, action: #selector(customButtonDidTap), for: .touchUpInside)
    }
    
    @objc
    private func customButtonDidTap() {
        buttonDidTap?()
    }
    
    @discardableResult
    func setEnabled(_ enabled: Bool) -> Self {
        self.isEnabled = enabled
        return self
    }
    
    @discardableResult
    func setCornerRadius(radius: CGFloat) -> Self {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
        return self
    }
    
    @discardableResult
    func updateTitle(_ newTitle: String) -> Self {
        self.title = newTitle
        setAppearance()
        return self
    }
}

// MARK: - updateAppearance

extension TerningCustomButton {
    /// 초기 버튼의 상태를 설정하는 메서드입니다. 기본(default) 값이 설정되어 있으며,
    /// 외부 호출을 통해 커스텀하여 사용할 수 있습니다.
    ///
    /// - Parameters:
    ///   - normalBackgroundColor: 활성화 상태일 때의 배경색
    ///   - pressedBackgroundColor: `pressed` 상태일 때의 배경색
    ///   - disabledBackgroundColor: 비활성화 상태일 때의 배경색
    ///   - textNormal: 활성화 상태일 때의 텍스트 색상
    ///   - textDisabled: 비활성화 상태일 때의 텍스트 색상
    func setAppearance(
        normalBackgroundColor: UIColor = .terningMain,
        pressedBackgroundColor: UIColor = .terningSub1,
        disabledBackgroundColor: UIColor = .grey200,
        textNormal: UIColor = .white,
        textDisabled: UIColor = .grey350
    ) {
        let buttonStateHandler: UIButton.ConfigurationUpdateHandler = { button in
            var updatedConfiguration = button.configuration
            let foregroundColor: UIColor
            let backgroundColor: UIColor
            
            switch button.state {
            case .normal:
                backgroundColor = normalBackgroundColor
                foregroundColor = textNormal
            case .highlighted:
                backgroundColor = pressedBackgroundColor
                foregroundColor = textNormal
            case .disabled:
                backgroundColor = disabledBackgroundColor
                foregroundColor = textDisabled
            default:
                backgroundColor = normalBackgroundColor
                foregroundColor = textNormal
            }
            
            updatedConfiguration?.background.backgroundColor = backgroundColor
            updatedConfiguration?.attributedTitle = AttributedString(
                self.title,
                attributes: AttributeContainer(
                    [
                        NSAttributedString.Key.font: self.font,
                        NSAttributedString.Key.foregroundColor: foregroundColor
                    ]
                )
            )
            
            button.configuration = updatedConfiguration
        }
        self.configurationUpdateHandler = buttonStateHandler
    }
}
