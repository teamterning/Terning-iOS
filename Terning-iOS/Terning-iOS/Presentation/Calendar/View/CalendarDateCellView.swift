//
//  CalendarDateCellView.swift
//  Terning-iOS
//
//  Created by 이명진 on 8/26/24.
//

import UIKit

import SnapKit
import Then

@frozen
public enum CalendarState {
    case normal
    case selected
    case today
}

// 각 날짜 Cell의 UI를 담당하는 뷰
final class CalendarDateCellView: UIView {
    
    // MARK: - Properties
    
    private let displayedEventCount: Int = 3
    
    // MARK: - UIComponents
    
    private let selectView = UIView().then {
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
    
    private let eventStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.alignment = .fill
        $0.spacing = 2
    }
    
    private let remainJobCountLabel = LabelFactory.build(
        text: "",
        font: .detail5,
        textAlignment: .right,
        lineSpacing: 1.0,
        characterSpacing: 0.002
    )
    
    private let separatorView = UIView().then { $0.backgroundColor = .grey200 }
    
    private var eventViews: [EventView] = []
    
    // MARK: - Init
    
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
        backgroundColor = .white
    }
    
    private func setHierarchy() {
        addSubviews(
            selectView,
            dateLabel,
            eventStackView,
            separatorView,
            remainJobCountLabel
        )
    }
    
    private func setLayout() {
        separatorView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(-15)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        selectView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(6)
            $0.width.height.equalTo(24)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.centerX.equalTo(selectView)
        }
        
        eventStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(selectView.snp.bottom).offset(3)
            $0.width.equalToSuperview().inset(5)
        }
        
        remainJobCountLabel.snp.makeConstraints {
            $0.top.equalTo(eventStackView.snp.bottom).offset(2.adjustedH)
            $0.trailing.equalTo(eventStackView.snp.trailing)
        }
    }
    
    // MARK: - Methods
    
    func bind(date: Date, textColor: UIColor, state: CalendarState, events: [CalendarEventProtocol]) {
        updateState(state)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        dateLabel.text = formatter.string(from: date)
        dateLabel.textColor = textColor
        
        updateEvents(events)
    }
    
    private func updateState(_ state: CalendarState) {
        switch state {
        case .today:
            selectView.backgroundColor = .grey150
            selectView.isHidden = false
            dateLabel.textColor = .white
        case .normal:
            selectView.isHidden = true
            dateLabel.textColor = .black
        case .selected:
            selectView.backgroundColor = .terningMain
            selectView.isHidden = false
            dateLabel.textColor = .white
        }
    }
    
    private func updateEvents(_ events: [CalendarEventProtocol]) {
        // 기존 이벤트 뷰를 모두 제거
        eventViews.forEach { $0.removeFromSuperview() }
        eventViews = []
        
        let remainingEventsCount = events.count - displayedEventCount
        
        // 남은 이벤트 수가 1보다 클 경우에만 remainJobCountLabel 표시
        if remainingEventsCount > 0 {
            remainJobCountLabel.text = "+\(remainingEventsCount)"
            remainJobCountLabel.isHidden = false
        } else {
            remainJobCountLabel.isHidden = true
        }
        
        for event in events.prefix(displayedEventCount) { // 최대 N 개의 이벤트만 표시
            let eventView = EventView()
            eventView.bind(with: event)
            eventStackView.addArrangedSubview(eventView)
            eventViews.append(eventView)
        }
        
        eventViews.forEach {
            $0.snp.makeConstraints { make in
                make.height.equalTo(12)
            }
        }
    }
    
    func setViewMode(isWeekView: Bool) {
        eventStackView.isHidden = isWeekView
    }
}
