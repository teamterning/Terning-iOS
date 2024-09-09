//
//  MainInfoTableViewCell.swift
//  Terning-iOS
//
//  Created by 정민지 on 7/12/24.
//

import UIKit

import SnapKit
import Then

final class MainInfoTableViewCell: UITableViewCell {
    
    // MARK: - UI Components
    
    private let dDayDivView = UIView().then {
        $0.backgroundColor = .terningSelectPressed
        $0.layer.cornerRadius = 5.adjusted
    }
    
    private let dDayLabel = LabelFactory.build(
        text: "D-3",
        font: .body0,
        textColor: .terningMain,
        lineSpacing: 1.0,
        characterSpacing: 0.002
    )
    
    private let titleLabel = LabelFactory.build(
        text: "[SomeOne] 콘텐츠 마케터 대학생 인턴 채용",
        font: .title2,
        textAlignment: .left
    ).then {
        $0.numberOfLines = 2
    }

    private let viewsImage = UIImageView().then {
        $0.image = .profile0
        $0.contentMode = .scaleAspectFit
        
    }
    
    private let viewsLabel = LabelFactory.build(
        text: "3,219회",
        font: .button4,
        textColor: .grey400
    )
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension MainInfoTableViewCell {
    private func setUI() {
        self.addSubviews(
            dDayDivView,
            titleLabel,
            viewsImage,
            viewsLabel
        )
        
        dDayDivView.addSubview(dDayLabel)
        
    }
    
    private func setLayout() {
        dDayDivView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20.adjustedH)
            $0.leading.equalToSuperview().inset(24.adjusted)
        }
        
        dDayLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(2.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(20.5.adjusted)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(dDayDivView.snp.bottom).offset(8.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(24.adjusted)
        }
        
        viewsImage.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(5.adjustedH)
            $0.leading.equalToSuperview().inset(24.adjusted)
            $0.width.height.equalTo(14.adjusted)
            $0.bottom.equalToSuperview().inset(17.adjustedH)
        }
        
        viewsLabel.snp.makeConstraints {
            $0.centerY.equalTo(viewsImage.snp.centerY)
            $0.leading.equalTo(viewsImage.snp.trailing).offset(3.adjusted)
        }
    }
}

// MARK: - Methods

extension MainInfoTableViewCell {
    func bind(with mainInfo: MainInfoModel) {
        if let dDayInt = Int(mainInfo.dDay) {
            dDayLabel.text = "D-\(dDayInt)"
        } else {
            dDayLabel.text = mainInfo.dDay
        }
        
        titleLabel.text = mainInfo.title
        viewsLabel.text = "\(mainInfo.viewCount)회"
    }
}
