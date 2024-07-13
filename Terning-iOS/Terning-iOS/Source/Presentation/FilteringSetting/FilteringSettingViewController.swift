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
    
    var grade: Int = 0
    var workingPeriod: Int = 0
    var startYear: Int = 2024
    var startMonth: Int = 8
    
    // MARK: - UIComponents
    
    lazy var navi = CustomNavigationBar(self, type: .centerTitleWithLeftButton).setTitle("필터링 재설정")
    
    var rootView = FilteringSettingView()
    
    // MARK: - LifeCycles
    
    override func loadView() {
        view = rootView
        view.addSubview(navi)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAddTarget()
        
        navi.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(68)
        }
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
    
    // MARK: - @objc Function
    
    @objc
    func gradeButtonDidTap(_ sender: UIButton) -> UIButton {
        var gradeButtons_dict: [UIButton: Int] {
            return [
                rootView.gradeButton1: 0,
                rootView.gradeButton2: 1,
                rootView.gradeButton3: 2,
                rootView.gradeButton4: 3
            ]
        }
        
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
        var periodButtons_dict: [UIButton: Int] {
            return [
                rootView.periodButton1: 0,
                rootView.periodButton2: 1,
                rootView.periodButton3: 2
            ]
        }
        
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
    }
}
