//
//  GradientLayerView.swift
//  Terning-iOS
//
//  Created by 김민성 on 8/23/24.
//

import UIKit

import SnapKit
import Then

final class GradientLayerView: UIView {
    
    // MARK: - Properties
    
    let colors: [CGColor] = [
        .init(red: 255, green: 255, blue: 255, alpha: 1),
        .init(red: 255, green: 255, blue: 255, alpha: 0)
        
    ]
    
    // MARK: - UIComponents
    
    let gradientLayer = CAGradientLayer()
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setGradientLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.frame = bounds
    }
    
    // MARK: - Private func
    
    private func setGradientLayer() {
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        layer.addSublayer(gradientLayer)
    }
}
