//
//  TNCalendarView.swift
//  Terning-iOS
//
//  Created by 이명진 on 7/11/24.
//

import UIKit

import FSCalendar
import SnapKit
import Then

enum CalendarViewType {
    case bottom, list
}

final class TNCalendarView: UIView {
    
    // MARK: - UIComponents
    
    let dummyView = UIView().then { $0.backgroundColor = .white }
    lazy var naviBar = CustomNavigationBar(type: .calendar)
    
    let calendarViewContainer = UIView().then {
        $0.layer.masksToBounds = true
        $0.backgroundColor = .white
    }
    
    let calendarView = FSCalendar().then {
        $0.scope = .month
        $0.backgroundColor = .white
        $0.headerHeight = 0
        $0.scrollEnabled = true
        $0.scrollDirection = .horizontal
        $0.weekdayHeight = 48
        $0.clipsToBounds = false
        
        $0.appearance.weekdayFont = .body7
        $0.appearance.titleFont = .body7
        $0.appearance.titlePlaceholderColor = .grey200
        $0.appearance.titleDefaultColor = .black
        
        let weekdayTexts = ["일", "월", "화", "수", "목", "금", "토"]
        let weekdayLabels = $0.calendarWeekdayView.weekdayLabels
        
        let insetSpacing = (35-18).adjusted
        let interSpacing = 38.2.adjusted
        
        for (index, label) in weekdayLabels.enumerated() {
            label.text = weekdayTexts[index]
            label.textColor = index == 0 ? .calRed : .black
            label.font = .body7
            
            label.snp.makeConstraints { make in
                if index == 0 {
                    make.leading.equalToSuperview().offset(insetSpacing)
                } else {
                    make.leading.equalTo(weekdayLabels[index - 1].snp.trailing).offset(interSpacing)
                }
                make.centerY.equalToSuperview()
            }
        }
        
        $0.placeholderType = .fillHeadTail
    }
    
    let separatorView = UIView().then { $0.backgroundColor = .grey200 }
    
    // 캘린더 주간 뷰
    lazy var calendarBottomCollectionView: UICollectionView = {
        let layout = CompositionalLayout.createCalendarBottomLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.backgroundColor = .white
        collectionView.isScrollEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isHidden = true
        return collectionView
    }()
    
    // 리스트 뷰
    lazy var calendarListCollectionView: UICollectionView = {
        let layout = CompositionalLayout.createCalendarListLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.backgroundColor = .back
        collectionView.isScrollEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isHidden = true
        return collectionView
    }()
    
    let bottomEmptyView = EmptyView()
    let listEmptyView = EmptyView()
    
    let notchView = UIView().then {
        $0.backgroundColor = .grey200
        $0.layer.cornerRadius = 2
        $0.isHidden = true
    }
    
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
}

// MARK: - UI & Layout

extension TNCalendarView {
    private func setUI() {
        backgroundColor = .back
    }
    
    private func setHierarchy() {
        addSubviews(
            naviBar,
            dummyView,
            separatorView,
            calendarViewContainer,
            calendarBottomCollectionView,
            calendarListCollectionView,
            bottomEmptyView,
            listEmptyView
        )
        calendarViewContainer.addSubview(calendarView)
        calendarViewContainer.addSubview(notchView)
        
        calendarBottomCollectionView.addSubview(bottomEmptyView)
        calendarListCollectionView.addSubview(listEmptyView)
        
    }
    
    private func setLayout() {
        naviBar.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(68.adjustedH)
        }
        
        dummyView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(naviBar.snp.top)
        }
        
        calendarViewContainer.snp.makeConstraints {
            $0.top.equalTo(naviBar.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
        }
        
        calendarView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.height.equalTo(90.adjustedH * 6 + 48.adjustedH + 28.adjustedH) // 기본 높이 설정
            $0.horizontalEdges.equalToSuperview().inset(18.adjusted)
        }
        
        separatorView.snp.makeConstraints {
            $0.top.equalTo(calendarView.calendarWeekdayView.snp.bottom)
            $0.width.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        notchView.snp.makeConstraints {
            $0.top.equalTo(separatorView.snp.bottom).offset(42.adjustedH)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(4.adjustedH)
            $0.width.equalTo(55.adjusted)
        }
        
        self.bringSubviewToFront(separatorView)
        
        calendarBottomCollectionView.snp.makeConstraints {
            $0.top.equalTo(calendarView.snp.bottom).offset(10.adjustedH)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
        
        calendarListCollectionView.snp.makeConstraints {
            $0.top.equalTo(naviBar.snp.bottom)
            $0.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
        
        bottomEmptyView.snp.makeConstraints {
            $0.top.equalTo(calendarBottomCollectionView.snp.top).offset(40.adjustedH)
            $0.centerX.equalToSuperview()
        }
        
        listEmptyView.snp.makeConstraints {
            $0.top.equalTo(calendarListCollectionView.snp.top).offset(120.adjustedH)
            $0.centerX.equalToSuperview()
        }
    }
}

// MARK: - Methods

extension TNCalendarView {
    // 주간일 때 라운딩 처리 메서드
    func roundCalendarViewCorners(radius: CGFloat) {
        calendarViewContainer.layer.cornerRadius = radius
        calendarViewContainer.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    func toggleEmptyView(for type: CalendarViewType, isHidden: Bool) {
        
        switch type {
        case .bottom:
            bottomEmptyView.isHidden = !isHidden
        case .list:
            listEmptyView.isHidden = !isHidden
        }
    }
}
