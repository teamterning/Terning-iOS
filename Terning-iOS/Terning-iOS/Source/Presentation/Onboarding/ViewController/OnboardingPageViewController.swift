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
    var workingPeriod: Int = -1
    var startYear: Int = 2024
    var startMonth: Int = 1
    
    private init() {}
}

final class OnboardingPageViewController: UIPageViewController {
    
    // MARK: - Properties
    
    private let authProvider = Providers.authProvider
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
        let workingPeriodViewController = OnboardingViewController(
            viewType: .workingPeriod,
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
        
        workingPeriodViewController.onboardingView.nextButton.rx.tap.subscribe(with: self) { owner, _ in
            owner.moveToNextPage()
        }.disposed(by: disposeBag)
        
        graduationDateViewController.onboardingView.nextButton.rx.tap.subscribe(with: self) { owner, _ in
            owner.moveToNextPage()
        }.disposed(by: disposeBag)
        
        [gradeViewController, workingPeriodViewController, graduationDateViewController].forEach {
            pages.append($0)
        }
    }
    
    private func setUI() {
        navigationController?.isNavigationBarHidden = true
        
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
            postUserFilter { [weak self] success in
                if success {
                    self?.completeOnboarding()
                } else {
                    self?.showNetworkFailureToast()
                }
            }
        }
    }
    
    private func completeOnboarding() {
        let welcomeVC = WelcomeViewController(viewType: .second)
        self.navigationController?.pushViewController(welcomeVC, animated: true)
    }
}

// MARK: - API Methods

extension OnboardingPageViewController {
    private func postUserFilter(completion: @escaping (Bool) -> Void) {
        authProvider.request(
            .postOnboarding(
                grade: OnboardingData.shared.grade,
                workingPeriod: OnboardingData.shared.workingPeriod,
                startYear: OnboardingData.shared.startYear,
                startMonth: OnboardingData.shared.startMonth
            )) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let result):
                    let status = result.statusCode
                    if 200..<300 ~= status {
                        do {
                            let responseDto = try result.map(BaseResponse<[String]>.self)
                            completion(true)
                        } catch {
                            print(error.localizedDescription)
                            completion(false)
                        }
                    } else {
                        print("400 error")
                        self.showNetworkFailureToast()
                        completion(false)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    self.showNetworkFailureToast()
                    completion(false)
                }
            }
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
