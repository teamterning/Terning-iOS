//
//  SortButtonCell.swift
//  Terning-iOS
//
//  Created by 김민성 on 7/10/24.
//

import UIKit

import SnapKit
import Then

class SortButtonCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static var sortButtonCellIdentifier = "SortButtonCell"
    
    // MARK: - UIComponents
    
    var sortButtonLabel = UILabel().then {
        $0.text = "채용 마감 이른 순"
        $0.textAlignment = .center
        $0.isUserInteractionEnabled = true
    }
    
    var sortButtonIcon = UIImageView().then {
        $0.image = UIImage(resource: .icDownArrow)
    }
    
//    lazy var buttonLabelStack = UIStackView(arrangedSubviews: [sortButtonLabel, sortButtonIcon]).then {
//        $0.axis = .horizontal
//        $0.spacing = 0
//    }
    
    
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

extension SortButtonCell {
    func setHierarchy() {
        contentView.addSubviews(
            sortButtonLabel,
            sortButtonIcon
//            buttonLabelStack
        )
    }
    
    func setLayout() {
//        buttonLabelStack.snp.makeConstraints {
//            $0.top.equalToSuperview().offset(64)
//            $0.leading.equalToSuperview().offset(214)
//        }
        
        sortButtonLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(240)
        }
        
        sortButtonIcon.snp.makeConstraints {
            $0.top.equalToSuperview().inset(1)
            $0.trailing.equalTo(sortButtonLabel.snp.trailing).offset(18 + 5)
            $0.width.height.equalTo(18)
        }
    }
}

