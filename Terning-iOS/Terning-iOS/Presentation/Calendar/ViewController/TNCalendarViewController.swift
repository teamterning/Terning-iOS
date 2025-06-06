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
    
    private let patchScrapSubject = PublishSubject<(Int, String)>()
    private let cancelScrapSubject = PublishSubject<Int>()
    
    private var isListViewVisible = false
    
    private let isoDateFormatter = DateFormatter().then {
        $0.dateFormat = "yyyy-MM-dd"
    }
    
    private let koreanDateFormmatter = DateFormatter().then {
        $0.dateFormat = "yyyy년 MM월 dd일"
    }
    
    // MARK: - UIComponents
    
    private let rootView = TNCalendarView()
    private let disposeBag = DisposeBag()
    private var selectedDate: Date?
    
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
        setAddTarget()
        bindNavigation()
        updateNaviBarTitle(for: rootView.calendarView.currentPage)
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        pageRelay.accept(selectedDate ?? rootView.calendarView.currentPage)
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
        
        rootView.calendarBottomCollectionView.delegate = self
        rootView.calendarBottomCollectionView.dataSource = self
        
        rootView.calendarListCollectionView.delegate = self
        rootView.calendarListCollectionView.dataSource = self
        
        rootView.calendarBottomCollectionView.backgroundColor = .white
    }
    
    private func setRegister() {
        rootView.calendarView.register(TNCalendarDateCell.self, forCellReuseIdentifier: TNCalendarDateCell.className)
        
        rootView.calendarBottomCollectionView.register(JobListingCell.self, forCellWithReuseIdentifier: JobListingCell.className)
        rootView.calendarBottomCollectionView.register(CalendarDateHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CalendarDateHeaderView.className)
        
        rootView.calendarListCollectionView.register(JobListingCell.self, forCellWithReuseIdentifier: JobListingCell.className)
        rootView.calendarListCollectionView.register(CalendarDateHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CalendarDateHeaderView.className)
        rootView.calendarListCollectionView.register(CalendarDateFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: CalendarDateFooterView.className)
    }
    
    private func setAddTarget() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        rootView.calendarView.addGestureRecognizer(panGesture)
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
                owner.track(eventName: .clickCalendarList)
            }.disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        let input = TNCalendarViewModel.Input(
            fetchMonthDataTrigger: pageRelay.asObservable(),
            fetchMonthlyListTrigger: pageRelay.asObservable(),
            fetchDailyDataTrigger: pageRelay.asObservable(),
            patchScrapTrigger: patchScrapSubject.asObservable(),
            cancelScrapTrigger: cancelScrapSubject.asObservable()
        )
        
        let output = viewModel.transform(input: input, disposeBag: disposeBag)
        
        output.monthData
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                self.rootView.calendarView.reloadData()
            })
            .disposed(by: disposeBag)
        
        output.monthlyList
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                self.rootView.toggleEmptyView(for: .list, isHidden: self.viewModel.scrapLists.isEmpty)
                self.rootView.calendarListCollectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        output.dailyData
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                self.rootView.toggleEmptyView(for: .bottom, isHidden: self.viewModel.calendarDaily.isEmpty)
                self.rootView.calendarBottomCollectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        output.patchScrapResult
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                
                self.refetchDataAndReloadViews()
            })
            .disposed(by: disposeBag)
        
        output.cancelScrapResult
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                
                self.refetchDataAndReloadViews()
            })
            .disposed(by: disposeBag)
        
        output.error
            .drive(onNext: { [weak self] errorMessage in
                guard let self = self else { return }
                
                self.showToast(message: errorMessage)
            })
            .disposed(by: disposeBag)
        
        output.successMessage
            .drive(onNext: { [weak self] successMessage in
                guard let self = self else { return }
                
                self.showToast(message: successMessage, heightOffset: 12)
                self.refetchDataAndReloadViews()
            })
            .disposed(by: disposeBag)
    }
    
    // 스크랩 수정 호출
    private func patchScrapAnnouncement(scrapId: Int, color: String) {
        patchScrapSubject.onNext((scrapId, color))
    }
    
    // 스크랩 취소 호출
    private func cancelScrapAnnouncement(scrapId: Int?) {
        guard let scrapId = scrapId else { return }
        cancelScrapSubject.onNext(scrapId)
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
            rootView.calendarListCollectionView.isHidden = true
            
            if let selectedDate = selectedDate {
                pageRelay.accept(selectedDate)
            }
            
        } else {
            // 기존 뷰를 감추고 리스트 뷰를 보이게 함
            rootView.separatorView.isHidden = true
            rootView.calendarViewContainer.isHidden = true
            rootView.calendarListCollectionView.isHidden = false
            
            pageRelay.accept(rootView.calendarView.currentPage)
        }
        
        rootView.naviBar.isClicked(isListViewVisible)
        isListViewVisible.toggle()
    }
    
    /// 현재 활성화된 주가 6주 인지 5주인지 세어 주는 함수
    private func calculateWeekCount(for date: Date) -> Int {
        let calendar = Calendar.current
        let range = calendar.range(of: .weekOfMonth, in: .month, for: date)!
        return range.count
    }
}

