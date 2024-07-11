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
                self.layer.borderColor = isHighlighted ? UIColor.terningMain2.cgColor : UIColor.terningMain.cgColor
                self.backgroundColor = isHighlighted ? .terningSelectPressed : .terningSelect
            } else {
                self.layer.borderColor = isHighlighted ? UIColor.terningMain2.cgColor : UIColor.terningMain.cgColor
                self.backgroundColor = isHighlighted ? .terningPressed : .clear
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
            color: .terningMain,
            cornerRadius: cornerRadius
        )
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
            self.backgroundColor = .terningSelect
        } else {
            self.setTitle(originalTitle, for: .normal)
            self.setTitleColor(.grey400, for: .normal)
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
