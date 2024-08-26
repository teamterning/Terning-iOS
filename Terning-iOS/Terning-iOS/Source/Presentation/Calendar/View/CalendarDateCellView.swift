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
enum CalendarState {
    case normal
    case selected
    case today
}

// Cell의 UI를 담당하는 뷰 클래스
final class CalendarDateCellView: UIView {
    
    // MARK: - Properties
    
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
            separatorView
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
            $0.top.equalToSuperview().offset(7)
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
    }
    
    private func updateEvents(_ events: [CalendarEventProtocol]) {
        // 기존 이벤트 뷰를 모두 제거
        eventViews.forEach { $0.removeFromSuperview() }
        eventViews = []
        
        for event in events.prefix(3) { // 최대 3개의 이벤트만 표시
            let eventView = EventView()
            eventView.bind(with: event)
            eventStackView.addArrangedSubview(eventView)
            eventViews.append(eventView)
        }
    }
}
