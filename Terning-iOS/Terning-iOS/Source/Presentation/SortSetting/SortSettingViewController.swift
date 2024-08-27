//
//  SortSettingViewController.swift
//  Terning-iOS
//
//  Created by 김민성 on 8/25/24.
//

import UIKit

import SnapKit
import Then

enum SortingOptions: String, CaseIterable {
    case earlyDeadLine = "채용 마감 이른순" // api 명세서에 맞게 수정
    case shortTerm = "짧은 근무 기간 순"
    case longTerm = "긴 근무 기간 순"
    case scraps = "스크랩 많은 순"
    case views = "조회수 많은 순"
    
    var title: String {
        return self.rawValue // default
    }
    
    var defaultColor: UIColor {
        return .grey400
    }
    
    var selectedColor: UIColor {
        return .terningMain
    }
}

protocol SortSettingButtonProtocol: AnyObject {
    func didSelectSortingOption(_ option: SortingOptions)
}

class SortSettingViewController: UIViewController {
    
    // MARK: - Properties
    
    var selectedOption: SortingOptions? {
        didSet {
            updateButtonColors()
        }
    }
    
    weak var sortSettingDelegate: SortSettingButtonProtocol?
    
    // MARK: - UIComponents
    
    private let notchView = UIView().then {
        $0.backgroundColor = .grey300
        $0.layer.cornerRadius = 2
        $0.isUserInteractionEnabled = true
    }
    
    private let mainTitleLabel = LabelFactory.build(
        text: "공고 정렬 순서",
        font: .title2,
        textColor: .terningBlack
    )
    
    private let splitView = UIView().then {
        $0.backgroundColor = .grey200
    }
    
    let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10
        $0.distribution = .fillEqually
    }
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setButtonUI()
        setHierarchy()
        setLayout()
    }
    
    // MARK: - Private func
    
    private func createButton(for option: SortingOptions) -> UIButton {
        let button = UIButton().then {
            $0.setTitle(option.rawValue, for: .normal)
            $0.contentHorizontalAlignment = .left
            $0.titleLabel?.font = .body4
            $0.setTitleColor(option.defaultColor, for: .normal)
            $0.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            $0.tag = option.hashValue
        }
        return button
    }
    
    private func updateButtonColors() {
        for subView in stackView.subviews {
            if let button = subView as? UIButton {
                let option = SortingOptions.allCases.first { $0.hashValue == button.tag }
                button.setTitleColor(option == selectedOption ? option?.selectedColor : option?.defaultColor, for: .normal)
            }
        }
    }
    
    // MARK: - objc func
    
    @objc
    func buttonTapped(_ sender: UIButton) {
        guard let option = SortingOptions.allCases.first(where: { $0.hashValue == sender.tag }) else { return }
        selectedOption = option
        sortSettingDelegate?.didSelectSortingOption(option)
    }
}

// MARK: - UI & Layout

extension SortSettingViewController {
    private func setUI() {
        view.backgroundColor = .white
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius = 30
        view.layer.masksToBounds = true
    }
    
    private func setButtonUI() {
        for option in SortingOptions.allCases {
            let button = createButton(for: option)
            stackView.addArrangedSubview(button)
        }
        
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(95.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(28.adjusted)
            $0.height.equalTo(240.adjustedH)
        }
    }
    
    private func setHierarchy() {
        view.addSubviews(notchView, mainTitleLabel, splitView)
    }
    
    private func setLayout() {
        notchView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(60.adjusted)
            $0.height.equalTo(4.adjustedH)
        }
        
        mainTitleLabel.snp.makeConstraints {
            $0.top.equalTo(notchView.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(28)
        }
        
        splitView.snp.makeConstraints {
            $0.top.equalTo(mainTitleLabel.snp.bottom).offset(15)
            $0.horizontalEdges.equalToSuperview().inset(25.adjusted)
            $0.height.equalTo(1.adjustedH)
        }
    }
}
