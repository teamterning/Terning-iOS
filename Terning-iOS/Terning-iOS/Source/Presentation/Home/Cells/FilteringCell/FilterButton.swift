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
    
        self.configuration?.attributedTitle = "필터링"
        self.configuration?.attributedTitle?.font = .button4
        
        self.configuration?.image = .icFilter
        self.configuration?.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 28)
        self.configuration?.imagePadding = 2
        
        self.configuration?.contentInsets.leading = 2 // 버튼과 leading에 얼마만큼
        self.configuration?.contentInsets.trailing = 6 // 버튼을 기준으로 trailing이랑 떨어져있는 정도
        
        self.configuration?.titleAlignment = .center
        self.configuration?.background.backgroundColor = .terningMain
        self.configuration?.background.cornerRadius = 5
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
