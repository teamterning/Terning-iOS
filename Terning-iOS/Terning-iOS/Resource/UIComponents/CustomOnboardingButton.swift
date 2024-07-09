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
    
    // MARK: - initialization
    
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods
    
extension CustomOnboardingButton {
    @objc private func buttonTapped() {
        self.isSelected.toggle()
        setStyle()
    }
    
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
    
// MARK: - UI & Layout

extension CustomOnboardingButton {
    private func setUI(cornerRadius: CGFloat) {
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.terningMain.cgColor
        self.titleLabel?.numberOfLines = 0
        self.titleLabel?.textAlignment = .center
        self.titleLabel?.font = .button3
        self.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
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
}
