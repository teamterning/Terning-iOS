//
//  InavailableFilterView.swift
//  Terning-iOS
//
//  Created by 김민성 on 7/11/24.
//

import UIKit

import SnapKit
import Then

class InavailableFilterView: UICollectionViewCell {
    
    
    // MARK: - UIComponents
    
    private let inavailableIcon = UIImageView().then {
        $0.image = UIImage(systemName: "exclamationmark.circle.fill")
        $0.tintColor = .grey200
    }
    
    private let inavailableLabel = LabelFactory.build(
        text: "필터링 설정에 일치하는 인턴 공고가 없어요! \n 딱 맞는 인턴 공고가 올라오면 바로 알려드릴게요",
        font: .body4,
        textColor: .grey400,
        textAlignment: .center
    ).then {
        
        $0.numberOfLines = 2
    }
    
    // MARK: - LifeCycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setHierarchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension InavailableFilterView {
    private func setHierarchy() {
        contentView.addSubviews(
            inavailableIcon,
            inavailableLabel
        )
    }
    
    private func setLayout() {
        inavailableIcon.snp.makeConstraints {
            $0.top.equalToSuperview().offset(100)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(36)
            $0.width.equalTo(36)
        }
        
        inavailableLabel.snp.makeConstraints {
            $0.top.equalTo(inavailableIcon.snp.bottom)
            $0.centerX.equalToSuperview()
        }
    }
}

// MARK: - Bind

extension InavailableFilterView {
    public func bind(title: String) {
        let fullText: String
        let finalTitle: String
        
        if title.count > 16 {
            finalTitle = "\(title.prefix(16))..."
            fullText = "\(finalTitle)에\n해당하는 검색 결과가 없어요"
        } else {
            finalTitle = title
            fullText = "\(finalTitle)에 해당하는 검색 결과가 없어요"
        }
        
        let attributedString = NSMutableAttributedString(string: fullText)
        
        let titleRange = (fullText as NSString).range(of: finalTitle)
        attributedString.addAttribute(.foregroundColor, value: UIColor.terningMain, range: titleRange)
        
        inavailableLabel.attributedText = attributedString
        
        inavailableLabel.snp.updateConstraints {
            $0.top.equalTo(inavailableIcon.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
    }
}
