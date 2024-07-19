//
//  SortInfoCell.swift
//  Terning-iOS
//
//  Created by 이명진 on 7/19/24.
//

import UIKit

import SnapKit
import Then

final class SortInfoCell: UICollectionViewCell {
    
    // MARK: - UIComponents
    
    // 정렬 버튼
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
    
    lazy var sortButtonStack = UIStackView(
        arrangedSubviews: [
            sortButtonLabel,
            sortButtonIcon
        ]
    ).then {
        $0.axis = .horizontal
        $0.spacing = 4
        $0.alignment = .center
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

extension SortInfoCell {
    func setHierarchy() {
        addSubview(sortButtonStack)
    }
    
    func setLayout() {
        sortButtonStack.snp.makeConstraints {
            $0.top.equalToSuperview().offset(4)
            $0.leading.equalToSuperview().offset(233.adjusted)
        }
    }
}
