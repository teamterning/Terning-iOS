//
//  FilteringCell.swift
//  Terning-iOS
//
//  Created by 김민성 on 7/10/24.
//

import UIKit

class FilteringCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let filteringCellIdentifier = "FilteringCell"
    var thereScrap: Bool = true
    
    // MARK: - UIComponents
    
    lazy var filterButton = UIButton().then {
        $0.backgroundColor = UIColor(red: 30/255, green: 172/255, blue: 97/255, alpha: 1)
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = true
    }
    
    let filterLabel = UILabel().then {
        $0.text = "필터링"
        $0.textColor = .white
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 12)
    }
    
    let filterImage = UIImageView().then {
        $0.image = UIImage(resource: .icFilter)
    }
    
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Extensions

extension FilteringCell {
    func setHierarchy() {
        contentView.addSubviews(filterButton, filterLabel, filterImage, grade, verticalBar1, period, verticalBar2, month)
    }
    
    func setLayout() {
        filterButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(55)
            $0.leading.equalToSuperview().offset(20)
            $0.width.equalTo(75)
            $0.height.equalTo(28)
        }
        
        filterLabel.snp.makeConstraints {
            $0.top.equalTo(filterButton.snp.top).offset(7)
            $0.leading.equalTo(filterButton.snp.leading).offset(32)
        }
        
        filterImage.snp.makeConstraints {
            $0.verticalEdges.equalTo(filterButton)
            $0.leading.equalTo(filterButton.snp.leading).offset(2)
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
}

