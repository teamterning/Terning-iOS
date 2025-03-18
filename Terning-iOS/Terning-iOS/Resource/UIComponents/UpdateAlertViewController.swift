//
//  UpdateAlertViewController.swift
//  Terning-iOS
//
//  Created by 이명진 on 3/18/25.
//

import UIKit

import RxSwift
import RxCocoa

import SnapKit
import Then

public enum UpdateViewType {
    case normal
    case force
}

final class UpdateAlertViewController: UIViewController {
    
    // MARK: - Properties
    
    private let updateViewType: UpdateViewType!
    let disposeBag = DisposeBag()
    
    // MARK: - UIComponents
    
    private let alertView = UIView()
    private final let updateTitle: String!
    private final let discription: String!
    
    private let titleLabel = LabelFactory.build(
        font: .title2
    )
    
    private let discriptionLabel = LabelFactory.build(
        font: .body4,
        textColor: .grey400,
        lineSpacing: 1.5,
        characterSpacing: -0.002
    ).then {
        $0.numberOfLines = 0
    }
    
    fileprivate let centerButton = TerningCustomButton(title: "업데이트 하러 가기", font: .button3, radius: 8)
    fileprivate let leftButton = TerningCustomButton(title: "다음에 하기", font: .button3, radius: 8)
    fileprivate let rightButton = TerningCustomButton(title: "업데이트 하기", font: .button3, radius: 8)
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setHierarchy(updateViewType)
        setLayout(updateViewType)
    }
    
    init(updateViewType: UpdateViewType, title: String? = "", discription: String? = "") {
        self.updateViewType = updateViewType
        
        self.updateTitle = title
        self.discription = discription
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI & Layout
    
    private func setUI() {
        view.backgroundColor = .terningBlack.withAlphaComponent(0.3)
        
        alertView.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 20
        }
        
        titleLabel.do {
            $0.text = updateTitle
        }
        
        discriptionLabel.do {
            $0.text = discription
        }
    }
    
    private func setHierarchy(_ type: UpdateViewType) {
        
        view.addSubview(alertView)
        alertView.addSubviews(titleLabel, discriptionLabel)
        
        switch type {
        case .normal:
            leftButton.setAppearance(
                normalBackgroundColor: .grey150,
                pressedBackgroundColor: .grey200,
                textNormal: .grey350
            )
            
            alertView.addSubviews(leftButton, rightButton)
        case .force:
            alertView.addSubview(centerButton)
        }
    }
    
    private func setLayout(_ type: UpdateViewType) {
        alertView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.height.equalTo(199.adjustedH)
            $0.width.equalTo(320.adjusted)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(alertView.snp.top).offset(32.adjustedH)
            $0.centerX.equalToSuperview()
        }
        
        discriptionLabel.snp.makeConstraints {
            $0.top.equalTo(alertView.snp.top).offset(32.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(52.adjusted)
            $0.center.equalToSuperview()
        }
        
        switch type {
        case .normal:
            leftButton.snp.makeConstraints {
                $0.top.equalTo(alertView.snp.top).offset(147.adjustedH)
                $0.leading.equalTo(alertView.snp.leading).offset(16.adjusted)
                $0.width.equalTo(140.adjusted)
                $0.height.equalTo(40.adjustedH)
            }
            
            rightButton.snp.makeConstraints {
                $0.top.equalTo(alertView.snp.top).offset(147.adjustedH)
                $0.leading.equalTo(leftButton.snp.trailing).offset(8.adjusted)
                $0.width.equalTo(140.adjusted)
                $0.height.equalTo(40.adjustedH)
            }
            
        case .force:
            centerButton.snp.makeConstraints {
                $0.top.equalTo(alertView.snp.top).offset(147.adjustedH)
                $0.centerX.equalToSuperview()
                $0.width.equalTo(288.adjusted)
                $0.height.equalTo(40.adjustedH)
            }
        }
    }
}
