//
//  FilterInfoCell.swift
//  Terning-iOS
//
//  Created by 이명진 on 7/19/24.
//

import UIKit

import SnapKit
import Then

final class FilterInfoCell: UICollectionViewCell {
    
    // MARK: - UIComponents
    
    // 필터링 버튼 및 필터링 상태 표시 바
    private lazy var filterButton = FilterButton()
    
    var gradeLabel = LabelFactory.build(
        text: "3학년",
        font: .detail2,
        textColor: .black
    )
    
    var periodLabel = LabelFactory.build(
        text: "1~3개월",
        font: .detail2,
        textColor: .black
    )
    
    var monthLabel = LabelFactory.build(
        text: "2024년 1월",
        font: .detail2,
        textColor: .black,
        textAlignment: .left,
        lineSpacing: 1.2,
        characterSpacing: 0.002
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
            gradeLabel,
            verticalBar1,
            periodLabel,
            verticalBar2,
            monthLabel
        ]
    ).then {
        $0.axis = .horizontal
        $0.spacing = 20
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension FilterInfoCell {
    func setHierarchy() {
        addSubviews(
            FilteringStack,
            decorationView
        )
    }
    
    func setLayout() {
        FilteringStack.snp.makeConstraints {
            $0.top.equalToSuperview().offset(9)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().inset(26.adjusted)
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
}

extension FilterInfoCell {
    func bind(model: UserFilteringInfoModel) {
        guard let grade = model.grade,
                let workingPeriod = model.workingPeriod,
              let startYear = model.startYear,
              let startMonth = model.startMonth else { return }
        
        gradeLabel.text = gradeText(for: grade)
        periodLabel.text = periodText(for: workingPeriod)
        monthLabel.text = "\(startYear)년 \(startMonth)월"
    }
    
    private func gradeText(for grade: Int) -> String {
        switch grade {
        case 0: return "1학년"
        case 1: return "2학년"
        case 2: return "3학년"
        case 3: return "4학년"
        default: return "-"
        }
    }
    
    private func periodText(for period: Int) -> String {
        switch period {
        case 0: return "1개월 ~ 3개월"
        case 1: return "4개월 ~ 6개월"
        case 2: return "7개월 이상"
        default: return "-"
        }
    }
}
