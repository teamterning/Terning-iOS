//
//  ProfileImageCell.swift
//  Terning-iOS
//
//  Created by 정민지 on 7/17/24.
//

import UIKit

import SnapKit
import Then

final class ProfileImageCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    override var isSelected: Bool {
        didSet {
            setUI()
        }
    }
    
    // MARK: - UI Components
    
    lazy var imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = (contentView.bounds.width - (2.67 * 2)) / 2
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierarchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension ProfileImageCell {
    private func setHierarchy() {
        contentView.addSubview(imageView)
    }
    
    private func setLayout() {
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(4.67)
        }
    }
}

// MARK: - Methods

extension ProfileImageCell {
    func setUI() {
        if self.isSelected {
            contentView.makeBorder(
                width: 2,
                color: .terningMain,
                cornerRadius: contentView.bounds.width / 2
            )
        } else {
            contentView.makeBorder(
                width: 0,
                color: .clear,
                cornerRadius: contentView.bounds.width / 2
            )
        }
    }
}
