//
//  AdvertisementCollectionViewCell.swift
//  Terning-iOS
//
//  Created by 정민지 on 7/14/24.
//

import UIKit

import SnapKit
import Then

final class AdvertisementCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let advertisementImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.masksToBounds = true
    }
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.setUI()
        self.setHierarchy()
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension AdvertisementCollectionViewCell {
    private func setUI() {
        self.backgroundColor = .grey200
    }
    
    private func setHierarchy() {
        self.addSubview(advertisementImageView)
    }
    
    private func setLayout() {
        advertisementImageView .snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

// MARK: - Bind

extension AdvertisementCollectionViewCell {
    func bind(with advertisement: UIImage) {
            advertisementImageView.image = advertisement
    }
}
