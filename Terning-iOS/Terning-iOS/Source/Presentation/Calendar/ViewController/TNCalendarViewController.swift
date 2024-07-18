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
    
    // MARK: - Properties
    
    private let calendarProvider = Providers.calendarProvider
    private var isListViewVisible = false
    
    private let dateFormatter = DateFormatter().then {
        $0.dateFormat = "yyyy-MM-dd"
    }
    
    // MARK: - UIComponents
    
    private let rootView = TNCalendarView()
    private let disposeBag = DisposeBag()
    private var selectedDate: Date?
    private var scraps: [Date: [DailyScrapModel]] = [:] // 스크랩 데이터를 저장할 딕셔너리
    private var scrapLists: [Date: [DailyScrapModel]] = [:] // 리스트 데이터를 저장할 딕셔너리
    
    private var isListData: Bool = false
    private var calendarDaily: [DailyScrapModel] = [] // 일간 캘린더 데이터를 저장할 딕셔너리
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegate()
        setRegister()
        bindNavigation()
        //        bindViewModel()
        updateNaviBarTitle(for: rootView.calendarView.currentPage)
        fetchMonthData(for: rootView.calendarView.currentPage)
    }
    
    override func loadView() {
        self.view = rootView
    }
}

// MARK: - Method

extension TNCalendarViewController {
    
    private func setDelegate() {
        rootView.calendarView.delegate = self
        rootView.calendarView.dataSource = self
        
        rootView.calenderBottomCollectionView.delegate = self
        rootView.calenderBottomCollectionView.dataSource = self
        
        rootView.calenderListCollectionView.delegate = self
        rootView.calenderListCollectionView.dataSource = self
    }
    
    private func setRegister() {
        rootView.calendarView.register(TNCalendarDateCell.self, forCellReuseIdentifier: TNCalendarDateCell.className)
        
        rootView.calenderBottomCollectionView.register(JobListingCell.self, forCellWithReuseIdentifier: JobListingCell.className)
        rootView.calenderBottomCollectionView.register(CalendarDateHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CalendarDateHeaderView.className)
        
        rootView.calenderListCollectionView.register(JobListingCell.self, forCellWithReuseIdentifier: JobListingCell.className)
        rootView.calenderListCollectionView.register(CalendarDateHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CalendarDateHeaderView.className)
        rootView.calenderListCollectionView.register(CalendarDateFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: CalendarDateFooterView.className)
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
                owner.toggleListView()
            }.disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        
    }
    
    private func moveCalendar(by months: Int) {
        let currentPage = rootView.calendarView.currentPage
        
        let newDate = Calendar.current.date(byAdding: .month, value: months, to: currentPage) ?? currentPage
        rootView.calendarView.setCurrentPage(newDate, animated: true)
        updateNaviBarTitle(for: newDate)
        
        fetchMonthData(for: newDate)
    }
    
    private func updateNaviBarTitle(for date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월"
        let dateString = formatter.string(from: date)
        rootView.naviBar.setTitle(dateString)
    }
    
    private func toggleListView() {
        if isListViewVisible {
            // 리스트 뷰를 감추고 기존 뷰를 보이게 함
            rootView.separatorView.isHidden = false
            rootView.calendarViewContainer.isHidden = false
            rootView.calenderListCollectionView.isHidden = true
        } else {
            // 기존 뷰를 감추고 리스트 뷰를 보이게 함
            rootView.separatorView.isHidden = true
            rootView.calendarViewContainer.isHidden = true
            rootView.calenderListCollectionView.isHidden = false
            //            if !isListData {
            //                getMonthlyList() // 리스트 뷰를 처음 표시할 때 서버 통신 한번으로 제한
            //                isListData = true
            //            }
            getMonthlyList()
        }
        isListViewVisible.toggle()
    }
    
    /// 현재 활성화된 주가 6주 인지 5주인지 세어 주는 함수
    private func calculateWeekCount(for date: Date) -> Int {
        let calendar = Calendar.current
        let range = calendar.range(of: .weekOfMonth, in: .month, for: date)!
        return range.count
    }
}

// MARK: - FSCalendarDelegate

