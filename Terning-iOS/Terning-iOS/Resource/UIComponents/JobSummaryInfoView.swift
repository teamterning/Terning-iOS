//
//  JobSummaryInfoView.swift
//  Terning-iOS
//
//  Created by 정민지 on 7/12/24.
//

import UIKit

import SnapKit
import Then

final class JobSummaryInfoView: UIView {
    
    // MARK: - Properties
    
    private var descriptionLabels: [UILabel] = []
    
    // MARK: - UI Components
    
    private let imageView = UIImageView().then {
        $0.image = .icLightbulb
        $0.contentMode = .scaleAspectFit
    }
    
    private let titleLabel = LabelFactory.build(
        text: "자격요건",
        font: .button2,
        textColor: .grey500,
        textAlignment: .left,
        lineSpacing: 1.2,
        characterSpacing: 0.002
    )
    
    // MARK: - Init
    
    init(image: UIImage, title: String, descriptions: [String]) {
        
        super.init(frame: .zero)
        
        self.setUI(
            image: image,
            title: title,
            descriptions: descriptions
        )
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension JobSummaryInfoView {
    private func setUI(image: UIImage, title: String, descriptions: [String]) {
        self.backgroundColor = .clear
        self.imageView.image = image
        self.titleLabel.text = title
        self.descriptionLabels = descriptions.map {
            let label = LabelFactory.build(
                text: $0,
                font: .body5,
                textColor: .grey400,
                textAlignment: .left,
                lineSpacing: 1.2,
                characterSpacing: 0.002
            )
            return label
        }
    }
    
    private func setLayout() {
        self.addSubviews(imageView, titleLabel)
        
        imageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.width.height.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(imageView.snp.trailing).offset(3)
            $0.width.equalTo(60)
        }
        
        var previousLabel: UILabel? = nil
        for (index, label) in descriptionLabels.enumerated() {
            self.addSubview(label)
            label.snp.makeConstraints {
                if let previous = previousLabel {
                    $0.top.equalTo(previous.snp.bottom).offset(5)
                } else {
                    $0.top.equalToSuperview()
                }
                $0.leading.equalTo(titleLabel.snp.trailing).offset(17)
                $0.trailing.equalToSuperview()
                if index == descriptionLabels.count - 1 {
                    $0.bottom.equalToSuperview()
                }
            }
            previousLabel = label
        }
    }
}

// MARK: - Methods

extension JobSummaryInfoView {
    @discardableResult
    func setDescriptionText(descriptions: [String]) -> Self {
        descriptionLabels.forEach { $0.removeFromSuperview() }

        self.descriptionLabels = descriptions.map {
            let label = LabelFactory.build(
                text: $0,
                font: .body4,
                textColor: .grey400,
                textAlignment: .left,
                lineSpacing: 1.5,
                characterSpacing: 0.002
            )
            label.numberOfLines = 0
            return label
        }
        setLayout()
        
        return self
    }
}
