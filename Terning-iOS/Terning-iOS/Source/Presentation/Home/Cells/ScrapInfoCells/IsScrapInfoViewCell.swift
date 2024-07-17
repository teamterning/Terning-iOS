//
//  IsScrapInfoViewCell.swift
//  Terning-iOS
//
//  Created by 김민성 on 7/10/24.
//

import UIKit

import SnapKit
import Then

final class IsScrapInfoViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    private var internshipAnnouncementId: Double = 1
    private var scrapId: Double = 1
    private var companyImage: UIImage = UIImage(resource: .icHomeFill)
    private var dDay = "D-day"
    private var deadline = "2024년 7월 14일"
    private var workingPeriod = "2개월"
    private var startYearMonth = "2025년 10월"
    
    // MARK: - UIComponents
    
    private let scrapAndDeadlineCard = UIView().then {
        $0.backgroundColor = .white
        $0.makeBorder(width: 1, color: .grey150, cornerRadius: 5)
    }
    
    private let colorMark = UIView().then {
        $0.backgroundColor = .black
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        $0.makeBorder(width: 0, color: .clear, cornerRadius: 5)
        $0.clipsToBounds = true
    }
    
    private let cardLabel = LabelFactory.build(
        text: "[유한킴벌리] 그린캠프 w.대학생 숲활동가 모집3",
        font: .button3,
        textAlignment: .left
    ).then {
        $0.numberOfLines = 3
        $0.isUserInteractionEnabled = true
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

extension IsScrapInfoViewCell {
    private func setHierarchy() {
        contentView.addSubviews(
            scrapAndDeadlineCard,
            colorMark,
            cardLabel
        )
    }
    
    private func setLayout() {
        scrapAndDeadlineCard.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.leading.equalToSuperview().offset(8)
        }
        
        colorMark.snp.makeConstraints {
            $0.verticalEdges.equalTo(scrapAndDeadlineCard)
            $0.leading.equalTo(scrapAndDeadlineCard)
            $0.width.equalTo(8)
        }
        
        cardLabel.snp.makeConstraints {
            $0.bottom.equalTo(scrapAndDeadlineCard.snp.bottom).inset(8)
            $0.leading.equalTo(colorMark.snp.trailing).offset(8)
            $0.width.equalTo(115)
        }
    }
    
    // MARK: - Methods
    
    func bindData(model: ScrapedAndDeadlineModel) {
        self.scrapId = model.scrapId
        self.internshipAnnouncementId = model.internshipAnnouncementId
        self.companyImage = model.companyImage
        self.cardLabel.text = model.title
        self.dDay = model.dDay
        self.deadline = model.deadLine
        self.workingPeriod = model.workingPeriod
        self.startYearMonth = model.startYearMonth
        self.colorMark.backgroundColor = UIColor(hex: model.color)
    }
}
