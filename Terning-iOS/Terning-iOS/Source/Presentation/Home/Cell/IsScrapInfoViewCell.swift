//
//  IsScrapInfoViewCell.swift
//  Terning-iOS
//
//  Created by 김민성 on 7/10/24.
//

import UIKit

import SnapKit
import Then

protocol UpcomingCardCellProtocol {
    func upcomingCardDidTap(index: Int)
}

final class IsScrapInfoViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var upcomingCardDelegate: UpcomingCardCellProtocol?
    
    private var indexPath: Int?
    
    private var internshipAnnouncementId: Int = 1
    private var isScrapped: Bool = false
    private var companyImage: String = ""
    private var dDay = "D-day"
    private var deadline = "2024년 7월 14일"
    private var workingPeriod = "2개월"
    private var startYearMonth = "2025년 10월"
    
    // MARK: - UIComponents
    
    private let scrapAndDeadlineCard = UIView().then {
        $0.backgroundColor = .white
        $0.makeBorder(width: 1, color: .grey150, cornerRadius: 5)
        $0.isUserInteractionEnabled = true
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
        $0.numberOfLines = 2
        $0.isUserInteractionEnabled = true
    }
    
    private let companyImageView = UIImageView().then {
        $0.image = UIImage(resource: .default)
        $0.clipsToBounds = true
        $0.makeBorder(width: 1, color: .grey150, cornerRadius: 32/2)
    }
    
    private var companyName = LabelFactory.build(
        text: "기업 이름",
        font: .button5,
        textColor: .grey400,
        textAlignment: .left
    )
    
    private lazy var companyLabelStack = UIStackView(
        arrangedSubviews: [
            companyImageView,
            companyName
        ]
    ).then {
        $0.axis = .horizontal
        $0.spacing = 6
        $0.distribution = .equalSpacing
        $0.alignment = .center
    }
    
    private var dDayLabel = LabelFactory.build(
        text: "D-0",
        font: .body4,
        textColor: .terningMain
    )
    
    private var dDayView = UIView().then {
        $0.backgroundColor = .terningSub3
        $0.layer.cornerRadius = 5
    }
    
    // MARK: - LifeCycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setHierarchy()
        setLayout()
        setTapGesture()
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
            cardLabel,
            companyLabelStack,
            dDayView,
            dDayLabel
        )
    }
    
    private func setLayout() {
        scrapAndDeadlineCard.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        colorMark.snp.makeConstraints {
            $0.verticalEdges.equalTo(scrapAndDeadlineCard)
            $0.leading.equalTo(scrapAndDeadlineCard)
            $0.width.equalTo(8.adjusted)
        }
        
        cardLabel.snp.makeConstraints {
            $0.top.equalTo(scrapAndDeadlineCard.snp.top).offset(16)
            $0.leading.equalTo(colorMark.snp.trailing).offset(12)
            $0.width.equalTo(214.adjusted)
        }
        
        companyLabelStack.snp.makeConstraints {
            $0.top.equalTo(scrapAndDeadlineCard.snp.top).inset(72)
            $0.leading.equalTo(colorMark.snp.trailing).offset(12)
        }
        
        companyImageView.snp.makeConstraints {
            $0.height.width.equalTo(32.adjustedH)
        }
        
        dDayView.snp.makeConstraints {
            $0.top.equalTo(scrapAndDeadlineCard.snp.top).inset(78)
            $0.trailing.equalTo(scrapAndDeadlineCard.snp.trailing).inset(12)
            $0.height.equalTo(20.adjustedH)
            $0.width.equalTo(52.adjusted)
        }

        dDayLabel.snp.makeConstraints {
            $0.centerX.equalTo(dDayView)
            $0.centerY.equalTo(dDayView)
        }
    }
    
    func setTapGesture() {
        let upcomingCardTapGesture = UITapGestureRecognizer(target: self, action: #selector(upcomingCardDidTap))
        scrapAndDeadlineCard.addGestureRecognizer(upcomingCardTapGesture)
    }
    
    // MARK: - Methods
    
    func bindData(model: UpcomingCard) {
        self.companyImageView.setImage(with: model.companyImage, placeholder: "placeholder_image")
        self.dDayLabel.text = model.dDay
        self.cardLabel.text = model.title
        self.colorMark.backgroundColor = UIColor(hex: model.color)
        self.companyName.text = model.companyInfo
        self.internshipAnnouncementId = model.internshipAnnouncementId
        self.companyImage = model.companyImage
        self.dDay = model.dDay
        self.workingPeriod = model.workingPeriod
        self.isScrapped = model.isScrapped
        self.deadline = model.deadline
        self.startYearMonth = model.startYearMonth
    }
    
    // MARK: - objc fund
    
    @objc func upcomingCardDidTap() {
        guard let internshipAnnouncementId = self.indexPath else { return }
        
        upcomingCardDelegate?.upcomingCardDidTap(index: internshipAnnouncementId)
    }
}
