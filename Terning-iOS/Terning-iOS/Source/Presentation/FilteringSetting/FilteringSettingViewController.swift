//
//  FilteringSettingViewController.swift
//  Terning-iOS
//
//  Created by 김민성 on 7/11/24.
//

import UIKit

import SnapKit
import Then

class FilteringSettingViewController: UIViewController {
    
    // MARK: - Properties
    
    private var gradeButtons_dict: [UIButton: Int] {
        return [
            rootView.gradeButton1: 0,
            rootView.gradeButton2: 1,
            rootView.gradeButton3: 2,
            rootView.gradeButton4: 3
        ]
    }
    
    private var periodButtons_dict: [UIButton: Int] {
        return [
            rootView.periodButton1: 0,
            rootView.periodButton2: 1,
            rootView.periodButton3: 2
        ]
    }
    
    private var UserFilteringInfoModelItems: [UserFilteringInfoModel] = UserFilteringInfoModel.getUserFilteringInfo()
    lazy var model = UserFilteringInfoModelItems[0]
    
    lazy var grade: Int = model.grade
    lazy var workingPeriod: Int = model.workingPeriod
    lazy var startYear: Int = model.startYear
    lazy var startMonth: Int = model.startMonth
    
    // MARK: - UIComponents
    
    var rootView = FilteringSettingView()
    
    // MARK: - LifeCycles
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBind()
        setAddTarget()
        bindData(model: model)
    }
}

// MARK: - UI & Layout

extension FilteringSettingViewController {
    
    func setAddTarget() {
        // 제학 상태 설정 버튼
        gradeButtons_dict.keys.forEach {
            $0.addTarget(self, action: #selector(gradeButtonDidTap), for: .touchUpInside)
        }
        
        // 희망하는 인턴 근무 기간 설정 버튼
        periodButtons_dict.keys.forEach {
            $0.addTarget(self, action: #selector(periodButtonDidTap), for: .touchUpInside)
        }
        
        // 입사 계획 달 설정 버튼
        rootView.saveButton.addTarget(self, action: #selector(saveButtonDidTap), for: .touchUpInside)
    }
    
    func setNavigationBind() {
        rootView.navi.leftButtonAction = { [weak self] in
            self?.popOrDismissViewController()
        }
    }
    
    // MARK: - Methods
    
    func bindData(model: UserFilteringInfoModel) {
            updateButtonSelection(for: gradeButtons_dict, selectedValue: model.grade)
            updateButtonSelection(for: periodButtons_dict, selectedValue: model.workingPeriod)
        }
    
    func updateButtonSelection(for buttonsDict: [UIButton: Int], selectedValue: Int) {
        for (button, value) in buttonsDict {
            let isSelected = (value == selectedValue)
            button.isSelected = isSelected
            button.setBackgroundColor(isSelected ? .terningMain : .clear, for: .normal)
            button.setTitleColor(isSelected ? .white : .grey400, for: .normal)
        }
    }
    
    // MARK: - @objc Function
    
    @objc
        func gradeButtonDidTap(_ sender: UIButton) {
            updateButtonSelection(for: gradeButtons_dict, selectedValue: gradeButtons_dict[sender]!)
            grade = gradeButtons_dict[sender]!
            print("\(grade + 1)학년 선택되었습니다.")
        }
    
    @objc
        func periodButtonDidTap(_ sender: UIButton) {
            updateButtonSelection(for: periodButtons_dict, selectedValue: periodButtons_dict[sender]!)
            workingPeriod = periodButtons_dict[sender]!
            switch workingPeriod {
            case 0:
                print("1개월 ~ 3개월 선택되었습니다.")
            case 1:
                print("4개월 ~ 6개월 이상 선택되었습니다.")
            case 2:
                print("7개월 이상 선택되었습니다.")
            default:
                break
            }
        }
    
    @objc
    func saveButtonDidTap() {
        rootView.monthPickerView.onDateSelected = { [weak self] year, month in
            self?.startYear = year
            self?.startMonth = month
        }
        
        print(grade, workingPeriod, startYear, startMonth)
        self.popOrDismissViewController(animated: true)
    }
}
