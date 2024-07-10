//
//  CustomDatePicker.swift
//  Terning-iOS
//
//  Created by 정민지 on 7/10/24.
//

import UIKit

public final class CustomDatePicker: UIPickerView {
    
    // MARK: - Properties
    
    private let years = Array(2023...2025)
    private let months = Array(1...12)
    
    var onDateSelected: ((Int, Int) -> Void)?
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setDelegate()
        setSelectedRow()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UIPickerViewDataSource

extension CustomDatePicker: UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return years.count
        } else {
            return months.count
        }
    }
}

// MARK: - UIPickerViewDelegate

extension CustomDatePicker: UIPickerViewDelegate {
    public func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 100
    }
    
    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let containerView: UIView
        let label: UILabel
        
        if let view = view, let reusedLabel = view.subviews.first as? UILabel {
            containerView = view
            label = reusedLabel
        } else {
            containerView = UIView()
            label = UILabel()
            label.textAlignment = .center
            containerView.addSubview(label)
            
            label.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                if component == 0 {
                    $0.trailing.equalToSuperview().inset(15)
                } else {
                    $0.leading.equalToSuperview().inset(26)
                }
            }
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .right
        paragraphStyle.tailIndent = 45
        
        let text = (component == 0) ? "\(years[row])년" : "\(months[row])월"
        
        let attributedString = NSAttributedString(string: text, attributes: [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.font: UIFont.title3,
            NSAttributedString.Key.foregroundColor: UIColor.grey500
        ])
        
        label.attributedText = attributedString
        
        return containerView
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedYear = years[pickerView.selectedRow(inComponent: 0)]
        let selectedMonth = months[pickerView.selectedRow(inComponent: 1)]
        onDateSelected?(selectedYear, selectedMonth)
    }
}

// MARK: - Methods

extension CustomDatePicker {
    private func setDelegate() {
        self.dataSource = self
        self.delegate = self
    }
    
    /// 한국 날짜로 현재 년도와 달을 초기 화면에 뜨는 년도와 달로 설정
    private func setSelectedRow() {
        let (currentYear, currentMonth) = Date().getCurrentKrYearAndMonth()
        
        if let initialYearIndex = years.firstIndex(of: currentYear),
           let initialMonthIndex = months.firstIndex(of: currentMonth) {
            self.selectRow(initialYearIndex, inComponent: 0, animated: false)
            self.selectRow(initialMonthIndex, inComponent: 1, animated: false)
        }
    }
}
