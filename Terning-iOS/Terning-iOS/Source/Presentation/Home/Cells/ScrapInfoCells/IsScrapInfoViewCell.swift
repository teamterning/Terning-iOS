//
//  IsScrapInfoViewCell.swift
//  Terning-iOS
//
//  Created by 김민성 on 7/10/24.
//

import UIKit

import SnapKit
import Then

class IsScrapInfoViewCell: UICollectionViewCell {
    
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
            $0.edges.equalToSuperview()
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
}

extension IsScrapInfoViewCell {
    func bindData(color: CGColor, title: String) {
        self.colorMark.backgroundColor = UIColor(cgColor: color)
        self.cardLabel.text = title
    }
}
