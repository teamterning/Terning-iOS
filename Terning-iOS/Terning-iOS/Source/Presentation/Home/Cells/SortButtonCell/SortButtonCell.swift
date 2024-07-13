//
//  SortButtonCell.swift
//  Terning-iOS
//
//  Created by 김민성 on 7/10/24.
//

import UIKit

import SnapKit
import Then

protocol SortButtonTappedProtocol {
    func pushToBottomSheet()
}

// 명진이형이 일단 냅두라해서 냅둠

class SortButtonCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var sortButtonDelegate: SortButtonTappedProtocol?

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
    
    lazy var sortButtonStack = UIStackView(arrangedSubviews: [sortButtonLabel, sortButtonIcon]).then {
        $0.axis = .horizontal
        $0.spacing = 4
        $0.alignment = .center
    }
    
    // MARK: - LifeCycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setHierarchy()
        setLayout()
        setTapGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension SortButtonCell {
    func setHierarchy() {
        contentView.addSubviews(
            sortButtonStack
        )
    }
    
    func setLayout() {
        sortButtonStack.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(245)
        }
    }
    
    // MARK: - Method
    
    func setTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(sortButtonTapped))
        sortButtonStack.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - objc Function
    
    @objc
    func sortButtonTapped() {
        sortButtonDelegate?.pushToBottomSheet()
    }
}
