//
//  TNCalendarView.swift
//  Terning-iOS
//
//  Created by 이명진 on 7/11/24.
//

import UIKit

final class TNCalendarView: UIView {
    
    // MARK: - UIComponents
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierarchy()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI & Layout
    
    private func setUI() {
        backgroundColor = .white
    }
    
    private func setHierarchy() {
        
    }
    
    private func setLayout() {
        
    }
    
}
