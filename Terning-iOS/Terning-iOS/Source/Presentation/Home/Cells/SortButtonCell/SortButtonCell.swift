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

    // MARK: - UIComponents
    
    var sortButtonLabel = LabelFactory.build(
        text: "채용 마감 이른 순",
        font: .button3,
        textColor: .terningBlack,
        textAlignment: .center
    ).then {
        $0.isUserInteractionEnabled = true
    }
    
    var sortButtonIcon = UIImageView().then {
        $0.image = UIImage(resource: .icDownArrow)
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

extension SortButtonCell {
    func setHierarchy() {
        contentView.addSubviews(
            sortButtonLabel,
            sortButtonIcon
        )
    }
    
    func setLayout() {
        sortButtonLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(240)
        }
        
        sortButtonIcon.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(sortButtonLabel.snp.trailing).offset(18 + 5)
            $0.width.height.equalTo(18)
        }
    }
}
