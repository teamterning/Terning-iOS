//
//  TestHeaderCell.swift
//  Terning-iOS
//
//  Created by 김민성 on 7/15/24.
//

import UIKit

import SnapKit
import Then

protocol FilteringButtonDidTapProtocol {
    func filteringButtonTapped()
}

protocol SortButtonDidTapProtocol {
    func sortButtonTapped()
}

final class FilterHeaderCell: UICollectionReusableView {
    
    // MARK: - Properties
    
    var filtetButtonDelegate: FilteringButtonDidTapProtocol?
    var sortButtonDelegate: SortButtonDidTapProtocol?
    
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
    
    var grade = LabelFactory.build(
        text: "3학년",
        font: .detail2,
        textColor: .black
    )
        
    var period = LabelFactory.build(
        text: "1~3개월",
        font: .detail2,
        textColor: .black
    )
    
    var month = LabelFactory.build(
        text: "2024년 1월",
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
        $0.spacing = 23
        $0.distribution = .fillProportionally
        $0.alignment = .center
    }
    
    // 구분선
    private let decorationView = UIView().then {
        $0.backgroundColor = .grey150
    }
    
    // 정렬 버튼
    var sortButtonLabel = LabelFactory.build(
        text: "채용 마감 이른 순",
        font: .button3,
        textColor: .terningBlack,
        textAlignment: .center
    ).then {
        $0.isUserInteractionEnabled = true
    }
    
    var sortButtonIcon = UIImageView().then {
        $0.image = UIImage(resource: .icDownArrow)
    }
    
    lazy var sortButtonStack = UIStackView(arrangedSubviews: [sortButtonLabel, sortButtonIcon]).then {
        $0.axis = .horizontal
        $0.spacing = 4
        $0.alignment = .center
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

extension FilterHeaderCell {
    func setHierarchy() {
        addSubviews(titleStack, FilteringStack, decorationView, sortButtonStack)
    }
    
    func setLayout() {
        titleStack.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.height.equalTo(42)
        }
        
        FilteringStack.snp.makeConstraints {
            $0.top.equalTo(titleStack.snp.bottom).offset(9)
            $0.leading.equalToSuperview().offset(20)
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
        
        sortButtonStack.snp.makeConstraints {
            $0.top.equalTo(decorationView.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(280)
        }
    }
    
    // MARK: - Methods
    
    private func setAddTarget() {
        filterButton.addTarget(self, action: #selector(filteringButtonDidTap), for: .touchUpInside)
    }
    
    func bindData(model: UserFilteringInfoModel) {
        
        grade.text = gradeText(for: model.grade)
        period.text = periodText(for: model.workingPeriod)
        month.text = "\(model.startYear)년 \(model.startMonth)월"
    }
    // objc Functions
    
    @objc
    func filteringButtonDidTap() {
        print("tap")
        filtetButtonDelegate?.filteringButtonTapped()
    }
}


extension FilterHeaderCell {
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
