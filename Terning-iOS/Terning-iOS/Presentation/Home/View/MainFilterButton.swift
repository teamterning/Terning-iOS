//
//  MainFilterButton.swift
//  Terning-iOS
//
//  Created by 이명진 on 12/19/24.
//

import UIKit

final class MainFilterButton: UIButton {
    
    // MARK: - Life Cycle
    
    init() {
        super.init(frame: .zero)
        configureButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI & Layout
    
    private func configureButton() {
        
        var configuration = UIButton.Configuration.filled()
        
        configuration.attributedTitle = AttributedString(
            "필터링",
            attributes: AttributeContainer([
                .font: UIFont.button3,
                .foregroundColor: UIColor.terningMain
            ])
        )
        
        configuration.image = .icFilter
        
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 9)
        
        configuration.background.cornerRadius = 5
        configuration.background.strokeWidth = 1
        configuration.background.strokeColor = .terningMain
        configuration.background.backgroundColor = .clear
        
        self.configuration = configuration
        
        let buttonStateHandler: UIButton.ConfigurationUpdateHandler = { button in
            var updatedConfiguration = button.configuration
            let backgroundColor: UIColor
            
            switch button.state {
            case .highlighted:
                backgroundColor = .terningPressed
            default:
                backgroundColor = .clear
            }
            
            updatedConfiguration?.background.backgroundColor = backgroundColor
            
            button.configuration = updatedConfiguration
        }
        self.configurationUpdateHandler = buttonStateHandler
    }
}
