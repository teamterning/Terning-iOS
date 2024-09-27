//
//  JobListingCell.swift
//  Terning-iOS
//
//  Created by 이명진 on 7/13/24.
//

import UIKit
import SnapKit
import Then

protocol JobListCellProtocol: AnyObject {
    func scrapButtonDidTapInCalendar(in collectionView: UICollectionView, isScrap: Bool, indexPath: IndexPath)
}

final class JobListingCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    weak var delegate: JobListCellProtocol?
    private var indexPath: IndexPath?
    private weak var collectionView: UICollectionView?
    
    // MARK: - UIComponents
    
    private let containerView = UIView().then {
        $0.backgroundColor = .white
    }
    
    private let mainImageView = UIImageView().then {
        $0.layer.cornerRadius = 5
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFit
    }
    
    private let dDayLabel = LabelFactory.build(
        font: .detail0,
        textColor: .terningMain,
        lineSpacing: 1.0,
        characterSpacing: 0.002
    )
    
    private let mainTitleLabel = LabelFactory.build(
        font: .title5,
        textColor: .black,
        textAlignment: .left,
        lineSpacing: 1.2,
        characterSpacing: 0.002
    ).then {
        $0.numberOfLines = 2
    }
    
    private let workingPeriodLabel = LabelFactory.build(
        text: "근무기간",
        font: .detail3,
        textColor: .grey400,
        textAlignment: .left,
        lineSpacing: 1.2,
        characterSpacing: 0.002
    )
    
    private let monthLabel = LabelFactory.build(
        font: .detail3,
        textColor: .terningMain,
        textAlignment: .left,
        lineSpacing: 1.2,
        characterSpacing: 0.002
    )
    
    private let scrapButton = UIButton(type: .custom).then {
        $0.setImage(.icScrap, for: .normal)
        $0.setImage(.icScrapFill, for: .selected)
    }
    
    private let colorMark = UIView().then {
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
    }
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierarchy()
        setLayout()
        setAddTarget()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension JobListingCell {
    
    // MARK: - UI & Layout
    
    private func setUI() {
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = .white
        contentView.clipsToBounds = true
    }
    
    private func setHierarchy() {
        contentView.addSubviews(
            colorMark,
            containerView
        )
        
        containerView.addSubviews(
            mainImageView,
            dDayLabel,
            mainTitleLabel,
            workingPeriodLabel,
            monthLabel,
            scrapButton
        )
    }
    
    private func setLayout() {
        colorMark.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.width.equalTo(8)
        }
        
        containerView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.trailing.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().inset(8)
            $0.leading.equalTo(colorMark.snp.trailing).offset(12)
        }
        
        mainImageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.width.height.equalTo(76)
        }
        
        dDayLabel.snp.makeConstraints {
            $0.top.equalTo(containerView.snp.top)
            $0.leading.equalTo(mainImageView.snp.trailing).offset(8)
        }
        
        mainTitleLabel.snp.makeConstraints {
            $0.top.equalTo(containerView.snp.top).offset(18)
            $0.leading.equalTo(mainImageView.snp.trailing).offset(8)
            $0.trailing.equalToSuperview()
        }
        
        workingPeriodLabel.snp.makeConstraints {
            $0.top.equalTo(containerView.snp.top).offset(59)
            $0.leading.equalTo(mainImageView.snp.trailing).offset(8)
        }
        
        monthLabel.snp.makeConstraints {
            $0.top.equalTo(containerView.snp.top).offset(59)
            $0.leading.equalTo(workingPeriodLabel.snp.trailing).offset(8)
        }
        
        scrapButton.snp.makeConstraints {
            $0.trailing.equalTo(containerView.snp.trailing)
            $0.height.width.equalTo(24)
            $0.bottom.equalToSuperview()
        }
    }
}

extension JobListingCell {
    
    // MARK: - Methods
    
    func bind(model: AnnouncementModel, indexPath: IndexPath? = nil, in collectionView: UICollectionView? = nil) {
        
        if model.dDay == "지원마감" {
            self.dDayLabel.textColor = .grey300
        } else {
            self.dDayLabel.textColor = .terningMain
        }
        
        self.indexPath = indexPath
        self.collectionView = collectionView
        
        self.mainImageView.setImage(with: model.companyImage)
        self.dDayLabel.text = model.dDay
        self.monthLabel.text = model.workingPeriod
        self.mainTitleLabel.text = model.title
        self.colorMark.backgroundColor = UIColor(hex: model.color ?? "#ED4E54")
        self.scrapButton.isSelected = model.isScrapped
    }
    
    private func setAddTarget() {
        scrapButton.addTarget(self, action: #selector(scrapButtonDidTap), for: .touchUpInside)
    }
}

extension JobListingCell {
    
    // MARK: - @objc Function
    
    @objc
    func scrapButtonDidTap(_ sender: UIButton) {
        guard let indexPath = self.indexPath else { return }
        guard let collectionView = self.collectionView else { return print("쫑") }
        
        delegate?.scrapButtonDidTapInCalendar(in: collectionView, isScrap: sender.isSelected, indexPath: indexPath)
    }
}
