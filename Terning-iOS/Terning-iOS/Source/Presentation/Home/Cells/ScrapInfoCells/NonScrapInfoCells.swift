//
//  NotScrapInfoCells.swift
//  Terning-iOS
//
//  Created by 김민성 on 7/10/24.
//

import UIKit

import SnapKit
import Then

final class NonScrapInfoCell: UICollectionViewCell {
    
    // MARK: - UIComponents
    
    private let notScrapInfoImageView = UIImageView().then {
        $0.image = .imgNotAnouncement
    }
    // MARK: - LifeCycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setHierarchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension NonScrapInfoCell {
    private func setHierarchy() {
        contentView.addSubview(notScrapInfoImageView)
    }
    
    private func setLayout() {
        notScrapInfoImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
    }
}
