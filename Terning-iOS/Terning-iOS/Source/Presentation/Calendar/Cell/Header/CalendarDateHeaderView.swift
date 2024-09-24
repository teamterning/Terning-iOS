//
//  CalendarDateHeaderView.swift
//  Terning-iOS
//
//  Created by 이명진 on 7/13/24.
//

import UIKit

import SnapKit
import Then

final class CalendarDateHeaderView: UICollectionReusableView {
    
    // MARK: - UIComponents
    
    private let titleLabel = LabelFactory.build(
        text: "7월 26일 금요일",
        font: .body2,
        textColor: .black,
        lineSpacing: 1.2,
        characterSpacing: 0.02
    )
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierarchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension CalendarDateHeaderView {
    private func setUI() {
        backgroundColor = .clear
    }
    
    private func setHierarchy() {
        addSubview(titleLabel)
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(-5)
            $0.leading.equalToSuperview()
        }
    }
}

// MARK: - bind

extension CalendarDateHeaderView {
    func bind(title: String) {
        self.titleLabel.text = convertToDayOfWeek(from: title)
    }
}

// MARK: - Methods

extension CalendarDateHeaderView {
    private func convertToDayOfWeek(from dateString: String) -> String? {
        // DateFormatter를 이용해 입력된 문자열을 Date 객체로 변환
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy-M-d"
        
        // 문자열을 Date 객체로 변환
        guard let date = dateFormatter.date(from: dateString) else {
            return nil
        }
        
        // 요일을 얻기 위한 DateFormatter 설정
        let dayFormatter = DateFormatter()
        dayFormatter.locale = Locale(identifier: "ko_KR")
        dayFormatter.dateFormat = "M월 d일 EEEE"
        
        return dayFormatter.string(from: date)
    }
}
