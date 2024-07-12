//
//  TNCalendarView.swift
//  Terning-iOS
//
//  Created by 이명진 on 7/11/24.
//

import UIKit

import SnapKit
import Then

import FSCalendar

final class TNCalendarView: UIView {
    
    // MARK: - UIComponents
    
    lazy var naviBar = CustomNavigationBar(type: .calendar)
    private let scrollView = UIScrollView()
    private let contentView = UIView().then { $0.backgroundColor = .white }
    
    let calendarView = FSCalendar().then {
        $0.scope = .month
        $0.backgroundColor = .white
        $0.headerHeight = 0
        $0.appearance.weekdayFont = .body7
        $0.appearance.titleFont = .body7
        $0.scrollEnabled = true
        $0.scrollDirection = .horizontal
        $0.appearance.headerMinimumDissolvedAlpha = 0.0
        $0.appearance.headerTitleColor = .white
        $0.weekdayHeight = 48
        
        $0.clipsToBounds = false
        
        // 달에 유효하지 않은 날짜의 색 지정
        $0.appearance.titlePlaceholderColor = .grey200
        // 평일 날짜 색
        $0.appearance.titleDefaultColor = .black
        
        let weekdayTexts = ["일", "월", "화", "수", "목", "금", "토"]
        $0.calendarWeekdayView.weekdayLabels.enumerated().forEach { (index, label) in
            label.text = weekdayTexts[index]
            label.textColor = index == 0 ? .calRed : .black
        }
        
        $0.placeholderType = .fillHeadTail
    }
    
    private let separatorView = UIView().then { $0.backgroundColor = .grey200 }
    
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
        addSubviews(
            naviBar,
            scrollView,
            separatorView
        )
        scrollView.addSubview(contentView)
        contentView.addSubviews(calendarView)
    }
    
    private func setLayout() {
        naviBar.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(68)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(naviBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.centerX.top.bottom.equalToSuperview()
            $0.height.equalTo(1300)
        }
        
        calendarView.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top).offset(10)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(90 * 6 + 48) // 기본 높이 설정
        }
        
        separatorView.snp.makeConstraints {
            $0.top.equalTo(calendarView.calendarWeekdayView.snp.bottom)
            $0.width.equalToSuperview()
            $0.height.equalTo(1)
        }
        
    }
}
