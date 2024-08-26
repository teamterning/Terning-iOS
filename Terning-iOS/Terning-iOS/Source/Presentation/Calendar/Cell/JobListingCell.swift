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
        $0.backgroundColor = .grey200
        $0.layer.cornerRadius = 5
        $0.clipsToBounds = true
    }
    
    private let deadlineLabel = LabelFactory.build(
        font: .detail0,
        textColor: .terningMain,
        lineSpacing: 1.0,
        characterSpacing: 0.002
    )
    
    private let mainTitleLabel = LabelFactory.build(
        text: "[Someone] 콘텐츠 마케터 대학생 인턴 채용",
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
        text: "2개월",
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
        $0.backgroundColor = .calOrange
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
        contentView.layer.applyShadow(y: 0, blur: 4)
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
            deadlineLabel,
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
            $0.top.bottom.trailing.equalToSuperview().inset(12)
            $0.leading.equalTo(colorMark.snp.trailing).offset(12)
        }
        
        mainImageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.width.height.equalTo(76)
        }
        
        deadlineLabel.snp.makeConstraints {
            $0.top.equalTo(containerView.snp.top)
            $0.leading.equalTo(mainImageView.snp.trailing).offset(8)
        }
        
        mainTitleLabel.snp.makeConstraints {
            $0.top.equalTo(containerView.snp.top).offset(16)
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
            $0.trailing.equalTo(contentView.snp.trailing).inset(17)
            $0.height.width.equalTo(24)
            $0.bottom.equalToSuperview().inset(12)
        }
    }
}

extension JobListingCell {
    
    // MARK: - Methods
    
    func bind(model: DailyScrapModel, indexPath: IndexPath? = nil, in collectionView: UICollectionView? = nil) {
        guard let day = model.dDay else { return print("JobListingCell Error dDay") }
        guard let workingPeriod = model.workingPeriod else { return print("JobListingCell Error workingPeriod") }
        guard let companyImage = model.companyImage else { return print("JobListingCell Error companyImage") }
        
        self.indexPath = indexPath
        self.collectionView = collectionView
        
        self.mainImageView.setImage(with: companyImage)
        self.deadlineLabel.text = day
        self.monthLabel.text = workingPeriod
        self.mainTitleLabel.text = model.title
        self.colorMark.backgroundColor = UIColor(hex: model.color)
        self.scrapButton.isSelected = true
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

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        assert(hexFormatted.count == 6, "Invalid hex code used.")
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0, alpha: alpha)
    }
}