// MARK: - @objc

extension TNCalendarViewController {
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let velocity = gesture.velocity(in: rootView.calendarView)
        
        switch gesture.state {
        case .ended:
            // 스와이프 속도가 500을 넘고, 주간 모드이면 월간 모드로 변경
            if velocity.y > 500 && rootView.calendarView.scope == .week {
                rootView.calendarView.setScope(.month, animated: true)
                
                // #247: 선택된 날짜를 풀고, 캘린더 reloadData 하여 아래 스와이프시 초록색 터치 영역 없애주기
                selectedDate = nil
                self.rootView.calendarView.reloadData()
            }
        default:
            break
        }
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
        
        let isWeekView = calendar.scope == .week
        
        if let visibleCells = calendar.visibleCells() as? [TNCalendarDateCell] {
            for cell in visibleCells {
                cell.cellView.setViewMode(isWeekView: isWeekView)
            }
        }
        
        // 주간 모드일 때 그림자 및 라운딩 처리
        if isWeekView {
            rootView.calendarBottomCollectionView.backgroundColor = .back
            rootView.roundCalendarViewCorners(radius: 20) // 라운드 처리 해주기
            rootView.calendarViewContainer.layer.applyShadow(color: .black, alpha: 0.1, y: 4, blur: 4)
            
            rootView.calendarView.snp.updateConstraints { make in
                make.height.equalTo(98.adjustedH) // 주간 뷰 높이 설정
            }
            rootView.calendarBottomCollectionView.isHidden = false
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                self.rootView.notchView.isHidden = false
            }
            
        } else {
            rootView.roundCalendarViewCorners(radius: 0)  // 라운드 처리 풀어 주기
            rootView.calendarViewContainer.layer.shadowOpacity = 0
            
            rootView.calendarView.snp.updateConstraints {
                let weekCount = calculateWeekCount(for: calendar.currentPage)
                print(weekCount)
                let cellHeight = weekCount == 6 ? 90 : 106
                let addHeight = weekCount == 6 ? 28 : 39 // 캘린더 주에 맞는 추가 높이 설정
                
                let point = cellHeight * weekCount + 48 + addHeight
                $0.height.equalTo(point.adjustedH)
            }
            
            rootView.calendarBottomCollectionView.isHidden = true
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.rootView.notchView.isHidden = true
            }
            rootView.calendarBottomCollectionView.backgroundColor = .white
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
        if let header = rootView.calendarBottomCollectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: headerIndexPath) as? CalendarDateHeaderView {
            let formattedDate = isoDateFormatter.string(from: date)
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
        let isToday = Calendar.current.isDateInToday(date)
        let isSelected = selectedDate != nil && Calendar.current.isDate(date, inSameDayAs: selectedDate!)
        
        let dateStatus: CalendarState = {
            if isSelected && isToday {
                return .selected // 오늘인데 선택되는 경우는 selected 상태로 처리
            } else if isToday { // 오늘 기본 상태는 today
                return .today
            } else if isSelected {
                return .selected
            } else {
                return .normal
            }
        }()
        
        // 선택된 날짜는 흰색으로 표시, 그 외는 원래 색상
        let textColor: UIColor = {
            if isSelected {
                return .white
            } else {
                return isCurrentMonth ? .black : .grey200
            }
        }()
        
        let isWeekView = calendar.scope == .week
        cell.cellView.setViewMode(isWeekView: isWeekView)
        
        let events: [CalendarEvent] = self.viewModel.scraps[date]?.map { CalendarEvent(color: UIColor(hex: $0.color), title: $0.title) } ?? []
        
        cell.bind(
            with: date,
            textColor: textColor,
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
        let jobDetailViewController = JobDetailViewController(
            viewModel: JobDetailViewModel(
                scrapUseCase: ScrapUseCase(
                    repository: ScrapRepository(
                        service: ScrapsService(
                            provider: Providers.scrapsProvider
                        )
                    )
                )
            )
        )
        
        if collectionView == rootView.calendarBottomCollectionView {
            let model = self.viewModel.calendarDaily[indexPath.row]
            
            let alertSheet = CustomAlertViewController(alertViewType: .changeColorAndPushJobDetail)
            
            jobDetailViewController.internshipAnnouncementId.accept(model.internshipAnnouncementId)
            jobDetailViewController.hidesBottomBarWhenPushed = true
            alertSheet.setAnnouncementData(model: model)
            
            alertSheet.modalTransitionStyle = .crossDissolve
            alertSheet.modalPresentationStyle = .overFullScreen
            
            alertSheet.leftButtonDidTapAction = {
                let selectedColorNameRelay = alertSheet.selectedColorNameRelay.value
                
                self.patchScrapAnnouncement(scrapId: model.internshipAnnouncementId, color: selectedColorNameRelay)
                self.dismiss(animated: true)
            }
            
            alertSheet.rightButtonDidTapAction = {
                self.dismiss(animated: true)
                self.navigationController?.pushViewController(jobDetailViewController, animated: true)
            }
            
            self.present(alertSheet, animated: false)
            
        } else {
            let sortedKeys = self.viewModel.scrapLists.keys.sorted()
            let date = sortedKeys[indexPath.section]
            guard let scrapSection = self.viewModel.scrapLists[date] else { return }
            
            let model = scrapSection[indexPath.row]
            
            let alertSheet = CustomAlertViewController(alertViewType: .changeColorAndPushJobDetail)
            
            alertSheet.setAnnouncementData(model: model)
            
            jobDetailViewController.internshipAnnouncementId.accept(model.internshipAnnouncementId)
            jobDetailViewController.hidesBottomBarWhenPushed = true
            
            alertSheet.modalTransitionStyle = .crossDissolve
            alertSheet.modalPresentationStyle = .overFullScreen
            
            alertSheet.leftButtonDidTapAction = {
                let selectedColorNameRelay = alertSheet.selectedColorNameRelay.value
                
                self.patchScrapAnnouncement(scrapId: model.internshipAnnouncementId, color: selectedColorNameRelay)
                self.dismiss(animated: true)
            }
            
            alertSheet.rightButtonDidTapAction = {
                self.dismiss(animated: true)
                self.navigationController?.pushViewController(jobDetailViewController, animated: true)
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
        rootView.calendarBottomCollectionView.reloadData()
        rootView.calendarListCollectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension TNCalendarViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == rootView.calendarBottomCollectionView {
            return 1
        } else {
            return self.viewModel.scrapLists.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == rootView.calendarBottomCollectionView {
            return self.viewModel.calendarDaily.count
        } else {
            let sortedKeys = self.viewModel.scrapLists.keys.sorted()
            let scrapSection = self.viewModel.scrapLists[sortedKeys[section]] ?? []
            return scrapSection.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == rootView.calendarBottomCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JobListingCell.className, for: indexPath) as? JobListingCell else { return UICollectionViewCell() }
            
            cell.bind(model: self.viewModel.calendarDaily[indexPath.row], indexPath: indexPath, in: collectionView)
            cell.delegate = self
            cell.layer.applyShadow(color: .greyShadow, alpha: 1, y: 0)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JobListingCell.className, for: indexPath) as? JobListingCell else {
                return UICollectionViewCell()
            }
            
            let sortedKeys = self.viewModel.scrapLists.keys.sorted()
            let scrapSection = self.viewModel.scrapLists[sortedKeys[indexPath.section]] ?? []
            let scrapItem = scrapSection[indexPath.row]
            
            cell.bind(model: scrapItem, indexPath: indexPath, in: collectionView)
            cell.layer.applyShadow(color: .greyShadow, alpha: 1, y: 0)
            cell.delegate = self
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if collectionView == rootView.calendarBottomCollectionView {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CalendarDateHeaderView.className, for: indexPath) as? CalendarDateHeaderView else { return UICollectionReusableView() }
            
            return headerView
        } else {
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CalendarDateHeaderView.className, for: indexPath) as? CalendarDateHeaderView else {
                    return UICollectionReusableView()
                }
                
                let sortedKeys = self.viewModel.scrapLists.keys.sorted()
                let scrapSection = sortedKeys[indexPath.section]
                let formattedDate = isoDateFormatter.string(from: scrapSection)
                headerView.setListViewLayout()
                headerView.bind(title: formattedDate)
                
                return headerView
                
            case UICollectionView.elementKindSectionFooter:
                guard let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CalendarDateFooterView.className, for: indexPath) as? CalendarDateFooterView else {
                    return UICollectionReusableView()
                }
                
                // 마지막 섹션인 경우 배경색 설정 TODO: 추후 삭제
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
        let alertSheet = CustomAlertViewController(alertViewType: .info)
        
        let model: AnnouncementModel
        
        if collectionView == rootView.calendarBottomCollectionView {
            model = self.viewModel.calendarDaily[indexPath.row]
            
        } else if collectionView == rootView.calendarListCollectionView {
            
            let sortedKeys = self.viewModel.scrapLists.keys.sorted()
            let date = sortedKeys[indexPath.section]
            guard let scrapSection = self.viewModel.scrapLists[date] else { return }
            
            model = scrapSection[indexPath.row]
            
        } else {
            return
        }
        
        let scrapId = model.internshipAnnouncementId
        
        print(scrapId)
        
        alertSheet.centerButtonDidTapAction = {
            self.cancelScrapAnnouncement(scrapId: scrapId)
            self.dismiss(animated: false)
        }
        
        alertSheet.modalTransitionStyle = .crossDissolve
        alertSheet.modalPresentationStyle = .overFullScreen
        
        self.present(alertSheet, animated: false)
    }
}
