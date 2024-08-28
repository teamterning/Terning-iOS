//
//  CalendarDateFooterView.swift
//  Terning-iOS
//
//  Created by 이명진 on 7/14/24.
//

import UIKit

import SnapKit
import Then

final class CalendarDateFooterView: UICollectionReusableView {
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension CalendarDateFooterView {
    private func setUI() {
        backgroundColor = .grey200
    }
}
