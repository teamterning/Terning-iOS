//
//  FilterInfoCell.swift
//  Terning-iOS
//
//  Created by 이명진 on 7/19/24.
//

import UIKit

import SnapKit
import Then

protocol FilterButtonProtocol: AnyObject {
    func filterButtonDidTap()
}

protocol SortButtonProtocol: AnyObject {
    func sortButtonTap()
}

final class FilterInfoCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    private let sortSettingVC = SortSettingViewController()
    var totalCount: Int = 4
    
    // MARK: - UIComponents
    
    private let titleLabel = LabelFactory.build(
        text: "내 계획에 딱 맞는 대학생 인턴 공고",
        font: .title1,
        textColor: .terningBlack
    )
    
    private lazy var titleStack = UIStackView( // 나중에 교체
        arrangedSubviews: [
            titleLabel
        ]
    ).then {
        $0.axis = .vertical
        $0.spacing = 5
        $0.alignment = .leading
    }
    
    // 필터링 버튼 및 필터링 상태 표시 바
    private lazy var filterButton = FilterButton()
    
    weak var filterDelegate: FilterButtonProtocol?
    weak var sortDelegate: SortButtonProtocol?
    
    var gradeLabel = LabelFactory.build(
        text: "3학년",
        font: .body5,
        textColor: .grey400,
        lineSpacing: 1.2,
        characterSpacing: 0.002

    )
    
    var periodLabel = LabelFactory.build(
        text: "1~3개월",
        font: .body5,
        textColor: .grey400,
        lineSpacing: 1.2,
        characterSpacing: 0.002

    )
    
    var monthLabel = LabelFactory.build(
        text: "2024년 1월",
        font: .body5,
        textColor: .grey400,
        lineSpacing: 1.2,
        characterSpacing: 0.002
    )
    
    private let distinction1 = UIImageView().then {
        $0.image = UIImage(resource: .icDistinction)
    }
    
    private let distinction2 = UIImageView().then {
        $0.image = UIImage(resource: .icDistinction)
    }
    
    // 필터링 정보가 존재할 때
    private lazy var filteringStack = UIStackView(
        arrangedSubviews: [
            gradeLabel,
            distinction1,
            periodLabel,
            distinction2,
            monthLabel
        ]
    ).then {
        $0.axis = .horizontal
        $0.spacing = 6
        $0.distribution = .equalSpacing
        $0.alignment = .center
    }
    
    // 필터링 정보가 없을 때
    let nonFilteringLabel = LabelFactory.build(
        text: "설정된 필터링 정보가 없어요",
        font: .body5,
        textColor: .grey400
    )
    
    // 공고 개수 알려주는 라벨
    lazy var totalCountLabel = LabelFactory.build(
        text: "총 \(totalCount)개의 공고가 있어요",
        font: .body3,
        textColor: .grey400
    ).then {
        $0.setAttributedText(targetFontList: ["\(totalCount)": .body3], targetColorList: ["\(totalCount)": .terningMain])
    }
    
    // 정렬 버튼
    var sortButtonLabel = LabelFactory.build(
        text: "채용 마감 이른 순",
        font: .button3
    ).then {
        $0.isUserInteractionEnabled = true
    }
    
    var sortButtonIcon = UIImageView().then {
        $0.image = UIImage(resource: .icDownArrow)
    }
    
    lazy var sortButtonStack = UIStackView(
        arrangedSubviews: [
            sortButtonLabel,
            sortButtonIcon
        ]
    ).then {
        $0.axis = .horizontal
        $0.spacing = 4
        $0.alignment = .center
        $0.isUserInteractionEnabled = true
    }
    
    // MARK: - LifeCycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setHierarchy()
        setLayout()
        setAddTarget()
        setTapGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension FilterInfoCell {
    func setHierarchy() {
        addSubviews(
            titleStack,
            filterButton,
            filteringStack,
            totalCountLabel,
            sortButtonStack
        )
    }
    
    func setLayout() {
        titleStack.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(24)
        }
        
        filterButton.snp.makeConstraints {
            $0.top.equalTo(titleStack.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(24)
        }

        filteringStack.snp.makeConstraints {
            $0.top.equalTo(titleStack.snp.bottom).offset(19)
            $0.trailing.equalToSuperview().inset(24)
            $0.width.equalTo(196.adjusted)
        }
        
        filterButton.snp.makeConstraints {
            $0.height.equalTo(28.adjustedH)
            $0.width.equalTo(75.adjusted)
        }
        
        distinction1.snp.makeConstraints {
            $0.height.equalTo(4.adjustedH)
            $0.width.equalTo(4.adjusted)
        }
        
        distinction2.snp.makeConstraints {
            $0.height.equalTo(4.adjustedH)
            $0.width.equalTo(4.adjusted)
        }
        
        totalCountLabel.snp.makeConstraints {
            $0.top.equalTo(filteringStack.snp.bottom).offset(28)
            $0.leading.equalToSuperview().offset(26)
        }
        
        sortButtonStack.snp.makeConstraints {
            $0.top.equalTo(filteringStack.snp.bottom).offset(28)
            $0.trailing.equalToSuperview().inset(16)
        }
    }
    
    func setAddTarget() {
        filterButton.addTarget(self, action: #selector(filterButtonDidTap), for: .touchUpInside)
    }
    
    func setTapGesture() {
        let sortTapGesture = UITapGestureRecognizer(target: self, action: #selector(sortButtonDidTap))
        sortButtonStack.addGestureRecognizer(sortTapGesture)
    }
    
    @objc func filterButtonDidTap() {
        print("filterButton is clicked")
        filterDelegate?.filterButtonDidTap()
    }
    
    @objc func sortButtonDidTap() {
        print("sortButton is clicked")
        sortDelegate?.sortButtonTap()
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
    
    func countBind(_ num: Int) {
        print("total: \(num)")
        totalCountLabel.text = "총 \(num)개의 공고가 있어요"
        totalCountLabel.setAttributedText(targetFontList: ["\(num)": .body3], targetColorList: ["\(num)": .terningMain])
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
        case 0: return "1~3개월"
        case 1: return "4~6개월"
        case 2: return "7개월 이상"
        default: return "-"
        }
    }
}
