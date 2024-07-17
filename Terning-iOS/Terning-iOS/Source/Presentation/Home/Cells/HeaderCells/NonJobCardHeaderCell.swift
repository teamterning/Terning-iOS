//
//  NonJobCardHeaderCell.swift
//  Terning-iOS
//
//  Created by 김민성 on 7/16/24.
//

import UIKit

import SnapKit
import Then

final class NonJobCardHeaderCell: UICollectionReusableView {
    
    // MARK: - Properties
    
    var filtetButtonDelegate: FilteringButtonDidTapProtocol?
    
    // MARK: - UIComponents
    
    // 상단 타이틀
    private let subTitleLabel = LabelFactory.build(
        text: "마음에 드는 공고를 스크랩하고 캘린더에서 모아보세요",
        font: .detail2,
        textColor: .terningBlack
    )
    
    private let titleLabel = LabelFactory.build(
        text: "내 계획에 딱 맞는 대학생 인턴 공고",
        font: .title1,
        textColor: .terningBlack
    )
    
    private lazy var titleStack = UIStackView(
        arrangedSubviews: [
            subTitleLabel,
            titleLabel
        ]
    ).then {
        $0.axis = .vertical
        $0.spacing = 5
        $0.alignment = .leading
    }
    
    // 필터링 버튼 및 필터링 상태 표시 바
    private lazy var filterButton = FilterButton()
    
    private let grade = LabelFactory.build(
        text: "-",
        font: .detail2,
        textColor: .black
    )
    
    private let period = LabelFactory.build(
        text: "-",
        font: .detail2,
        textColor: .black
    )
    
    private let month = LabelFactory.build(
        text: "-",
        font: .detail2,
        textColor: .black
    )
    
    private let verticalBar1 = UIImageView().then {
        $0.image = UIImage(resource: .icVerticalBar)
    }
    
    private let verticalBar2 = UIImageView().then {
        $0.image = UIImage(resource: .icVerticalBar)
    }
    
    private lazy var FilteringStack = UIStackView(
        arrangedSubviews: [
            filterButton,
            grade,
            verticalBar1,
            period,
            verticalBar2,
            month
        ]
    ).then {
        $0.axis = .horizontal
        $0.spacing = 45
        $0.distribution = .fillProportionally
        $0.alignment = .center
    }
    
    // 구분선
    private let decorationView = UIView().then {
        $0.backgroundColor = .grey150
    }
    
    // MARK: - LifeCycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setHierarchy()
        setLayout()
        setAddTarget()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension NonJobCardHeaderCell {
    private func setHierarchy() {
        addSubviews(
            titleStack,
            FilteringStack,
            decorationView
        )
    }
    
    private func setLayout() {
        titleStack.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.height.equalTo(42)
        }
        
        FilteringStack.snp.makeConstraints {
            $0.top.equalTo(titleStack.snp.bottom).offset(9)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().inset(35)
        }
        
        filterButton.snp.makeConstraints {
            $0.height.equalTo(28)
            $0.width.equalTo(75)
        }
        
        verticalBar1.snp.makeConstraints {
            $0.height.equalTo(20)
            $0.width.equalTo(2)
        }
        
        verticalBar2.snp.makeConstraints {
            $0.height.equalTo(20)
            $0.width.equalTo(2)
        }
        
        decorationView.snp.makeConstraints {
            $0.top.equalTo(FilteringStack.snp.bottom).offset(11)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(4)
        }
    }
    
    // MARK: - Methods
    
    private func setAddTarget() {
        filterButton.addTarget(self, action: #selector(filteringButtonDidTap), for: .touchUpInside)
    }
    
    // objc Functions
    
    @objc
    private func filteringButtonDidTap() {
        print("tap")
        filtetButtonDelegate?.filteringButtonTapped()
    }
}
