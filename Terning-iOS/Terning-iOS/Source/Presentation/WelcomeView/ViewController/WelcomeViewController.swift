//
//  WelcomeViewController.swift
//  Terning-iOS
//
//  Created by 정민지 on 7/10/24.
//

import UIKit

import SnapKit

@frozen
enum WelcomeViewType {
    case first
    case second
}

final class WelcomeViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewType: WelcomeViewType
    
    // MARK: - UI Components
    
    private lazy var customView = WelcomeView(viewType: viewType)
    
    // MARK: - Init
    
    init(viewType: WelcomeViewType) {
        
        self.viewType = viewType
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setLayout()
        setButtonAction()
    }
}

// MARK: - UI & Layout

extension WelcomeViewController {
    private func setUI() {
        self.view.backgroundColor = .white
    }
    
    private func setLayout() {
        view.addSubview(customView)
        
        customView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

// MARK: - Methods

extension WelcomeViewController {
    private func setButtonAction() {
        customView.setStartButtonAction(target: self, action: #selector(startButtonDidTap))
    }
}

// MARK: - Action

extension WelcomeViewController {
    @objc private func startButtonDidTap() {
        switch viewType {
        case .first:
            // TODO: 프로필 설정 화면으로 이동
            break
        case .second:
            // TODO: 온보딩 화면으로 이동
            break
        }
    }
}
