//
//  CustomButton.swift
//  Terning-iOS
//
//  Created by 이명진 on 7/6/24.
//

import UIKit

import RxSwift
import SnapKit
import Then

public final class CustomButton: UIButton {
    
    private var title: String
    private let font: UIFont
    private let cornerRadius: CGFloat
    private let borderColor: UIColor
    
    public init(
        title: String,
        font: UIFont = .button0,
        cornerRadius: CGFloat = 0,
        borderColor: UIColor = .clear
    ) {
        
        self.title = title
        self.font = font
        self.cornerRadius = cornerRadius
        self.borderColor = borderColor
        
        super.init(frame: .zero)
        
        setStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension CustomButton {
    /// 버튼의 enable 여부 설정
    @discardableResult
    public func setEnabled(_ isEnabled: Bool) -> Self {
        self.isEnabled = isEnabled
        self.updateBackgroundColor()
        return self
    }
    
    /// 버튼의 Title 변경
    @discardableResult
    public func setTitle(title: String) -> Self {
        self.title = title
        
        self.setAttributedTitle(
            NSAttributedString(
                string: title,
                attributes: [.font: font, .foregroundColor: self.titleLabel?.textColor ?? UIColor.white]
            ),
            for: .normal
        )
        return self
    }
    
    /// 버튼의 Title 변경2
    @discardableResult
    public func changeTitle(attributedString: NSAttributedString) -> Self {
        self.setAttributedTitle(attributedString, for: .normal)
        return self
    }
    
    /// 버튼의 backgroundColor, textColor 변경
    @discardableResult
    public func setColor(bgColor: UIColor, disableColor: UIColor, textColor: UIColor = .white) -> Self {
        
        self.setBackgroundColor(bgColor, for: .normal)
        self.setBackgroundColor(disableColor, for: .disabled)
        
        self.setAttributedTitle(
            NSAttributedString(
                string: self.titleLabel?.text ?? "",
                attributes: [.font: font, .foregroundColor: textColor]),
            for: .normal
        )
        self.setAttributedTitle(
            NSAttributedString(
                string: self.titleLabel?.text ?? "",
                attributes: [.font: font, .foregroundColor: textColor]),
            for: .disabled
        )
        
        return self
    }
}

// MARK: - UI & Layout

extension CustomButton {
    private func setStyle() {
        configuration = UIButton.Configuration.plain()
        configuration?.baseForegroundColor = .white
        configuration?.attributedTitle = AttributedString(
            title,
            attributes: AttributeContainer(
                [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor.white]
            )
        )
        
        makeBorder(width: 1, color: borderColor)
        layer.cornerRadius = self.cornerRadius
        
        let buttonStateHandler: UIButton.ConfigurationUpdateHandler = { button in
            var updatedConfiguration = button.configuration
            switch button.state {
            case .normal:
                updatedConfiguration?.background.backgroundColor = .terningMain
            case .highlighted:
                updatedConfiguration?.background.backgroundColor = .terningMain2
            default:
                break
            }
            button.configuration = updatedConfiguration
            button.configuration?.attributedTitle = AttributedString(self.title, attributes: AttributeContainer([NSAttributedString.Key.font: self.font, NSAttributedString.Key.foregroundColor: UIColor.white]))
        }
        
        self.configurationUpdateHandler = buttonStateHandler
    }
    
    private func updateBackgroundColor() {
        let bgColor: UIColor = self.isEnabled ? .terningMain :.grey200
        self.configuration?.background.backgroundColor = bgColor
    }
}
