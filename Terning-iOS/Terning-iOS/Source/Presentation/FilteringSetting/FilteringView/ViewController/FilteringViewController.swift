//
//  FilteringViewController.swift
//  Terning-iOS
//
//  Created by 정민지 on 12/17/24.
//

import UIKit

import RxSwift
import RxCocoa

import SnapKit
import Then

final class UserFilteringData {
    static let shared = UserFilteringData()
    
    var grade: Grade?
    var workingPeriod: WorkingPeriod?
    var startYear: Int? = Date().getCurrentKrYearAndMonth().year
    var startMonth: Int? = Date().getCurrentKrYearAndMonth().month
    var jobType: JobType?
    
    private init() {}
}

final class TemporaryFilteringData {
    static let shared = TemporaryFilteringData()
    
    var grade: Grade?
    var workingPeriod: WorkingPeriod?
    var startYear: Int? = Date().getCurrentKrYearAndMonth().year
    var startMonth: Int? = Date().getCurrentKrYearAndMonth().month
    var jobType: JobType?
    
    private init() {}
}

final class FilteringViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: FilteringViewModel
    private let disposeBag = DisposeBag()
    private let currentIndex = BehaviorRelay<Int>(value: 0)
    
    // MARK: - UI Components
    
    private let notchView = UIView().then {
        $0.backgroundColor = .grey300
        $0.layer.cornerRadius = 2
        $0.isUserInteractionEnabled = true
    }
    
    private var segmentControl: CustomSegmentedControl = {
        let underbarInfo = UnderbarInfo(
            height: 4,
            highlightColor: .terningMain,
            backgroundColor: .grey300
        )
        let control = CustomSegmentedControl(items: ["직무 카테고리", "계획"], underbarInfo: underbarInfo, underline: false)
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    private let underLineView = UIView().then {
        $0.backgroundColor = .grey300
    }
    
    private var pageViewController: UIPageViewController!

    private lazy var pages: [UIViewController] = {
        let jobVC = JobFilteringViewController(viewModel: JobFilteringViewModel())
        let planVC = PlanFilteringViewController(viewModel: PlanFilteringViewModel())
        return [jobVC, planVC]
    }()
    
    private let saveButton = CustomButton(title: "저장하기")
    
    // MARK: - Init
    
    init(viewModel: FilteringViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setHierarchy()
        setLayout()
        setupPageViewController()
        setupSegmentControl()
        bindViewModel()
    }
}

// MARK: - UI & Layout

extension FilteringViewController {
    private func setUI() {
        view.backgroundColor = .white
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius = 30
        view.layer.masksToBounds = true
    }
    
    private func setHierarchy() {
        view.addSubviews(
            notchView,
            segmentControl,
            underLineView,
            saveButton
        )
    }
    
    private func setLayout() {
        notchView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(60.adjusted)
            $0.height.equalTo(4.adjustedH)
        }
        
        segmentControl.snp.makeConstraints {
            $0.top.equalTo(notchView.snp.bottom).offset(24)
            $0.leading.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }
        
        underLineView.snp.makeConstraints {
            $0.top.equalTo(segmentControl.snp.bottom).offset(-1)
            $0.horizontalEdges.equalToSuperview().inset(29)
            $0.height.equalTo(1)
        }
        
        saveButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(8)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(54)
        }
    }
    
    private func setupPageViewController() {
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        pageViewController.setViewControllers([pages[0]], direction: .forward, animated: true)
        
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
        
        pageViewController.view.snp.makeConstraints {
            $0.top.equalTo(segmentControl.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.bottom.equalTo(saveButton.snp.top).offset(-16)
        }
    }
}

// MARK: - Methods

extension FilteringViewController {
    private func setupSegmentControl() {
        segmentControl.addTarget(self, action: #selector(didChangeSegment(_:)), for: .valueChanged)
    }
    
    private func bindViewModel() {
        guard let jobVC = pages[0] as? JobFilteringViewController,
              let planVC = pages[1] as? PlanFilteringViewController else { return }
        
        let input = FilteringViewModel.Input(
            jobFilteringState: jobVC.filteringState.asObservable(),
            planFilteringState: planVC.filteringState.asObservable(),
            currentIndex: currentIndex.asObservable(),
            saveButtonTap: saveButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input, disposeBag: disposeBag)
        
        output.isSaveButtonEnabled
            .drive(onNext: { [weak self] isEnabled in
                self?.saveButton.setEnabled(isEnabled)
            })
            .disposed(by: disposeBag)
        
        output.dismissModal
            .drive(onNext: { [weak self] in
                self?.presentingViewController?.removeModalBackgroundView()
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - @objc func

extension FilteringViewController {
    @objc
    private func didChangeSegment(_ sender: UISegmentedControl) {
        let newIndex = sender.selectedSegmentIndex
        let direction: UIPageViewController.NavigationDirection = newIndex > currentIndex.value ? .forward : .reverse
        
        pageViewController.setViewControllers([pages[newIndex]], direction: direction, animated: true, completion: nil)
        currentIndex.accept(newIndex)
    }
}

// MARK: - UIPageViewControllerDataSource, Delegate

extension FilteringViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index > 0 else { return nil }
        return pages[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index < pages.count - 1 else { return nil }
        return pages[index + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let visibleViewController = pageViewController.viewControllers?.first,
           let index = pages.firstIndex(of: visibleViewController) {
            segmentControl.selectedSegmentIndex = index
            currentIndex.accept(index)
        }
    }
}
