//
//  EmptyView.swift
//  Terning-iOS
//
//  Created by 이명진 on 9/14/24.
//

import UIKit

import SnapKit
import Then

final class EmptyView: UIView {
    
    // MARK: - UIComponents
    
    private let emptyView = UIView().then {
        $0.backgroundColor = .back
        $0.isHidden = true
    }
    
    private let emptyImage = UIImageView().then {
        $0.image = .imgEmptyTerning
    }
    
    private let emptyLabel = LabelFactory.build(
        text: "선택하신 날짜에 지원 마감인 스크랩 공고가 없어요",
        font: .body5,
        textColor: .grey400,
        lineSpacing: 1.2,
        characterSpacing: 0.002
    )
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierarchy()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI & Layout
    
    private func setUI() {
        backgroundColor = .white
    }
    
    private func setHierarchy() {
        addSubview(emptyView)
        
        addSubviews(
            emptyImage,
            emptyLabel
        )
    }
    
    private func setLayout() {
        emptyView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        emptyImage.snp.makeConstraints {
            $0.top.equalTo(emptyView.snp.top).offset(32.adjustedH)
            $0.centerX.equalToSuperview()
        }
        
        emptyLabel.snp.makeConstraints {
            $0.top.equalTo(emptyImage.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
        }
    }
}
