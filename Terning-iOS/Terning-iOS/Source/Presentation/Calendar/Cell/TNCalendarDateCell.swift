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
    
    private let dotStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.alignment = .center
        $0.spacing = 2
    }

    private let dotViews: [UIView] = (0..<3).map { _ in
        UIView().then {
            $0.backgroundColor = .red
            $0.layer.cornerRadius = 3
            $0.snp.makeConstraints {
                $0.width.height.equalTo(6)
            }
        }
    }
    
    private let separatorView = UIView().then { $0.backgroundColor = .grey200 }
    
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
    
extension TNCalendarDateCell {
    // MARK: - UI & Layout
    
    private func setUI() {
        contentView.backgroundColor = .white
    }
    
    private func setHierarchy() {
        contentView.addSubviews(
            selectView,
            dateLabel,
            dotStackView,
            separatorView
        )
        dotViews.forEach { dotStackView.addArrangedSubview($0) }
    }
    
    private func setLayout() {
        
        separatorView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(-15)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        selectView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(7)
            $0.width.height.equalTo(24)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.centerX.equalTo(selectView)
        }
        
        dotStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(selectView.snp.bottom).offset(3)
            $0.height.equalTo(6)
        }
    }
}
extension TNCalendarDateCell {
    
    // MARK: - bind
    
    func bind(date: Date, textColor: UIColor, state: CalendarState, eventCount: Int, dotColors: [String]) {
        
        switch state {
        case .today:
            selectView.backgroundColor = .grey200
            selectView.isHidden = false
            dateLabel.textColor = .white
        case .normal:
            selectView.isHidden = true
            dateLabel.textColor = .black
        case .selected:
            selectView.backgroundColor = .terningMain
            selectView.isHidden = false
            dateLabel.textColor = .black
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        
        dateLabel.text = formatter.string(from: date)
        dateLabel.textColor = textColor
        
        for (index, dotView) in dotViews.enumerated() {
            if index < eventCount {
                dotView.isHidden = false
                dotView.backgroundColor = UIColor(hex: dotColors[index])
            } else {
                dotView.isHidden = true
            }
        }
    }
}
