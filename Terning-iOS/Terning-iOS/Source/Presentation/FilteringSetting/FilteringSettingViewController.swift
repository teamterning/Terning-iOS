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
    
    var gradeButtons_dict: [UIButton: Int] {
        return [
            rootView.gradeButton1: 0,
            rootView.gradeButton2: 1,
            rootView.gradeButton3: 2,
            rootView.gradeButton4: 3
        ]
    }
    
    var periodButtons_dict: [UIButton: Int] {
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
        rootView.gradeButton1.addTarget(self, action: #selector(gradeButtonDidTap), for: .touchUpInside)
        rootView.gradeButton2.addTarget(self, action: #selector(gradeButtonDidTap), for: .touchUpInside)
        rootView.gradeButton3.addTarget(self, action: #selector(gradeButtonDidTap), for: .touchUpInside)
        rootView.gradeButton4.addTarget(self, action: #selector(gradeButtonDidTap), for: .touchUpInside)
        
        rootView.periodButton1.addTarget(self, action: #selector(periodButtonDidTap), for: .touchUpInside)
        rootView.periodButton2.addTarget(self, action: #selector(periodButtonDidTap), for: .touchUpInside)
        rootView.periodButton3.addTarget(self, action: #selector(periodButtonDidTap), for: .touchUpInside)
        
        rootView.saveButton.addTarget(self, action: #selector(saveButtonDidTap), for: .touchUpInside)
    }
    
    func setNavigationBind() {
        rootView.navi.leftButtonAction = { [weak self] in
            self?.popOrDismissViewController()
        }
    }
    
    // MARK: - Methods
    
    func bindData(model: UserFilteringInfoModel) {
        if model.grade == 0 {
            rootView.gradeButton1.isSelected = true
            rootView.gradeButton1.setBackgroundColor(.terningMain, for: .selected)
            rootView.gradeButton1.setTitleColor(.white, for: .selected)
        } else if model.grade == 1 {
            rootView.gradeButton2.isSelected = true
            rootView.gradeButton2.setBackgroundColor(.terningMain, for: .selected)
            rootView.gradeButton2.setTitleColor(.white, for: .selected)
        } else if model.grade == 2 {
            rootView.gradeButton3.isSelected = true
            rootView.gradeButton3.setBackgroundColor(.terningMain, for: .selected)
            rootView.gradeButton3.setTitleColor(.white, for: .selected)
        } else if model.grade == 3 {
            rootView.gradeButton4.isSelected = true
            rootView.gradeButton4.setBackgroundColor(.terningMain, for: .selected)
            rootView.gradeButton4.setTitleColor(.white, for: .selected)
        }
        
        if model.workingPeriod == 0 {
            rootView.periodButton1.isSelected = true
            rootView.periodButton1.setBackgroundColor(.terningMain, for: .selected)
            rootView.periodButton1.setTitleColor(.white, for: .selected)
        } else if model.workingPeriod == 1 {
            rootView.periodButton2.isSelected = true
            rootView.periodButton2.setBackgroundColor(.terningMain, for: .selected)
            rootView.periodButton2.setTitleColor(.white, for: .selected)
        } else if model.workingPeriod == 2 {
            rootView.periodButton3.isSelected = true
            rootView.periodButton3.setBackgroundColor(.terningMain, for: .selected)
            rootView.periodButton3.setTitleColor(.white, for: .selected)
        }
        
        // CustomDatePicker 데이터 바인딩은 민지 누나의 CustomDatePicker 수정이 끝나면 바로 추가하겠습니다.
    }
    
    // MARK: - @objc Function
    
    @objc
    func gradeButtonDidTap(_ sender: UIButton) -> UIButton {
        for gradeButton in gradeButtons_dict {
            if gradeButton.key == sender {
                gradeButton.key.backgroundColor = .terningMain
                gradeButton.key.setTitleColor(.white, for: .normal)
                gradeButton.key.isSelected.toggle()
                grade = gradeButton.value
                print("\(grade + 1)학년 선택되었습니다.")
                
            } else if !gradeButton.key.isSelected {
                continue
                
            } else if gradeButton.key.isSelected {
                gradeButton.key.backgroundColor = .clear
                gradeButton.key.setTitleColor(.grey400, for: .normal)
                gradeButton.key.isSelected = false
                print("\(gradeButton.value)취소되었습니다.")
            }
        }
        return UIButton()
    }
    
    @objc
    func periodButtonDidTap(_ sender: UIButton) {
        for periodButton in periodButtons_dict {
            if periodButton.key  == sender {
                periodButton.key.backgroundColor = .terningMain
                periodButton.key.setTitleColor(.white, for: .normal)
                periodButton.key.isSelected.toggle()
                workingPeriod = periodButton.value
                if workingPeriod == 0 {
                    print("1개월 ~ 3개월 선택되었습니다.")
                } else if workingPeriod == 1 {
                    print("4개월 ~ 6개월 이상 선택되었습니다.")
                } else if workingPeriod == 2 {
                    print("7개월 이상 선택되었습니다.")
                }
                
            } else if !periodButton.key.isSelected {
                continue

            } else if periodButton.key.isSelected {
                periodButton.key.backgroundColor = .clear
                periodButton.key.setTitleColor(.grey400, for: .normal)
                periodButton.key.isSelected = false
            }
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