extension TNCalendarViewController: FSCalendarDelegate {
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return monthPosition == .current // 현재 월이 아닌 날짜는 선택되지 않도록 설정
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        updateNaviBarTitle(for: calendar.currentPage)
        fetchMonthData(for: calendar.currentPage)
        calendar.reloadData()
    }
    
    // 해당 날짜 선택하면 작동되는 함수
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if selectedDate == date {
            calendar.setScope(.month, animated: true)
            selectedDate = nil
        } else {
            selectedDate = date
            calendar.setScope(.week, animated: true)
            updateBottomCollectionViewHeader(for: date) // 선택된 날짜로 헤더 업데이트
            fetchDailyData(for: date)
        }
        calendar.reloadData()
    }
    
    // 주간일때 그림자와 라운드 넣어주는 함수
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        if calendar.scope == .week {
            
            rootView.calenderBottomCollectionView.backgroundColor = .back
            rootView.roundCalendarViewCorners(radius: 20) // 라운드 처리 해주기
            rootView.layer.applyShadow(alpha: 0.1, y: 2, blur: 4)
            
            rootView.calendarView.snp.updateConstraints { make in
                make.height.equalTo(90 + 20) // 주간 뷰 높이 설정
            }
            rootView.calenderBottomCollectionView.isHidden = false
            
        } else {
            rootView.roundCalendarViewCorners(radius: 0)  // 라운드 처리 풀어 주기
            rootView.layer.shadowOpacity = 0
            
            rootView.calendarView.snp.updateConstraints {
                let weekCount = calculateWeekCount(for: calendar.currentPage)
                print(weekCount)
                let cellHeight = weekCount == 6 ? 90 : 106
                let addHeight = weekCount == 6 ? 28 : 39 // 캘린더 주에 맞는 추가 높이 설정
                
                let point = cellHeight * weekCount + 48 + addHeight
                $0.height.equalTo(point.adjustedH)
            }
            
            rootView.calenderBottomCollectionView.isHidden = true
            rootView.calenderBottomCollectionView.backgroundColor = .white
        }
        
        updateNaviBarTitle(for: calendar.currentPage)
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
}

extension TNCalendarViewController {
    private func updateBottomCollectionViewHeader(for date: Date) {
        // 선택된 날짜를 헤더에 표시하기 위한 코드
        let headerIndexPath = IndexPath(item: 0, section: 0)
        if let header = rootView.calenderBottomCollectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: headerIndexPath) as? CalendarDateHeaderView {
            let formattedDate = dateFormatter.string(from: date)
            header.bind(title: formattedDate)
        }
    }
}

// MARK: - FSCalendarDataSource

extension TNCalendarViewController: FSCalendarDataSource {
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
        let dotColors = scraps[date]?.map { $0.color } ?? []
        
        cell.bind(date: date, textColor: isCurrentMonth ? .black : .grey200, state: dateStatus, eventCount: eventCount, dotColors: dotColors)
        
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return 0 // Dot 반환하지 않음 (셀에서 처리!)
    }
}

// MARK: - FSCalendarAppearance

extension TNCalendarViewController: FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        return .clear // 기본 title 숨김
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
}


extension TNCalendarViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let jobDetailViewController = JobDetailViewController()
        
        if collectionView == rootView.calenderBottomCollectionView {
            guard let index = calendarDaily[indexPath.row].internshipAnnouncementId else { return }
            jobDetailViewController.internshipAnnouncementId.onNext(index)
        } else {
            let date = Array(scrapLists.keys)[indexPath.section]
            guard let scrapSection = scrapLists[date] else { return }
            guard let index = scrapSection[indexPath.row].internshipAnnouncementId else { return }
            jobDetailViewController.internshipAnnouncementId.onNext(index)
        }
        
        self.navigationController?.pushViewController(jobDetailViewController, animated: true)
    }
}


// MARK: - UICollectionViewDataSource

