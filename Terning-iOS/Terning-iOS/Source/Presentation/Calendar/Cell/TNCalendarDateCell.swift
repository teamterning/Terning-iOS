//
//  TNCalendarDateCell.swift
//  Terning-iOS
//
//  Created by 이명진 on 7/12/24.
//

import UIKit

import SnapKit
import Then

import FSCalendar

enum CalendarState {
    case normal
    case selected
    case today
}

final class TNCalendarDateCell: FSCalendarCell {
    
    // MARK: - Properties
    
    private let selectView = UIView().then {
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 12
    }
    
    private let dateLabel = LabelFactory.build(
        text: "1",
        font: .calendar,
        textColor: .white,
        textAlignment: .center,
        lineSpacing: 1.0,
        characterSpacing: 0.002
    )
    
    private let separatorView = UIView().then { $0.backgroundColor = .grey200 }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierarchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI & Layout
    
    private func setUI() {
        contentView.backgroundColor = .white
//        contentView.layer.masksToBounds = true
    }
    
    private func setHierarchy() {
        contentView.addSubviews(selectView, dateLabel, separatorView)
    }
    
    private func setLayout() {
        
        selectView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(19)
            $0.width.height.equalTo(24)
        }
        
        dateLabel.snp.makeConstraints {
            $0.center.equalTo(selectView)
        }
        
        separatorView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.bottom.equalTo(contentView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
        }
    }
    
    // MARK: - Methods
    
    func bind(date: Date, textColor: UIColor, state: CalendarState) {
        
        switch state {
        case .today:
            selectView.backgroundColor = .terningMain
            selectView.isHidden = false
            dateLabel.textColor = .white
        case .normal:
            selectView.isHidden = true
            dateLabel.textColor = .black
        case .selected:
            selectView.backgroundColor = .grey200
            selectView.isHidden = false
            dateLabel.textColor = .black
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        
        dateLabel.text = formatter.string(from: date)
        dateLabel.textColor = textColor
    }
}
