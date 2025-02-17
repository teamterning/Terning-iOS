//
//  EventView.swift
//  Terning-iOS
//
//  Created by 이명진 on 8/26/24.
//

import UIKit

import SnapKit
import Then

final class EventView: UIView {
    
    // MARK: - Properties
    
    private let titleLabel = UILabel().then {
        $0.font = .button6
        $0.textColor = .white
        $0.textAlignment = .center
    }
    
    // MARK: - Life Cycles
    
    init() {
        super.init(frame: .zero)
        
        setUI()
        setHierarchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI & Layout
    
    private func setUI() {
        self.layer.cornerRadius = 2
    }
    
    private func setHierarchy() {
        self.addSubview(titleLabel)
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - Methods

    func bind(with event: CalendarEventProtocol) {
        backgroundColor = event.color
        titleLabel.text = event.title
    }
}
