//
//  CustomScrapButton.swift
//  Terning-iOS
//
//  Created by 정민지 on 7/12/24.
//

import UIKit

final class CustomScrapButton: UIButton {
    
    // MARK: - Properties
    
    

    private let selectedImage = UIImage(named: "ic_scrap_fill")
    private let deselectedImage = UIImage(named: "ic_scrap")
    
    private let scrapImage = UIButton(type: .custom).then {
        $0.setImage(.icScrap, for: .normal)
        $0.setImage(.icScrapFill, for: .selected)
    }
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setButtonAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension CustomScrapButton {
    private func setUI() {
        self.setImage(deselectedImage, for: .normal)
    }
}

// MARK: - Methods

extension CustomScrapButton {
    private func setButtonAction() {
        self.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    
    func updateImage() {
        if self.isSelected {
            self.setImage(selectedImage, for: .normal)
        } else {
            self.setImage(deselectedImage, for: .normal)
        }
    }
}

// MARK: - @objc func

extension CustomScrapButton {
    @objc
    private func buttonTapped() {
        
    }
}
