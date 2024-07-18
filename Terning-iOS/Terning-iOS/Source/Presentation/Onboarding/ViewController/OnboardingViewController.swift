//
//  OnboardingViewController.swift
//  Terning-iOS
//
//  Created by 정민지 on 7/11/24.
//

import UIKit

import RxSwift
import RxCocoa

import SnapKit

final class OnboardingViewController: UIViewController {
    
    // MARK: - Properties
    
    var viewType: OnboardingViewType
    private var step: Int
    private var viewModel: OnboardingViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Components
    
    lazy var onboardingView = OnboardingView(viewType: viewType)
    
    // MARK: - Init
    
    init(viewType: OnboardingViewType, viewModel: OnboardingViewModel, step: Int = 1) {
        
        self.viewType = viewType
        self.step = step
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setUI()
        setLayout()
        bindViewModel()
    }
}
    
// MARK: - UI & Layout

extension OnboardingViewController {
    private func setUI() {
        navigationController?.isNavigationBarHidden = true
        view.addSubview(onboardingView)
        
        onboardingView.updateProgress(step: step)
        
    }
    
    private func setLayout() {
        onboardingView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
    
// MARK: - Bind

extension OnboardingViewController {
    private func bindViewModel() {
        let input = OnboardingViewModel.Input(
            optionSelected: onboardingView.optionSelectedSubject.asObservable(),
            dateSelected: onboardingView.dateSelectedSubject.asObservable()
        )
        
        let output = viewModel.transform(input)
        
        output.isNextButtonEnabled
            .drive(onboardingView.nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.isNextButtonEnabled
            .drive(onNext: { isEnabled in
                self.onboardingView.nextButton.setEnabled(isEnabled)
            })
            .disposed(by: disposeBag)
    }
}
