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
    
    let inavailableIcon = UIImageView().then {
        $0.image = UIImage(systemName: "exclamationmark.circle.fill")
        $0.tintColor = .grey200
    }
    
    let inavailableLabel = LabelFactory.build(text: "필터링 설정에 일치하는 인턴 공고가 없어요! \n 딱 맞는 인턴 공고가 올라오면 바로 알려드릴게요", font: .body4, textColor: .grey400, textAlignment: .center).then {
        
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
    func setHierarchy() {
        contentView.addSubviews(
            inavailableIcon,
            inavailableLabel
        )
    }
    
    func setLayout() {
        inavailableIcon.snp.makeConstraints {
            $0.top.equalToSuperview().offset(78)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(36)
            $0.width.equalTo(36)
        }
        
        inavailableLabel.snp.makeConstraints {
            $0.top.equalTo(inavailableIcon.snp.bottom).offset(9)
            $0.centerX.equalToSuperview()
        }
    }
}
