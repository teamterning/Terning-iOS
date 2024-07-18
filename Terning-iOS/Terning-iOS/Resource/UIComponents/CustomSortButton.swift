//
//  CustomSortButton.swift
//  Terning-iOS
//
//  Created by 정민지 on 7/17/24.
//

import UIKit

final class CustomSortButton: UIButton {
    
    // MARK: - Properties
   
    // MARK: - Init
    
    public init() {
        
        super.init(frame: .zero)
        
        setStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension CustomSortButton {
    private func setStyle() {
        setTitle("채용 마감 이른순", for: .normal)
        
        setTitleColor(.terningBlack, for: .normal)
        titleLabel?.font = .button3
        
        setImage(.icDownArrow, for: .normal)
        imageView?.contentMode = .scaleAspectFit
        
        semanticContentAttribute = .forceRightToLeft
        
        backgroundColor = .clear
        
        contentHorizontalAlignment = .right
        contentVerticalAlignment = .center
        
        self.snp.makeConstraints {
            $0.height.equalTo(17)
            $0.width.equalTo(128)
        }
    }
}
