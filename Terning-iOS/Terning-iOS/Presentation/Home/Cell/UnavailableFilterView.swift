//
//  UnavailableFilterView.swift
//  Terning-iOS
//
//  Created by 김민성 on 7/11/24.
//

import UIKit

import SnapKit
import Then

final class UnavailableFilterView: UICollectionViewCell {
    
    // MARK: - UIComponents
    
    private let inavailableImageView = UIImageView().then {
        $0.image = .imgNonCardViewInfo
        $0.tintColor = .grey200
    }
    
    private let inavailableLabel = LabelFactory.build(
        text: "필터링 설정에 일치하는 인턴 공고가 없어요!",
        font: .detail2,
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

extension UnavailableFilterView {
    private func setHierarchy() {
        contentView.addSubviews(
            inavailableImageView,
            inavailableLabel
        )
    }
    
    private func setLayout() {
        inavailableImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.height.equalTo(222.adjustedH)
            $0.width.equalTo(327.adjusted)
        }
        
        inavailableLabel.snp.makeConstraints {
            $0.top.equalTo(inavailableImageView.snp.bottom).offset(9.adjustedH)
            $0.centerX.equalToSuperview()
        }
    }
}

// MARK: - Bind

extension UnavailableFilterView {
    public func bind(title: String) {
        let fullText: String
        let finalTitle: String
        
        if title.count > 16 {
            finalTitle = "\(title.prefix(16))..."
            fullText = "\(finalTitle)에\n해당하는 검색 결과가 없어요"
        } else {
            finalTitle = title
            fullText = "\(finalTitle)에\n해당하는 검색 결과가 없어요"
        }
        
        let attributedString = NSMutableAttributedString(string: fullText)
        // 글자 수가 16자 이상일 때
        if title.count > 16 {
            let titleRange = (fullText as NSString).range(of: finalTitle)
            attributedString.addAttributes([
                .font: UIFont.title4,
                .foregroundColor: UIColor.terningMain
            ], range: titleRange)
            
            let bodyRange = (fullText as NSString).range(of: "에\n해당하는 검색 결과가 없어요")
            attributedString.addAttribute(.font, value: UIFont.body1, range: bodyRange)
        } else {
            // 글자 수가 16자 미만일 때
            let titleRange = (fullText as NSString).range(of: finalTitle)
            attributedString.addAttributes([
                .font: UIFont.title4,
                .foregroundColor: UIColor.terningMain
            ], range: titleRange)
            
            let bodyRange = (fullText as NSString).range(of: "에\n해당하는 검색 결과가 없어요")
            attributedString.addAttribute(.font, value: UIFont.body1, range: bodyRange)
        }
        
        inavailableLabel.attributedText = attributedString
        
        inavailableImageView.snp.updateConstraints {
            $0.top.equalToSuperview().inset(40.adjustedH)
        }
        
        inavailableLabel.snp.updateConstraints {
            $0.top.equalTo(inavailableImageView.snp.bottom).offset(16.adjustedH)
        }
    }
}