extension TNCalendarViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == rootView.calenderBottomCollectionView {
            return 1
        } else {
            return scrapLists.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == rootView.calenderBottomCollectionView {
            return calendarDaily.count
        } else {
            let scrapSection = Array(scrapLists.values)[section]
            return scrapSection.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == rootView.calenderBottomCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JobListingCell.className, for: indexPath) as? JobListingCell else { return UICollectionViewCell() }
            
            cell.bind(model: calendarDaily[indexPath.row])
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JobListingCell.className, for: indexPath) as? JobListingCell else {
                return UICollectionViewCell()
            }
            
            let scrapSection = Array(scrapLists.values)[indexPath.section]
            let scrapItem = scrapSection[indexPath.row]
            
            cell.bind(model: scrapItem)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if collectionView == rootView.calenderBottomCollectionView {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CalendarDateHeaderView.className, for: indexPath) as? CalendarDateHeaderView else { return UICollectionReusableView() }
            
            return headerView
        } else {
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CalendarDateHeaderView.className, for: indexPath) as? CalendarDateHeaderView else {
                    return UICollectionReusableView()
                }
                
                let scrapSection = Array(scrapLists.keys)[indexPath.section]
                let formattedDate = dateFormatter.string(from: scrapSection)
                headerView.bind(title: formattedDate)
                
                return headerView
                
            case UICollectionView.elementKindSectionFooter:
                guard let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CalendarDateFooterView.className, for: indexPath) as? CalendarDateFooterView else {
                    return UICollectionReusableView()
                }
                
                // 마지막 섹션인 경우 배경색 설정
                if indexPath.section == collectionView.numberOfSections - 1 {
                    footerView.backgroundColor = .back
                }
                
                return footerView
                
            default:
                return UICollectionReusableView()
            }
        }
    }
}

extension TNCalendarViewController {
    private func fetchMonthData(for date: Date) {
        let year = Calendar.current.component(.year, from: date)
        let month = Calendar.current.component(.month, from: date)
        
        calendarProvider.request(.getMonthlyDefault(year: year, month: month)) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let result):
                let status = result.statusCode
                if 200..<300 ~= status {
                    do {
                        let responseDto = try result.map(BaseResponse<[ScrapsByDeadlineModel]>.self)
                        guard let data = responseDto.result else { return }
                        
                        self.scraps = [:]
                        
                        for item in data {
                            if let date = self.dateFormatter.date(from: item.deadline) {
                                self.scraps[date] = item.scraps
                            }
                        }
                        
                        self.rootView.calendarView.reloadData()
                        
                    } catch {
                        print("Error: \(error.localizedDescription)")
                        self.showToast(message: "데이터를 불러오는 중 오류가 발생했습니다.")
                    }
                } else {
                    self.showToast(message: "서버 오류: \(status)")
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                self.showToast(message: "네트워크 오류가 발생했습니다.")
            }
        }
    }
    
    private func getMonthlyList() {
        let currentPage = rootView.calendarView.currentPage
        let year = Calendar.current.component(.year, from: currentPage)
        let month = Calendar.current.component(.month, from: currentPage)
        
        calendarProvider.request(.getMonthlyList(year: year, month: month)) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let result):
                let status = result.statusCode
                if 200..<300 ~= status {
                    do {
                        let responseDto = try result.map(BaseResponse<[ScrapsByDeadlineModel]>.self)
                        guard let data = responseDto.result else { return }
                        
                        self.scrapLists = [:]
                        
                        for item in data {
                            if let date = self.dateFormatter.date(from: item.deadline) {
                                self.scrapLists[date] = item.scraps
                            }
                        }
                        
                        self.rootView.calenderListCollectionView.reloadData()
                        
                    } catch {
                        print("Error: \(error.localizedDescription)")
                        self.showToast(message: "데이터를 불러오는 중 오류가 발생했습니다.")
                    }
                } else {
                    self.showToast(message: "서버 오류: \(status)")
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                self.showToast(message: "네트워크 오류가 발생했습니다.")
            }
        }
    }
    
    private func fetchDailyData(for date: Date) {
        let dateString = dateFormatter.string(from: date)
        print(date)
        print(dateString)
        
        calendarProvider.request(.getDaily(date: dateString)) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let result):
                let status = result.statusCode
                if 200..<300 ~= status {
                    do {
                        let responseDto = try result.map(BaseResponse<[DailyScrapModel]>.self)
                        guard let data = responseDto.result else { return }
                        
                        self.calendarDaily = data
                        
                        self.rootView.calenderBottomCollectionView.reloadData()
                        
                    } catch {
                        print("Error: \(error.localizedDescription)")
                        self.showToast(message: "데이터를 불러오는 중 오류가 발생했습니다.")
                    }
                } else {
                    self.showToast(message: "서버 오류: \(status)")
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                self.showToast(message: "네트워크 오류가 발생했습니다.")
            }
        }
    }
}
