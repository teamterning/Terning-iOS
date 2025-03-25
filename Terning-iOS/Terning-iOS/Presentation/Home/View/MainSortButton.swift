//
//  MainSortButton.swift
//  Terning-iOS
//
//  Created by 이명진 on 12/19/24.
//

import UIKit

import SnapKit
import Then

final class MainSortButton: UIButton {
    
    // MARK: - UI Components
    
    private let sortIconImageView = UIImageView().then {
        $0.image = UIImage(resource: .icUnderArrow)
    }
    
    private let sortNameLabel = LabelFactory.build(
        text: "정렬하기 버튼",
        font: .button3,
        textColor: .grey350
    )
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setHierarchy()
        setLayout()
        configureButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI & Layout
    
    private func setUI() {
        self.makeBorder(width: 1, color: .grey350, cornerRadius: 5)
    }
    
    private func setHierarchy() {
        self.addSubviews(
            sortIconImageView,
            sortNameLabel
        )
    }
    
    private func setLayout() {
        sortIconImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(6.adjusted)
        }
        
        sortNameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(sortIconImageView.snp.trailing).offset(3.adjusted)
        }
    }
    
    private func configureButton() {
        let configuration = UIButton.Configuration.filled()
        
        self.configuration = configuration
        
        let buttonStateHandler: UIButton.ConfigurationUpdateHandler = { button in
            var updatedConfiguration = button.configuration
            let backgroundColor: UIColor
            
            switch button.state {
            case .highlighted:
                backgroundColor = .grey100
            default:
                backgroundColor = .clear
            }
            
            updatedConfiguration?.background.backgroundColor = backgroundColor
            
            button.configuration = updatedConfiguration
        }
        self.configurationUpdateHandler = buttonStateHandler
    }
    
    // MARK: - Methods
    
    func changeTitle(name: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.sortNameLabel.text = name
            let leadingOffset = name.count < 10 ? 8.adjusted : 3.adjusted
            
            self.sortNameLabel.snp.updateConstraints {
                $0.leading.equalTo(self.sortIconImageView.snp.trailing).offset(leadingOffset)
            }
            
            self.layoutIfNeeded()
        }
    }
}
