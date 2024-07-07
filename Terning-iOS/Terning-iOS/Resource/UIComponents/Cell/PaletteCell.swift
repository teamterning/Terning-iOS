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
    
    private let colorView: UIView = UIView().then {
        $0.layer.cornerRadius = 20
    }
    
    private let checkImageView: UIImageView = UIImageView().then {
        $0.image = UIImage(resource: .icCheck)
        $0.contentMode = .scaleAspectFit
        $0.isHidden = true
    }
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
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
        contentView.addSubview(colorView)
        colorView.addSubview(checkImageView)
    }
    
    private func setLayout() {
        colorView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        checkImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(24)
        }
    }
    
    // MARK: - Methods
    
    func configure(color: UIColor, isSelected: Bool) {
        colorView.backgroundColor = color
        checkImageView.isHidden = !isSelected
    }
}
