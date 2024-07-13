//
//  CalendarDateHeaderView.swift
//  Terning-iOS
//
//  Created by 이명진 on 7/13/24.
//

import UIKit

import SnapKit
import Then

final class CalendarDateHeaderView: UICollectionReusableView {
    
    // MARK: - UIComponents
    
    private let titleLabel = LabelFactory.build(
        text: "7월 26일 금요일",
        font: .title5,
        textColor: .black,
        lineSpacing: 1.2,
        characterSpacing: 0.02
    )
    
    // MARK: - Life Cycles
    
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

extension CalendarDateHeaderView {
    private func setUI() {
        backgroundColor = .clear
    }
    
    private func setHierarchy() {
        addSubview(titleLabel)
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview()
        }
    }
}

// MARK: - bind

extension CalendarDateHeaderView {
    func bind(title: String) {
        self.titleLabel.text = title
    }
}
