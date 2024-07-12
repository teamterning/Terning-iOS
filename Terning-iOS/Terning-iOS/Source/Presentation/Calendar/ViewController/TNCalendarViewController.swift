//
//  TNCalendarViewController.swift
//  Terning-iOS
//
//  Created by 이명진 on 7/11/24.
//

import UIKit

import RxSwift
import RxCocoa

import SnapKit
import Then

import FSCalendar

final class TNCalendarViewController: UIViewController {
    
    // MARK: - UIComponents
    
    private let rootView = TNCalendarView()
    private let disposeBag = DisposeBag()
    private var selectedDate: Date?
    private var scraps: [Date: [Scrap]] = [:] // 스크랩 데이터를 저장할 딕셔너리
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegate()
        setRegister()
        bindNavigation()
        bindViewModel()
        updateNaviBarTitle(for: rootView.calendarView.currentPage)
        loadDummyData() // 더미 데이터 로드
    }
    
    override func loadView() {
        self.view = rootView
    }
    
    // MARK: - UI & Layout
    
    private func setDelegate() {
        rootView.calendarView.delegate = self
        rootView.calendarView.dataSource = self
        // rootView.calendarView.adjustsBoundingRectWhenChangingMonths = true
    }
    
    private func setRegister() {
        rootView.calendarView.register(TNCalendarDateCell.self, forCellReuseIdentifier: TNCalendarDateCell.className)
    }
    
    private func bindNavigation() {
        rootView.naviBar.calendarBackButtonDidTap
            .subscribe(with: self) { owner, _ in
                owner.moveCalendar(by: -1)
            }.disposed(by: disposeBag)
        
        rootView.naviBar.calendarFrontButtonDidTap
            .subscribe(with: self) { owner, _ in
                owner.moveCalendar(by: 1)
            }.disposed(by: disposeBag)
        
        rootView.naviBar.calendarListButtonDidTap
            .subscribe(with: self) { owner, _ in
                print("리스트 뷰 선택")
            }.disposed(by: disposeBag)
    }
    
    private func bindViewModel() {}
    
    private func moveCalendar(by months: Int) {
        let currentPage = rootView.calendarView.currentPage
        
        let newDate = Calendar.current.date(byAdding: .month, value: months, to: currentPage) ?? currentPage
        rootView.calendarView.setCurrentPage(newDate, animated: true)
        updateNaviBarTitle(for: newDate)
    }
    
    private func updateNaviBarTitle(for date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월"
        let dateString = formatter.string(from: date)
        rootView.naviBar.setTitle(dateString)
    }
    
    private func loadDummyData() {
        let dummyData = createDummyData()
        for item in dummyData.scrapsByDeadline {
            if let date = dateFormatter.date(from: item.deadline) {
                scraps[date] = item.scraps
            }
        }
        rootView.calendarView.reloadData()
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}

extension TNCalendarViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        updateNaviBarTitle(for: calendar.currentPage)
        calendar.reloadData()
    }
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        guard let cell = calendar.dequeueReusableCell(withIdentifier: TNCalendarDateCell.className, for: date, at: position) as? TNCalendarDateCell else { return FSCalendarCell() }
        
        let month = calendar.currentPage
        let isCurrentMonth = Calendar.current.isDate(date, equalTo: month, toGranularity: .month)
        
        let dateStatus: CalendarState = {
            if Calendar.current.isDateInToday(date) {
                return .today
            } else if let selectedDate = selectedDate, Calendar.current.isDate(date, inSameDayAs: selectedDate) {
                return .selected
            } else {
                return .normal
            }
        }()
        
        let eventCount = scraps[date]?.count ?? 0
        
        cell.bind(date: date, textColor: isCurrentMonth ? .black : .grey200, state: dateStatus, eventCount: eventCount)
        
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        return .clear
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, subtitleDefaultColorFor date: Date) -> UIColor? {
        return .clear // 서브타이틀 숨김
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleSelectionColorFor date: Date) -> UIColor? {
        return .clear // 선택된 날짜 숫자를 숨김
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, subtitleSelectionColorFor date: Date) -> UIColor? {
        return .clear // 선택된 날짜의 서브타이틀 숨김
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        return .clear // 선택된 날짜의 배경색 숨김
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        return .clear // 기본 배경색 숨김
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return 0 // Dot 반환하지 않음 (셀에서 처리!)
    }
    
    // 주간일때 그림자와 라운드 넣어주는 함수
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        if calendar.scope == .week {
            rootView.calendarView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            rootView.calendarView.layer.cornerRadius = 20
            rootView.calendarView.layer.applyShadow(alpha: 0.1, y: 2, blur: 4)
            
            rootView.calendarView.snp.updateConstraints { make in
                make.height.equalTo(90 + 20) // 주간 뷰 높이 설정
            }
        } else {
            rootView.calendarView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            rootView.calendarView.layer.cornerRadius = 0
            rootView.calendarView.layer.shadowOpacity = 0
            
            rootView.calendarView.snp.updateConstraints { make in
                let weekCount = calculateWeekCount(for: calendar.currentPage)
                let cellHeight = weekCount == 6 ? 90 : 106
                make.height.equalTo(cellHeight * weekCount)
            }
        }
        
        updateNaviBarTitle(for: calendar.currentPage)
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
    /// 현재 활성화된 주가 6주 인지 5주인지 세어 주는 함수
    private func calculateWeekCount(for date: Date) -> Int {
        let calendar = Calendar.current
        let range = calendar.range(of: .weekOfMonth, in: .month, for: date)!
        return range.count
    }
    
    // 해당 날짜 선택하면 작동되는 함수
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if selectedDate == date {
            calendar.setScope(.month, animated: true)
            selectedDate = nil
        } else {
            selectedDate = date
            calendar.setScope(.week, animated: true)
        }
        calendar.reloadData()
    }
}
