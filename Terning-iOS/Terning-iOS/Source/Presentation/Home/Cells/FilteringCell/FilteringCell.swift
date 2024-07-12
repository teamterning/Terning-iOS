//
//  FilteringCell.swift
//  Terning-iOS
//
//  Created by 김민성 on 7/10/24.
//

import UIKit

import SnapKit
import Then

protocol FilteringButtonTappedProtocol {
    func filteringButtonTapped()
}

class FilteringCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var delegate: FilteringButtonTappedProtocol?
    
    // MARK: - UIComponents
    
    lazy var filterButton = FilterButton()
    
    var grade = LabelFactory.build(text: "3학년", font: .detail2, textColor: .black)
        
    var period = LabelFactory.build(text: "1~3개월", font: .detail2, textColor: .black)
    
    var month = LabelFactory.build(text: "1월", font: .detail2, textColor: .black)
    
    let verticalBar1 = UIImageView().then {
        $0.image = UIImage(resource: .icVerticalBar)
    }
    
    let verticalBar2 = UIImageView().then {
        $0.image = UIImage(resource: .icVerticalBar)
    }
    
    // MARK: - LifeCycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setHierarchy()
        setLayout()
        
        filterButton.addTarget(self, action: #selector(filteringButtonDidTap), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - UI & Layout

extension FilteringCell {
    func setHierarchy() {
        contentView.addSubviews(
            filterButton,
            grade,
            verticalBar1,
            period,
            verticalBar2,
            month
        )
    }
    
    func setLayout() {
        filterButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(55)
            $0.leading.equalToSuperview().offset(20)
            $0.height.equalTo(28)
            $0.width.equalTo(75)
        }
        
        grade.snp.makeConstraints {
            $0.top.equalToSuperview().offset(62)
            $0.leading.equalTo(filterButton.snp.trailing).offset(28)
        }
        
        verticalBar1.snp.makeConstraints {
            $0.top.equalToSuperview().offset(60)
            $0.leading.equalTo(grade.snp.trailing).offset(28)
        }
        
        period.snp.makeConstraints {
            $0.top.equalToSuperview().offset(62)
            $0.leading.equalTo(verticalBar1.snp.trailing).offset(25)
        }
        
        verticalBar2.snp.makeConstraints {
            $0.top.equalToSuperview().offset(60)
            $0.leading.equalTo(period.snp.trailing).offset(25)
        }
        
        month.snp.makeConstraints {
            $0.top.equalToSuperview().offset(62)
            $0.leading.equalTo(verticalBar2.snp.trailing).offset(34)
        }
    }
    
    // MARK: - button click event
    
    @objc
    func filteringButtonDidTap() {
        delegate?.filteringButtonTapped()
    }
}
