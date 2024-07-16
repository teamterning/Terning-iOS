//
//  CustomSearchView.swift
//  Terning-iOS
//
//  Created by 정민지 on 7/15/24.
//

import UIKit

import SnapKit
import Then

final class CustomSearchView: UIView, UITextFieldDelegate {
    
    // MARK: - UI Components
    
    private let iconImageView = UIImageView().then {
        $0.image = .icSearchFill
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
    }
    
    let textField = UITextField().then {
        $0.borderStyle = .none
        $0.textColor = .grey400
        $0.font = .body2
        $0.attributedPlaceholder = NSAttributedString(
            string: "관심있는 인턴 공고 키워드를 검색해 보세요",
            attributes: [
                .foregroundColor: UIColor.grey400,
                .font: UIFont.detail2
            ]
        )
    }
    
    private let underLineView = UIView().then {
        $0.backgroundColor = .terningMain
    }
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
        
        self.setUI()
        self.setLayout()
        textField.delegate = self

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI & Layout
    
    private func setUI() {
        addSubviews(
            iconImageView,
            textField,
            underLineView
        )
    }
    
    private func setLayout() {
        iconImageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.height.width.equalTo(18)
        }
        
        textField.snp.makeConstraints {
            $0.leading.equalTo(iconImageView.snp.trailing).offset(5)
            $0.trailing.equalToSuperview()
            $0.centerY.equalTo(iconImageView)
        }
        
        underLineView.snp.makeConstraints {
            $0.top.equalTo(iconImageView.snp.bottom).offset(7)
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.height.equalTo(2)
        }
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        updatePlaceholderFont(isEditing: true)
    }
    
    private func updatePlaceholderFont(isEditing: Bool) {
        let placeholderText = "관심있는 인턴 공고 키워드를 검색해 보세요"
        let placeholderFont = isEditing ? .detail3: UIFont.detail2
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.grey300,
            .font: placeholderFont
        ]
        textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
    }
}
