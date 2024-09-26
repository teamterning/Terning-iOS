//  JobCardScrapedCell.swift
//  Terning-iOS
//
//  Created by 김민성 on 7/10/24.
//

import UIKit

import SnapKit
import Then

protocol JobCardScrapedCellProtocol: AnyObject {
    func scrapButtonDidTap(index: Int)
}

final class JobCardCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    weak var delegate: JobCardScrapedCellProtocol?
    
    private var isScrapButtonSelected: Bool = false
    private var internshipAnnouncementId: Int? = 0
    private var scrapId: Int?
    private var indexPath: Int?
    
    // MARK: - UIComponents
    
    private let jobCard = UIView().then {
        $0.backgroundColor = UIColor.white
        $0.layer.cornerRadius = 10
        $0.layer.applyShadow(color: .greyShadow, alpha: 1, x: 0, y: 0, blur: 3, spread: 0)
    }
    
    private let jobCardCoverImage = UIImageView().then {
        $0.image = UIImage(resource: .icHome)
        $0.contentMode = .scaleAspectFit
    }
    
    private let daysRemaining = LabelFactory.build(
        text: "D-2",
        font: .detail0,
        textColor: .terningMain,
        textAlignment: .left
    )
    
    private let jobLabel = LabelFactory.build(
        text: "[Someone's Cat] 콘텐츠 마케터 대학생 인턴 채용",
        font: .title5,
        textColor: .black,
        textAlignment: .left
    ).then {
        $0.numberOfLines = 2
    }
    
    private let periodTitle = LabelFactory.build(
        text: "근무기간",
        font: .detail3,
        textColor: .grey400,
        textAlignment: .left
    )
    
    private let period = LabelFactory.build(
        text: "2개월",
        font: .detail3,
        textColor: .terningMain,
        textAlignment: .left
    )
    
    lazy var scrapButton = UIButton().then {
        $0.setImage(.icScrap, for: .normal)
        $0.setImage(.icScrap, for: [.normal, .highlighted])
        $0.setImage(.icScrapFill, for: .selected)
        $0.setImage(.icScrapFill, for: [.selected, .highlighted])
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

extension JobCardCell {
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
            $0.height.equalTo(100.adjustedH)
        }
        
        jobCardCoverImage.snp.makeConstraints {
            $0.top.equalTo(jobCard.snp.top).offset(12)
            $0.leading.equalTo(jobCard.snp.leading).offset(12)
            $0.width.height.equalTo(72.adjusted)
        }
        
        daysRemaining.snp.makeConstraints {
            $0.top.equalTo(jobCard.snp.top).offset(12)
            $0.leading.equalTo(jobCardCoverImage.snp.trailing).offset(8)
        }
        
        jobLabel.snp.makeConstraints {
            $0.top.equalTo(jobCard.snp.top).offset(30)
            $0.leading.equalTo(jobCardCoverImage.snp.trailing).offset(8)
            $0.trailing.equalTo(jobCard.snp.trailing).inset(50)
        }
        
        periodTitle.snp.makeConstraints {
            $0.bottom.equalTo(jobCard.snp.bottom).inset(12)
            $0.leading.equalTo(jobCardCoverImage.snp.trailing).offset(8)
        }
        
        period.snp.makeConstraints {
            $0.bottom.equalTo(jobCard.snp.bottom).inset(12)
            $0.leading.equalTo(periodTitle.snp.trailing).offset(4)
        }
        
        scrapButton.snp.makeConstraints {
            $0.top.equalTo(jobCard.snp.top).offset(62)
            $0.trailing.equalTo(jobCard.snp.trailing).inset(12)
        }
    }
    
    // MARK: - Methods
    
    private func setAddTarget() {
        scrapButton.addTarget(self, action: #selector(scrapButtonDidTap), for: .touchUpInside)
    }
    
    func bind(model: AnnouncementModel, indexPath: IndexPath) {
        if model.dDay == "지원마감" {
            self.daysRemaining.textColor = .grey300
        } else {
            self.daysRemaining.textColor = .terningMain
        }
        
        self.internshipAnnouncementId = model.internshipAnnouncementId
        self.jobCardCoverImage.setImage(with: model.companyImage, placeholder: "placeholder_image")
        self.daysRemaining.text = model.dDay
        self.jobLabel.text = model.title
        self.period.text = model.workingPeriod
        self.indexPath = indexPath.item
        self.scrapButton.isSelected = model.isScrapped
    }
    
    // MARK: - objc Functions
    
    @objc
    func scrapButtonDidTap(_ sender: UIButton) {
        guard let internshipAnnouncementId = self.indexPath else { return }
        
        self.isScrapButtonSelected = sender.isSelected
        
        delegate?.scrapButtonDidTap(index: internshipAnnouncementId)
    }
}
