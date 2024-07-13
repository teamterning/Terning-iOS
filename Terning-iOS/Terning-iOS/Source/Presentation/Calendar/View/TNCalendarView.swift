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
        $0.appearance.weekdayFont = .body7
        $0.appearance.titleFont = .body7
        $0.scrollEnabled = true
        $0.scrollDirection = .horizontal
        $0.weekdayHeight = 48
        $0.clipsToBounds = false
        $0.appearance.titlePlaceholderColor = .grey200
        $0.appearance.titleDefaultColor = .black
        
        let weekdayTexts = ["일", "월", "화", "수", "목", "금", "토"]
        $0.calendarWeekdayView.weekdayLabels.enumerated().forEach { (index, label) in
            label.text = weekdayTexts[index]
            label.textColor = index == 0 ? .calRed : .black
        }
        $0.placeholderType = .fillHeadTail
    }
    
    let separatorView = UIView().then { $0.backgroundColor = .grey200 }
    
    // 캘린더 주간 뷰
    lazy var calenderBottomCollectionView: UICollectionView = {
        let layout = CompositionalLayout.createCalendarBottomLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.isScrollEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isHidden = true
        return collectionView
    }()
    
    // 리스트 뷰
    lazy var calenderListCollectionView: UICollectionView = {
        let layout = CompositionalLayout.createCalendarBottomLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .back
        collectionView.isScrollEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isHidden = true
        return collectionView
    }()
    
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
    
    // 주간일 때 라운딩 처리 메서드
    func roundCalendarViewCorners(radius: CGFloat) {
        calendarViewContainer.layer.cornerRadius = radius
        calendarViewContainer.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
}

// MARK: - UI & Layout

extension TNCalendarView {
    private func setUI() {
        backgroundColor = .back
    }
    
    private func setHierarchy() {
        addSubviews(
            dummyView,
            naviBar,
            separatorView,
            calendarViewContainer,
            calenderBottomCollectionView,
            calenderListCollectionView
        )
        calendarViewContainer.addSubview(calendarView)
    }
    
    private func setLayout() {
        naviBar.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(68)
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
            $0.edges.equalToSuperview()
            $0.height.equalTo(90 * 6 + 48 + 28) // 기본 높이 설정
        }
        
        separatorView.snp.makeConstraints {
            $0.top.equalTo(calendarView.calendarWeekdayView.snp.bottom)
            $0.width.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        self.bringSubviewToFront(separatorView)
        
        calenderBottomCollectionView.snp.makeConstraints {
            $0.top.equalTo(calendarView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
        
        calenderListCollectionView.snp.makeConstraints {
            $0.top.equalTo(naviBar.snp.bottom)
            $0.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}
