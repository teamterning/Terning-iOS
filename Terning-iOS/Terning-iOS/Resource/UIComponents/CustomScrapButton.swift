//
//  CustomScrapButton.swift
//  Terning-iOS
//
//  Created by 정민지 on 7/12/24.
//

import UIKit

class CustomScrapButton: UIButton {
    
    // MARK: - Properties
    
    private let selectedImage = UIImage(named: "ic_scrap_fill")
    private let deselectedImage = UIImage(named: "ic_scrap")
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension CustomScrapButton {
    private func  setUI() {
        self.setImage(deselectedImage, for: .normal)
        self.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
}

// MARK: - Methods

extension CustomScrapButton {
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
        self.isSelected.toggle()
        self.updateImage()
    }
}
