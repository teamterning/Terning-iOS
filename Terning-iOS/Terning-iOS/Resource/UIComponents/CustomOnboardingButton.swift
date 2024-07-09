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
        toggleButton()
    }
    
    private func toggleButton() {
        self.isSelected.toggle()
        setStyle()
    }
    
    
    func selectButton() {
        guard !self.isSelected else { return }
        self.isSelected = true
        setStyle()
    }
    
    func deselectButton() {
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
        self.layer.borderColor = UIColor.black.cgColor
        self.titleLabel?.numberOfLines = 0
        self.titleLabel?.textAlignment = .center
        self.titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: .bold)
    }
    
    private func setLayout(height: CGFloat) {
        self.snp.makeConstraints {
            $0.height.equalTo(height)
        }
        self.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    private func setStyle() {
        if self.isSelected {
            self.setTitle(selectedTitle, for: .normal)
            self.setTitleColor(.green, for: .normal)
            self.layer.borderColor = UIColor.green.cgColor
            self.backgroundColor = UIColor.green.withAlphaComponent(0.3)
        } else {
            self.setTitle(originalTitle, for: .normal)
            self.setTitleColor(.gray, for: .normal)
            self.layer.borderColor = UIColor.lightGray.cgColor
            self.backgroundColor = .clear
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            if isSelected {
                self.backgroundColor = isHighlighted ? UIColor.green.withAlphaComponent(0.5) : UIColor.green.withAlphaComponent(0.3)
            } else {
                self.backgroundColor = isHighlighted ? UIColor.green.withAlphaComponent(0.1) : .clear
            }
        }
    }
}
