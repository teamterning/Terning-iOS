//
//  CustomOnboardingButton.swift
//  Terning-iOS
//
//  Created by 정민지 on 7/9/24.
//

import UIKit

import SnapKit

final class CustomOnboardingButton: UIButton {
    
    // MARK: - Properties
    
    private var originalTitle: String
    private var selectedTitle: String
    var index: Int = 0
    
    override var isHighlighted: Bool {
        didSet {
            if isSelected {
                self.layer.borderColor = isHighlighted ? UIColor.grey200.cgColor : UIColor.terningMain.cgColor
                self.backgroundColor = isHighlighted ? .grey50 : .clear
                self.setTitleColor(isHighlighted ? .grey375 : .terningMain, for: .normal)
            } else {
                self.layer.borderColor = isHighlighted ? UIColor.grey200.cgColor : UIColor.grey150.cgColor
                self.backgroundColor = isHighlighted ? .grey50 : .clear
                self.setTitleColor(isHighlighted ? .grey375 : .grey375, for: .normal)
            }
        }
    }
    
    // MARK: - Init
    
    init(
        originalTitle: String,
        selectedTitle: String,
        cornerRadius: CGFloat = 15,
        height: CGFloat = 48
    ) {
        
        self.originalTitle = originalTitle
        self.selectedTitle = selectedTitle
        
        super.init(frame: .zero)
        
        setUI(cornerRadius: cornerRadius)
        setLayout(height: height)
        setStyle()
        setAddTarget()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension CustomOnboardingButton {
    private func setUI(cornerRadius: CGFloat) {
        self.makeBorder(
            width: 1,
            color: .grey150,
            cornerRadius: cornerRadius
        )
        self.setTitleColor(.grey375, for: .normal)
        self.titleLabel?.numberOfLines = 0
        self.titleLabel?.textAlignment = .center
        self.titleLabel?.font = .button3
    }
    
    private func setLayout(height: CGFloat) {
        self.snp.makeConstraints {
            $0.height.equalTo(height)
        }
    }
    
    private func setStyle() {
        if self.isSelected {
            self.setTitle(selectedTitle, for: .normal)
            self.setTitleColor(.terningMain, for: .normal)
            self.layer.borderColor = UIColor.terningMain.cgColor
            self.backgroundColor = .clear
        } else {
            self.setTitle(originalTitle, for: .normal)
            self.setTitleColor(.grey375, for: .normal)
            self.layer.borderColor = UIColor.grey150.cgColor
            self.backgroundColor = .clear
        }
    }
    
    private func setAddTarget() {
        self.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
}

// MARK: - Methods

extension CustomOnboardingButton {
    public func selectButton() {
        guard !self.isSelected else { return }
        self.isSelected = true
        setStyle()
    }
    
    public func deselectButton() {
        guard self.isSelected else { return }
        self.isSelected = false
        setStyle()
    }
}

// MARK: - @objc func

extension CustomOnboardingButton {
    @objc
    private func buttonTapped() {
        self.isSelected.toggle()
        setStyle()
    }
}
