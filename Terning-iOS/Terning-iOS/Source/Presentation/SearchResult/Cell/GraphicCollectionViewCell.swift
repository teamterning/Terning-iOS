//
//  GraphicCollectionViewCell.swift
//  Terning-iOS
//
//  Created by 정민지 on 7/18/24.
//

import UIKit

import SnapKit

final class GraphicCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let imageView = UIImageView().then {
        $0.image = .imgSearch
        $0.contentMode = .scaleAspectFill
        $0.layer.masksToBounds = true
    }
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.setHierarchy()
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension GraphicCollectionViewCell {
    private func setHierarchy() {
        contentView.addSubview(imageView)
    }
    
    private func setLayout() {
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
