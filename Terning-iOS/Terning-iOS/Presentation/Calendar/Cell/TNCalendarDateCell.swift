//
//  TNCalendarDateCell.swift
//  Terning-iOS
//
//  Created by 이명진 on 7/12/24.
//

import UIKit

import FSCalendar
import SnapKit
import Then

// 캘린더 이벤트 정보를 나타내는 프로토콜 (DI)

// MARK: - CalendarEventProtocol

protocol CalendarEventProtocol {
    var color: UIColor { get }
    var title: String { get }
}

// MARK: - CalendarEvent

struct CalendarEvent: CalendarEventProtocol {
    let color: UIColor
    let title: String
}

final class TNCalendarDateCell: FSCalendarCell {
    
    // MARK: - UIComponents

    let cellView = CalendarDateCellView()
    
    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)

        setHierarchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI & Layout
    
    private func setHierarchy() {
        contentView.addSubview(cellView)
    }
    
    private func setLayout() {
        cellView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - Methods
    
    func bind(with date: Date, textColor: UIColor, state: CalendarState, events: [CalendarEventProtocol]) {
        cellView.bind(date: date, textColor: textColor, state: state, events: events)
    }
}
