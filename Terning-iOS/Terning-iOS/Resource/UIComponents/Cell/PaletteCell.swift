//
//  PaletteCell.swift
//  Terning-iOS
//
//  Created by 이명진 on 7/8/24.
//

import UIKit

import SnapKit
import Then

final class PaletteCell: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let selectColorView: UIView = UIView().then {
        $0.layer.cornerRadius = 20
    }
    
    private let colorView: UIView = UIView().then {
        $0.layer.cornerRadius = 15
    }
    
    private let checkImageView: UIImageView = UIImageView().then {
        $0.image = UIImage(resource: .icCheck)
        $0.contentMode = .scaleAspectFit
        $0.isHidden = true
    }
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierarchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI & Layout
    
    private func setUI() {
        contentView.backgroundColor = .clear
    }
    
    private func setHierarchy() {
        contentView.addSubviews(selectColorView, colorView)
        colorView.addSubview(checkImageView)
    }
    
    private func setLayout() {
        
        selectColorView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        colorView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(29.adjusted)
        }
        
        checkImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(18.adjusted)
        }
    }
    
    // MARK: - Methods
    
    func configure(color: UIColor, isSelected: Bool) {
        colorView.backgroundColor = color
        selectColorView.backgroundColor = color.withAlphaComponent(0.5)
        checkImageView.isHidden = !isSelected
        selectColorView.isHidden = !isSelected
    }
}
