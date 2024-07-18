//
//  SortHeaderCell.swift
//  Terning-iOS
//
//  Created by 정민지 on 7/17/24.
//

import UIKit

import RxSwift

import SnapKit

final class SortHeaderCell: UICollectionReusableView {
    
    // MARK: - UIComponents

    var sortButton = CustomSortButton()
    var sortBySubject = PublishSubject<String>()
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setHierarchy()
        setLayout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension SortHeaderCell {
    func setHierarchy() {
        addSubview(sortButton)
    }
    
    func setLayout() {
        sortButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(22)
            $0.centerY.equalToSuperview()
        }
    }
    
    private func bind() {
        sortButton.rx.tap
            .map { "정렬기준" }
            .bind(to: sortBySubject)
            .disposed(by: disposeBag)
    }
}
