//
//  DecorationCell.swift
//  Terning-iOS
//
//  Created by 김민성 on 7/10/24.
//

import UIKit

import SnapKit
import Then

class DecorationCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static var DecorationCellIdentifier = "DecorationCell"
    
    // MARK: - UIComponents
    
    let decorationView = UIView().then {
        $0.backgroundColor = .grey150
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

// MARK: - Extensions

extension DecorationCell {
    func setHierarchy() {
        contentView.addSubviews(decorationView)
    }
    
    func setLayout() {
        decorationView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(4)
        }

    }
}

