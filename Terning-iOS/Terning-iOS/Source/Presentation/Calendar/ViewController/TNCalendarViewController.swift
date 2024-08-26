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
    private let viewModel: TNCalendarViewModel
    
    private lazy var pageRelay: BehaviorRelay<Date> = {
        let initialPage = rootView.calendarView.currentPage
        let relay = BehaviorRelay<Date>(value: initialPage)
        
        rootView.calendarView.rx
            .observe(Date.self, "currentPage")
            .compactMap { $0 }
            .distinctUntilChanged()
            .bind(to: relay)
            .disposed(by: disposeBag)
        
        return relay
    }()
    
    private var isListViewVisible = false
    
    private let dateFormatter = DateFormatter().then {
        $0.dateFormat = "yyyy-MM-dd"
    }
    
    private let dateFormmatter2 = DateFormatter().then {
        $0.dateFormat = "yyyy년 MM월 dd일"
    }
    
    private let colorIndexMapping: [Int: Int] = [
        0: 0,  // calRed
        1: 2,  // calOrange2
        2: 4,  // calGreen1
        3: 6,  // calBlue1
        4: 8,  // calPurple
        5: 1,  // calOrange
        6: 3,  // calYellow
        7: 5,  // calGreen2
        8: 7,  // calBlue2
        9: 9   // calPink
    ]
    
    // MARK: - UIComponents
    private let rootView = TNCalendarView()
    private let disposeBag = DisposeBag()
    private var selectedDate: Date?
    private var scraps: [Date: [DailyScrapModel]] = [:] // 스크랩 데이터를 저장할 딕셔너리
    private var scrapLists: [Date: [DailyScrapModel]] = [:] // 리스트 데이터를 저장할 딕셔너리
    private var calendarDaily: [DailyScrapModel] = [] // 일간 캘린더 데이터를 저장할 딕셔너리
    
    // MARK: - Life Cycles
    
    init(viewModel: TNCalendarViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegate()
        setRegister()
        bindNavigation()
        updateNaviBarTitle(for: rootView.calendarView.currentPage)
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        pageRelay.accept(rootView.calendarView.currentPage)
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
        
        rootView.calenderBottomCollectionView.backgroundColor = .white
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
        let input = TNCalendarViewModel.Input(
            fetchMonthDataTrigger: pageRelay.asObservable(),
            fetchMonthlyListTrigger: pageRelay.asObservable(),
            fetchDailyDataTrigger: pageRelay.asObservable()
        )
        
        let output = viewModel.transform(input: input, disposeBag: disposeBag)
        
        output.monthData
            .drive(onNext: { [weak self] scraps in
                guard let self = self else { return }
                self.scraps = scraps
                self.rootView.calendarView.reloadData()
            })
            .disposed(by: disposeBag)
        
        output.monthlyList
            .drive(onNext: { [weak self] scrapLists in
                guard let self = self else { return }
                self.scrapLists = scrapLists
                self.rootView.calenderListCollectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        output.dailyData
            .drive(onNext: { [weak self] dailyData in
                guard let self = self else { return }
                self.calendarDaily = dailyData
                self.rootView.calenderBottomCollectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        output.error
            .drive(onNext: { [weak self] errorMessage in
                guard let self = self else { return }
                self.showToast(message: errorMessage)
            })
            .disposed(by: disposeBag)
    }
    
    private func moveCalendar(by months: Int) {
        let currentPage = rootView.calendarView.currentPage
        
        let newDate = Calendar.current.date(byAdding: .month, value: months, to: currentPage) ?? currentPage
        rootView.calendarView.setCurrentPage(newDate, animated: true)
        updateNaviBarTitle(for: newDate)
        
        
        pageRelay.accept(newDate)
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
            
            pageRelay.accept(rootView.calendarView.currentPage)
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
        let newDate = calendar.currentPage
        updateNaviBarTitle(for: newDate)
        
        pageRelay.accept(newDate)
        
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
            pageRelay.accept(date)
        }
        calendar.reloadData()
    }
    
    // 주간일때 그림자와 라운드 넣어주는 함수
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        
        if calendar.scope == .week {
            rootView.calenderBottomCollectionView.backgroundColor = .back
            rootView.roundCalendarViewCorners(radius: 20) // 라운드 처리 해주기
            rootView.calendarViewContainer.layer.applyShadow(alpha: 0.1, y: 4, blur: 4)
            
            rootView.calendarView.snp.updateConstraints { make in
                make.height.equalTo(99) // 주간 뷰 높이 설정
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
        
        let events: [CalendarEvent] = scraps[date]?.map { CalendarEvent(color: UIColor(hex: $0.color), title: $0.title) } ?? []
        
        cell.bind(
            with: date,
            textColor: isCurrentMonth ? .black : .grey200,
            state: dateStatus,
            events: events
        )
        
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
            let model = calendarDaily[indexPath.row]
            let alertSheet = CustomAlertViewController(alertType: .custom)
            
            let colorIndex = alertSheet.selectedColorIndexRelay
            
            let deadLine = dateFormmatter2.string(from: selectedDate ?? Date())
            alertSheet.setData2(model: model, deadline: deadLine)
            
            guard let index = model.internshipAnnouncementId else { return }
            
            alertSheet.modalTransitionStyle = .crossDissolve
            alertSheet.modalPresentationStyle = .overFullScreen
            
            alertSheet.centerButtonTapAction = {
                if alertSheet.currentMode == .info {
                    self.dismiss(animated: true)
                    self.navigationController?.pushViewController(jobDetailViewController, animated: true)
                } else if alertSheet.currentMode == .color {
                    self.patchScrapAnnouncement(scrapId: model.scrapId, color: self.colorIndexMapping[colorIndex.value] ?? 0)
                    self.dismiss(animated: true)
                }
            }
            
            self.present(alertSheet, animated: false)
            
            jobDetailViewController.internshipAnnouncementId.onNext(index)
        } else {
            let sortedKeys = scrapLists.keys.sorted()
            let date = sortedKeys[indexPath.section]
            guard let scrapSection = scrapLists[date] else { return }
            guard let index = scrapSection[indexPath.row].internshipAnnouncementId else { return }
            //            jobDetailViewController.internshipAnnouncementId.onNext(index)
            
            let model = scrapSection[indexPath.row]
            let alertSheet = CustomAlertViewController(alertType: .custom)
            
            let colorIndex = alertSheet.selectedColorIndexRelay
            
            let deadLine = dateFormmatter2.string(from: selectedDate ?? Date())
            alertSheet.setData2(model: model, deadline: deadLine)
            
            alertSheet.modalTransitionStyle = .crossDissolve
            alertSheet.modalPresentationStyle = .overFullScreen
            
            alertSheet.centerButtonTapAction = {
                if alertSheet.currentMode == .info {
                    self.dismiss(animated: true)
                    let jobDetailVC = JobDetailViewController()
                    jobDetailVC.internshipAnnouncementId.onNext(index)
                    jobDetailVC.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(jobDetailVC, animated: true)
                } else if alertSheet.currentMode == .color {
                    self.patchScrapAnnouncement(scrapId: model.scrapId, color: self.colorIndexMapping[colorIndex.value] ?? 0)
                    self.dismiss(animated: true)
                }
            }
            
            self.present(alertSheet, animated: false)
        }
    }
    
    
    private func refetchDataAndReloadViews() {
        pageRelay.accept(rootView.calendarView.currentPage)
        
        if let selectedDate = selectedDate {
            pageRelay.accept(selectedDate)
        }
        
        rootView.calendarView.reloadData()
        rootView.calenderBottomCollectionView.reloadData()
        rootView.calenderListCollectionView.reloadData()
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
            let sortedKeys = scrapLists.keys.sorted()
            let scrapSection = scrapLists[sortedKeys[section]] ?? []
            return scrapSection.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == rootView.calenderBottomCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JobListingCell.className, for: indexPath) as? JobListingCell else { return UICollectionViewCell() }
            
            cell.bind(model: calendarDaily[indexPath.row], indexPath: indexPath, in: collectionView)
            cell.delegate = self
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JobListingCell.className, for: indexPath) as? JobListingCell else {
                return UICollectionViewCell()
            }
            
            let sortedKeys = scrapLists.keys.sorted()
            let scrapSection = scrapLists[sortedKeys[indexPath.section]] ?? []
            let scrapItem = scrapSection[indexPath.row]
            
            cell.bind(model: scrapItem, indexPath: indexPath, in: collectionView)
            cell.delegate = self
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
                
                let sortedKeys = scrapLists.keys.sorted()
                let scrapSection = sortedKeys[indexPath.section]
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

extension TNCalendarViewController: JobListCellProtocol {
    func scrapButtonDidTapInCalendar(in collectionView: UICollectionView, isScrap: Bool, indexPath: IndexPath) {
        let alertSheet = CustomAlertViewController(alertType: .normal)
        
        let model: DailyScrapModel
        
        if collectionView == rootView.calenderBottomCollectionView {
            model = calendarDaily[indexPath.row]
            
        } else if collectionView == rootView.calenderListCollectionView {
            
            let sortedKeys = scrapLists.keys.sorted()
            let date = sortedKeys[indexPath.section]
            guard let scrapSection = scrapLists[date] else { return }
            
            model = scrapSection[indexPath.row]
            
        } else {
            return
        }
        
        let scrapId = model.scrapId
        
        print(scrapId)
        
        alertSheet.setComponentDatas(
            mainLabel: "관심 공고가 캘린더에서 사라져요!",
            subLabel: "스크랩을 취소하시겠어요?",
            buttonLabel: "스크랩 취소하기"
        )
        
        alertSheet.centerButtonTapAction = {
            self.cancelScrapAnnouncement(scrapId: scrapId)
            self.dismiss(animated: false)
        }
        
        alertSheet.modalTransitionStyle = .crossDissolve
        alertSheet.modalPresentationStyle = .overFullScreen
        
        self.present(alertSheet, animated: false)
    }
}


// MARK: - Network

extension TNCalendarViewController {
    private func patchScrapAnnouncement(scrapId: Int?, color: Int) {
        guard let scrapId = scrapId else { return }
        Providers.scrapsProvider.request(.patchScrap(scrapId: scrapId, color: color)) { [weak self] result in
            LoadingIndicator.hideLoading()
            guard let self = self else { return }
            switch result {
            case .success(let response):
                let status = response.statusCode
                if 200..<300 ~= status {
                    print("스크랩 수정 성공")
                    self.refetchDataAndReloadViews()
                } else {
                    print("400 error")
                    self.showToast(message: "네트워크 오류")
                }
            case .failure(let error):
                print(error.localizedDescription)
                self.showToast(message: "네트워크 오류")
            }
        }
    }
    
    private func cancelScrapAnnouncement(scrapId: Int?) {
        
        guard let scrapId = scrapId else { return }
        Providers.scrapsProvider.request(.removeScrap(scrapId: scrapId)) { [weak self] result in
            LoadingIndicator.hideLoading()
            guard let self = self else { return }
            switch result {
            case .success(let response):
                let status = response.statusCode
                if 200..<300 ~= status {
                    print("스크랩 취소 성공")
                    self.refetchDataAndReloadViews()
                } else {
                    print("400 error")
                    self.showToast(message: "네트워크 오류")
                }
            case .failure(let error):
                print(error.localizedDescription)
                self.showToast(message: "네트워크 오류")
            }
        }
    }
}
