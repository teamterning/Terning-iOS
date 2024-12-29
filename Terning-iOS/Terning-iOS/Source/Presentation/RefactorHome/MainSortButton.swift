//
//  MainSortButton.swift
//  Terning-iOS
//
//  Created by 이명진 on 12/19/24.
//

import UIKit

final class MainSortButton: UIButton {
    
    private var sortName: String
    
    init(sortName: String = "채용 마감 이른순") {
        self.sortName = sortName
        super.init(frame: .zero)
        
        configureButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureButton() {
        
        var config = UIButton.Configuration.filled()
        
        config.attributedTitle = AttributedString(
            "\(sortName)",
            attributes: AttributeContainer([
                .font: UIFont.button3,
                .foregroundColor: UIColor.grey350
            ])
        )
        
        config.image = .icUnderArrow
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 3.adjusted, bottom: 0, trailing: 10.adjusted)
        
        config.background.cornerRadius = 5
        config.background.strokeWidth = 1
        config.background.strokeColor = .grey350
        config.background.backgroundColor = .white
        
        self.configuration = config
        
        self.configurationUpdateHandler = { button in
            var updatedConfig = button.configuration
            
            updatedConfig?.background.backgroundColor = (button.state == .highlighted) ? .terningPressed : .white
            
            button.configuration = updatedConfig
        }
    }
}
