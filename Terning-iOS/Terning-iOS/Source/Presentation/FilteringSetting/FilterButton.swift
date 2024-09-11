//
//  FilteringButton.swift
//  Terning-iOS
//
//  Created by 김민성 on 7/12/24.
//

import UIKit

import SnapKit

class FilterButton: UIButton {
    
    init(config: UIButton.Configuration = .filled(), titleContainer: AttributeContainer = .init()) {
        super.init(frame: .zero)
        
        self.configuration = config
        
        let title = "필터링"
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.button3,
            .foregroundColor: UIColor.terningMain
        ]
        
        let attributedTitle = NSAttributedString(string: title, attributes: attributes)
        self.configuration?.attributedTitle = AttributedString(attributedTitle)
        
        self.configuration?.image = .icFilter
        self.configuration?.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 28)
        self.configuration?.imagePadding = 2
        
        self.configuration?.contentInsets.leading = 2 // 버튼과 leading에 얼마만큼
        self.configuration?.contentInsets.trailing = 6 // 버튼을 기준으로 trailing이랑 떨어져있는 정도
        self.configuration?.contentInsets.top = 7
        self.configuration?.contentInsets.bottom = 6
        
        self.configuration?.titleAlignment = .center
        self.configuration?.background.backgroundColor = .white
        self.configuration?.background.cornerRadius = 5
        self.configuration?.background.strokeColor = .terningMain
        self.configuration?.background.strokeWidth = 1
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
