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
        
        var config = UIButton.Configuration.filled()
        
        config.attributedTitle = AttributedString(
            "필터링",
            attributes: AttributeContainer([
                .font: UIFont.button3,
                .foregroundColor: UIColor.terningMain
            ])
        )
        
        config.image = .icFilter
        
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 9)
        
        config.background.cornerRadius = 5
        config.background.strokeWidth = 1
        config.background.strokeColor = .terningMain
        config.background.backgroundColor = .white
        
        self.configuration = config
        
        self.configurationUpdateHandler = { button in
            var updatedConfig = button.configuration
            
            updatedConfig?.background.backgroundColor = (button.state == .highlighted) ? .terningPressed : .white
            
            button.configuration = updatedConfig
        }
    }
}
