//
//  Toast.swift
//  Terning-iOS
//
//  Created by 이명진 on 7/10/24.
//

import UIKit

import SnapKit
import Then

public class Toast {
    
    /// 토스트 메시지를 띄우는 함수입니다.
    /// verticalOffset 의 상수를 변경하여 원하는 위치로 높이를 지정 할 수 있습니다.
    /// default = 88
    static func show(
        message: String,
        view: UIView,
        safeAreaBottomInset: CGFloat = 0,
        height: CGFloat = 88
    ) {
        
        // MARK: - UI Components
        
        let toastContainer = UIView().then {
            $0.backgroundColor = .toastGrey.withAlphaComponent(0.95)
            $0.alpha = 1.0
            $0.layer.cornerRadius = 15
            $0.clipsToBounds = true
            $0.isUserInteractionEnabled = false
        }
        
        let toastLabel = LabelFactory.build(
            text: message,
            font: .button3,
            textColor: .white,
            textAlignment: .center,
            lineSpacing: 1.2,
            characterSpacing: 0.002
        ).then {
            $0.clipsToBounds = true
            $0.numberOfLines = 0
            $0.sizeToFit()
        }
        
        // MARK: - UI & Layout
        
        let toastConatinerWidth = toastLabel.intrinsicContentSize.width + 40.0
        
        view.addSubview(toastContainer)
        toastContainer.addSubview(toastLabel)
        
        toastContainer.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(safeAreaBottomInset + height)
            $0.width.equalTo(toastConatinerWidth)
            $0.height.equalTo(32)
        }
        
        toastLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        // MARK: - Animation
        
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseIn, animations: {
            toastContainer.alpha = 1.0
        }, completion: { _ in
            UIView.animate(withDuration: 1.0, delay: 2.0, options: .curveEaseOut, animations: {
                toastContainer.alpha = 0.0
            }, completion: {_ in
                toastContainer.removeFromSuperview()
            })
        })
    }
}
