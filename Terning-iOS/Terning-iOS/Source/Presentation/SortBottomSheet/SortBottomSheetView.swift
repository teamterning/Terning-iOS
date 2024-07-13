//
//  SortBottomSheetView.swift
//  Terning-iOS
//
//  Created by 김민성 on 7/12/24.
//

import UIKit

import SnapKit
import Then

class SortBottomSheetView: UIView {
    
    // MARK: - UICompoenents
    
    let sortBottomSheetTitle = LabelFactory.build(
        text: "공고 정렬 순서",
        font: .title2
    )
    
    let seperateLine = UIView().then {
        $0.backgroundColor = .grey200
    }
    
    lazy var sortByDeadline = UIButton().then {
        $0.setTitle("채용 마감 이른순 ", for: .normal)
        $0.backgroundColor = .clear
        $0.titleLabel?.font = .button3
        $0.setTitleColor(.grey400, for: .normal)
        $0.addTarget(self, action: #selector(sortButtonSelected), for: .touchUpInside)
    }
    
    lazy var sortByShortPeriod = UIButton().then {
        $0.setTitle("짧은 근무 기간순 ", for: .normal)
        $0.backgroundColor = .clear
        $0.titleLabel?.font = .button3
        $0.setTitleColor(.grey400, for: .normal)
    }
    
    lazy var sortByLongPeriod = UIButton().then {
        $0.setTitle("긴 근무 기간순 ", for: .normal)
        $0.backgroundColor = .clear
        $0.titleLabel?.font = .button3
        $0.setTitleColor(.grey400, for: .normal)
    }
    
    lazy var sortByClippings = UIButton().then {
        $0.setTitle("스크랩 많은순 ", for: .normal)
        $0.backgroundColor = .clear
        $0.titleLabel?.font = .button3
        $0.setTitleColor(.grey400, for: .normal)
    }
    
    lazy var sortByViews = UIButton().then {
        $0.setTitle("조회수 많은순 ", for: .normal)
        $0.backgroundColor = .clear
        $0.titleLabel?.font = .button3
        $0.setTitleColor(.grey400, for: .normal)
    }
    
    lazy var sortButtonStack = UIStackView(arrangedSubviews: [sortByDeadline, sortByLongPeriod, sortByShortPeriod, sortByClippings, sortByViews]).then {
        $0.axis = .vertical
        $0.spacing = 10
        $0.alignment = .leading
        $0.distribution = .fillEqually
    }
    
    // MARK: LifeCycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierarchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extensions

extension SortBottomSheetView {
    
    // MARK: - Methods
    
    func setUI() {
        backgroundColor = .white
    }
    
    func setHierarchy() {
        addSubviews(
            sortBottomSheetTitle,
            seperateLine,
            sortButtonStack
        )
    }
    
    func setLayout() {
        sortBottomSheetTitle.snp.makeConstraints {
            $0.top.equalToSuperview().offset(40)
            $0.leading.equalToSuperview().offset(29)
        }
        
        seperateLine.snp.makeConstraints {
            $0.top.equalTo(sortBottomSheetTitle.snp.bottom).offset(15)
            $0.horizontalEdges.equalToSuperview().inset(25)
            $0.height.equalTo(1)
        }
        
        sortButtonStack.snp.makeConstraints {
            $0.top.equalToSuperview().offset(95)
            $0.horizontalEdges.equalToSuperview().inset(25)
            $0.height.equalTo(240)
        }
    }
    
    @objc private func sortButtonSelected() {
        print("zz")
    }
    
}
