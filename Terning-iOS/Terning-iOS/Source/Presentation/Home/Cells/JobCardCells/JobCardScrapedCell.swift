//
//  JobCardScrapedCell.swift
//  Terning-iOS
//
//  Created by 김민성 on 7/10/24.
//

import UIKit

import SnapKit
import Then

final class JobCardScrapedCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var internshipAnnouncementId: Int = 0
    
    // MARK: - UIComponents
    
    private let jobCard = UIView().then {
        $0.backgroundColor = UIColor.white
        $0.layer.cornerRadius = 10
        $0.layer.applyShadow(color: .black, alpha: 0.25, x: 0, y: 0, blur: 4, spread: 0)
    }
    
    private var jobCardCoverImage = UIImageView().then {
        $0.image = UIImage(resource: .icHome)
    }
    
    private var daysRemaining = LabelFactory.build(
        text: "D-2",
        font: .detail0,
        textColor: .terningMain,
        textAlignment: .left
    )
    
    private var jobLabel = LabelFactory.build(
        text: "[Someone's Cat] 콘텐츠 마케터 대학생 인턴 채용",
        font: .title5,
        textColor: .black,
        textAlignment: .left
    ).then {
        $0.numberOfLines = 2
    }
    
    private var periodTitle = LabelFactory.build(
        text: "근무기간",
        font: .detail3,
        textColor: .grey400,
        textAlignment: .left
    )
    
    private var period = LabelFactory.build(
        text: "2개월",
        font: .detail3,
        textColor: .terningMain,
        textAlignment: .left
    )
    
    lazy var scrapButton = UIButton().then {
        $0.setImage(.icScrapFill, for: .selected)
        $0.setImage(.icScrap, for: .normal)
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
    
    private func setAddTarget() {
        scrapButton.addTarget(self, action: #selector(scrapButtonDidTap), for: .touchUpInside)
    }
    
    // MARK: - Methods
    
    func bindData(model: JobCardModel) {
        self.internshipAnnouncementId = model.internshipAnnouncementId
//      self.jobCardCoverImage.setImage(with: model.companyImage) URL로 이미지 받아올 때 사용예시라 남겨놨습니다.
        self.jobCardCoverImage.image = model.companyImage
        self.daysRemaining.text = model.dDay
        self.jobLabel.text = model.title
        self.period.text = model.workingPeriod
        self.scrapButton.isSelected = model.isScraped
    }
    
    // MARK: - objc Functions
    
    @objc
    func scrapButtonDidTap() {
        print("scrap button")
    }
}
