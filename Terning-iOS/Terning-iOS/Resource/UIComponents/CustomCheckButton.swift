//
//  CustomCheckButton.swift
//  Terning-iOS
//
//  Created by 정민지 on 12/17/24.
//

import UIKit

import SnapKit
import Then

final class CustomCheckButton: UIView {
    
    // MARK: - Properties
    
    private var title: String?
    
    private var isChecked: Bool = false {
        didSet { updateAppearance() }
    }
    
    var action: ((Bool) -> Void)?
    
    // MARK: - UI Components
    
    private let checkImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = .icCheckbox
    }
    
    private let titleLabel = LabelFactory.build(
        font: .button4,
        textColor: .grey300
    )

    // MARK: - Init
    
    init(title: String? = nil) {
        super.init(frame: .zero)
        self.title = title
        
        setUI()
        setLayout()
        setAddTarget()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
    
// MARK: - UI & Layout

extension CustomCheckButton {
    private func setUI() {
        addSubview(checkImageView)
        if let title = title {
            titleLabel.text = title
            addSubview(titleLabel)
        }
    }
    
    private func setLayout() {
        checkImageView.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
            $0.size.equalTo(18)
        }
        
        if title != nil {
            titleLabel.snp.makeConstraints {
                $0.leading.equalTo(checkImageView.snp.trailing).offset(6)
                $0.trailing.equalToSuperview()
                $0.centerY.equalToSuperview()
            }
        }
    }
    
    private func updateAppearance() {
        if isChecked {
            checkImageView.image = .icCheckboxFill
        } else {
            checkImageView.image = .icCheckbox
        }
    }
}

// MARK: - Methods

extension CustomCheckButton {
    private func setAddTarget() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleCheckState))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapGesture)
    }

    @objc
    private func toggleCheckState() {
        isChecked.toggle()
        action?(isChecked)
    }
}

// MARK: - Public Method

extension CustomCheckButton {
    func setChecked(_ checked: Bool) {
        isChecked = checked
        action?(isChecked)
    }
}
