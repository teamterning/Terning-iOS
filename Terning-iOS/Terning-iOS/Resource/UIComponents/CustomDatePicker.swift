//
//  CustomDatePicker.swift
//  Terning-iOS
//
//  Created by 정민지 on 7/10/24.
//

import UIKit

public final class CustomDatePicker: UIPickerView {
    
    // MARK: - Properties
    
    private(set) var years = Array(2022...2030).map { "\($0)" }
    private(set) var months = Array(1...12).map { "\($0)" }
    private var shouldRemovePlaceholderOnSelection = false
    
    var onDateSelected: ((Int?, Int?) -> Void)?
    
    private var hasPlaceholder: Bool {
        years.last == "-" || months.last == "-"
    }
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
        return component == 0 ? years.count : months.count
    }
}

// MARK: - UIPickerViewDelegate

extension CustomDatePicker: UIPickerViewDelegate {
    public func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 100
    }
    
    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 34.18.adjustedH
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
                    $0.trailing.equalToSuperview().inset(years[row] == "-" ? 40 : 15)
                } else {
                    $0.leading.equalToSuperview().inset(months[row] == "-" ? 32 : 26)
                }
            }
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .right
        paragraphStyle.tailIndent = 60
        
        let text = (component == 0) ? "\(years[row])\(years[row] == "-" ? " " : "년")"
        : "\(months[row])\(months[row] == "-" ? " " : "월")"
        
        let attributedString = NSAttributedString(string: text, attributes: [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.font: UIFont.title3,
            NSAttributedString.Key.foregroundColor: UIColor.grey500
        ])
        
        label.attributedText = attributedString
        
        return containerView
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if shouldRemovePlaceholderOnSelection {
            if component == 0, years.last == "-", row < years.count - 1 {
                years.removeLast()
                reloadComponent(0)
            }
            
            if component == 1, months.last == "-", row < months.count - 1 {
                months.removeLast()
                reloadComponent(1)
            }
        }
        
        let selectedYear = years[selectedRow(inComponent: 0)] != "-"
        ? Int(years[selectedRow(inComponent: 0)])
        : nil
        let selectedMonth = selectedRow(inComponent: 1) < months.count && months[selectedRow(inComponent: 1)] != "-"
        ? Int(months[selectedRow(inComponent: 1)])
        : nil
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
        
        if let initialYearIndex = years.firstIndex(of: "\(currentYear)"),
           let initialMonthIndex = months.firstIndex(of: "\(currentMonth)") {
            self.selectRow(initialYearIndex, inComponent: 0, animated: false)
            self.selectRow(initialMonthIndex, inComponent: 1, animated: false)
            onDateSelected?(currentYear, currentMonth)
        }
    }
}

// MARK: - Public Methods

extension CustomDatePicker {
    public func setInitialDate(year: Int, month: Int) {
        if let initialYearIndex = years.firstIndex(of: "\(year)"),
           let initialMonthIndex = months.firstIndex(of: "\(month)") {
            self.selectRow(initialYearIndex, inComponent: 0, animated: false)
            self.selectRow(initialMonthIndex, inComponent: 1, animated: false)
            onDateSelected?(year, month)
        }
    }
    
    public func addPlaceholder() {
        if years.last != "-" {
            years.append("-")
        }
        if months.last != "-" {
            months.append("-")
        }
        reloadAllComponents()
        
        let yearLastIndex = years.count - 1
        let monthLastIndex = months.count - 1
        selectRow(yearLastIndex, inComponent: 0, animated: true)
        selectRow(monthLastIndex, inComponent: 1, animated: true)
        
        onDateSelected?(nil, nil)
    }
    
    public func removePlaceholder() {
        if hasPlaceholder {
            shouldRemovePlaceholderOnSelection = true
        }
    }
}
