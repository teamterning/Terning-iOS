//
//  JobCardScrapedCell.swift
//  Terning-iOS
//
//  Created by 김민성 on 7/10/24.
//

import UIKit

class JobCardScrapedCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    // MARK: - UIComponents
    
    let jobCard = UIView().then {
        $0.backgroundColor = UIColor.white
        $0.layer.cornerRadius = 10
        $0.layer.applyShadow(color: .black, alpha: 0.25, x: 0, y: 0, blur: 4, spread: 0
        )
    }
    
    var jobCardCoverImage = UIImageView().then {
        $0.image = UIImage(resource: .icHome)
    }
    
    var daysRemaining = LabelFactory.build(
        text: "D-2",
        font: .detail0,
        textColor: .terningMain,
        textAlignment: .left
    )
    
    var jobLabel = LabelFactory.build(
        text: "[Someone's Cat] 콘텐츠 마케터 대학생 인턴 채용",
        font: .title5,
        textColor: .black,
        textAlignment: .left
    ).then {
        $0.numberOfLines = 2
    }
    
    var periodTitle = LabelFactory.build(
        text: "근무기간",
        font: .detail3,
        textColor: .grey400,
        textAlignment: .left
    )
    
    var period = LabelFactory.build(
        text: "2개월",
        font: .detail3,
        textColor: .terningMain,
        textAlignment: .left
    )
    
    lazy var scrapButton = UIButton().then {
        $0.setImage(.icScrap, for: .normal)
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
extension JobCardScrapedCell {
    func setHierarchy() {
        contentView.addSubviews(
            jobCard,
            jobCardCoverImage,
            daysRemaining,
            jobLabel,
            periodTitle,
            period,
            scrapButton
        )
    }
    
    func setLayout() {
        
        jobCard.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(100)
        }
        
        jobCardCoverImage.snp.makeConstraints {
            $0.top.equalTo(jobCard.snp.top).offset(12)
            $0.leading.equalTo(jobCard.snp.leading).offset(12)
            $0.width.height.equalTo(72)
        }
        
        daysRemaining.snp.makeConstraints {
            $0.top.equalTo(jobCard.snp.top).offset(12)
            $0.leading.equalTo(jobCardCoverImage.snp.trailing).offset(8)
        }
        
        jobLabel.snp.makeConstraints {
            $0.top.equalTo(jobCard.snp.top).offset(29)
            $0.leading.equalTo(jobCardCoverImage.snp.trailing).offset(8)
            $0.trailing.equalTo(jobCard.snp.trailing).inset(22)
        }
        
        periodTitle.snp.makeConstraints {
            $0.bottom.equalTo(jobCard.snp.bottom).inset(9)
            $0.leading.equalTo(jobCardCoverImage.snp.trailing).offset(8)
        }
        
        period.snp.makeConstraints {
            $0.bottom.equalTo(jobCard.snp.bottom).inset(9)
            $0.leading.equalTo(periodTitle.snp.trailing).offset(4)
        }
        
        scrapButton.snp.makeConstraints {
            $0.top.equalTo(jobCard.snp.top).offset(62)
            $0.trailing.equalTo(jobCard.snp.trailing).inset(17)
        }
    }
    
    func bindData(
        coverImage: UIImage,
        daysRemaining: String,
        title: String,
        period: String
    ) {
        self.jobCardCoverImage.image = coverImage
        self.daysRemaining.text = daysRemaining
        self.jobLabel.text = title
        self.period.text = period
    }
    
}
