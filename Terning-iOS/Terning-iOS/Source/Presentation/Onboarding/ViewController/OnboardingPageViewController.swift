//
//  OnboardingViewController.swift
//  Terning-iOS
//
//  Created by 정민지 on 7/11/24.
//

import UIKit

import RxSwift

import SnapKit

final class OnboardingData {
    static let shared = OnboardingData()
    
    var grade: Int = -1
    var jobPeriod: Int = -1
    var graduationDate: Date?
    
    private init() {}
}

final class OnboardingPageViewController: UIPageViewController {
    
    // MARK: - Properties
    
    private var pages = [UIViewController]()
    private var initialPage = 0
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    
    init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.didMove(toParent: self)
        
        setPages()
        setUI()
        disableSwipeGesture()
    }
}

// MARK: - UI & Layout

extension OnboardingPageViewController {
    private func setPages() {
        let gradeViewController = OnboardingViewController(
            viewType: .grade,
            viewModel: OnboardingViewModel(),
            step: 1
        )
        let jobPeriodViewController = OnboardingViewController(
            viewType: .jobPeriod,
            viewModel: OnboardingViewModel(),
            step: 2
        )
        let graduationDateViewController = OnboardingViewController(
            viewType: .graduationDate,
            viewModel: OnboardingViewModel(),
            step: 3
        )

        gradeViewController.onboardingView.nextButton.rx.tap.subscribe(with: self) { owner, _ in
            owner.moveToNextPage()
        }.disposed(by: disposeBag)
        jobPeriodViewController.onboardingView.nextButton.rx.tap.subscribe(with: self) { owner, _ in
            owner.moveToNextPage()
        }.disposed(by: disposeBag)
        graduationDateViewController.onboardingView.nextButton.rx.tap.subscribe(with: self) { owner, _ in
            owner.moveToNextPage()
        }.disposed(by: disposeBag)
        
        [gradeViewController, jobPeriodViewController, graduationDateViewController].forEach {
            pages.append($0)
        }
    }
    
    private func setUI() {
        if let firstPage = pages.first {
            self.setViewControllers([firstPage], direction: .forward, animated: true, completion: nil)
        }
    }
}

// MARK: - Methods

extension OnboardingPageViewController {
    private func disableSwipeGesture() {
        for gesture in view.gestureRecognizers ?? [] {
            if let gesture = gesture as? UIPanGestureRecognizer {
                gesture.isEnabled = false
            }
        }
    }
    
    private func moveToNextPage() {
        guard let currentVC = viewControllers?.first,
              let currentIndex = pages.firstIndex(of: currentVC) else { return }
        
        if currentIndex < pages.count - 1 {
            let nextVC = pages[currentIndex + 1]
            setViewControllers([nextVC], direction: .forward, animated: true, completion: nil)
        } else {
            let data = OnboardingData.shared
        }
    }
    
    private func setDelegate() {
        self.dataSource = self
    }
}

// MARK: - UIPageViewControllerDataSource

extension OnboardingPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController) else { return nil }
        let previousIndex = index - 1
        if previousIndex < 0 {
            return nil
        }
        return pages[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController) else { return nil }
        let nextIndex = index + 1
        if nextIndex == pages.count {
            return nil
        }
        return pages[nextIndex]
    }
}
