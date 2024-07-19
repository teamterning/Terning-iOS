//
//  FilteringSettingViewController.swift
//  Terning-iOS
//
//  Created by 김민성 on 7/11/24.
//

import UIKit

import SnapKit
import Then

class FilteringSettingViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: - Properties
    
    var data: UserFilteringInfoModel
    
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
    
    lazy var grade: Int = data.grade
    lazy var workingPeriod: Int = data.workingPeriod
    lazy var startYear: Int = data.startYear
    lazy var startMonth: Int = data.startMonth
    
    private let filtersProvider = Providers.filtersProvider
    
    // MARK: - UIComponents
    
    var rootView = FilteringSettingView()
    
    // MARK: - LifeCycles
    
    init(data: UserFilteringInfoModel) {
        self.data = data
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBind()
        setAddTarget()
        bindData(model: data)
        
        rootView.monthPickerView.delegate = self
        rootView.monthPickerView.dataSource = self
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
//        rootView.saveButton.addTarget(self, action: #selector(saveButtonDidTap), for: .touchUpInside)
        
        // 날짜 선택 피커
    }
    
    func setNavigationBind() {
        rootView.navi.leftButtonAction = { [weak self] in
            self?.popOrDismissViewController()
        }
    }
    
    // MARK: - Methods
    
    func bindData(model: UserFilteringInfoModel) {
        print(model)
        updateButtonSelection(for: gradeButtons_dict, selectedValue: grade)
            updateButtonSelection(for: periodButtons_dict, selectedValue: workingPeriod)
        }
    
    func updateButtonSelection(for buttonsDict: [UIButton: Int], selectedValue: Int) {
        for (button, value) in buttonsDict {
            let isSelected = (value == selectedValue)
            button.isSelected = isSelected
            button.setBackgroundColor(isSelected ? .terningMain : .clear, for: .normal)
            button.setTitleColor(isSelected ? .white : .grey400, for: .normal)
        }
        
    }
    
    // MARK: - UIPickerViewDataSource

        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 2
        }

        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            switch component {
            case 0: return 3 // Year component (2023 to 2025)
            case 1: return 12 // Month component (1 to 12)
            default: return 0
            }
        }

        // MARK: - UIPickerViewDelegate

        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            switch component {
            case 0:
                return String(2023 + row)
            case 1:
                return String(row + 1)
            default:
                return nil
            }
        }

        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            switch component {
            case 0:
                startYear = 2023 + row
            case 1:
                startMonth = row + 1
            default:
                break
            }
        }
    
//    func putUserFilterSettingInfo() {
//        mainHomeVC.filtersProvider.request(.setFilterDatas(grade: grade, workingPeriod: grade, startYear: startYear, startMonth: startMonth)){ [weak self] result in
//            guard let self = self else { return }
//            switch result {
//            case .success(let response):
//                let status = response.statusCode
//                let message = response.description
//                if 200..<300 ~= status {
//                    print(message)
//                    print("👍👍👍👍👍👍👍👍👍👍👍")
////                    mainHomeVC.getHomeJobCardInfo()
//                    
//                } else {
//                    print("400 error")
//                }
//                
//            case .failure(let error):
//                print(error.localizedDescription)
//                print("👎👎👎👎👎👎👎👎👎👎👎")
//                
//            }
//        }
//    }
    
    // MARK: - @objc Function
    
    @objc
        func gradeButtonDidTap(_ sender: UIButton) {
            updateButtonSelection(for: gradeButtons_dict, selectedValue: gradeButtons_dict[sender]!)
            grade = gradeButtons_dict[sender]!
            print("\(grade)로 업데이트 되었습니다.")
        }
    
    @objc
        func periodButtonDidTap(_ sender: UIButton) {
            updateButtonSelection(for: periodButtons_dict, selectedValue: periodButtons_dict[sender]!)
            workingPeriod = periodButtons_dict[sender]!
            print("\(workingPeriod)로 업데이트 되었습니다.")
        }
    
//    @objc
//    func saveButtonDidTap() {
//        print(startYear, startMonth)
//        putUserFilterSettingInfo()
//        HomeView.collectionView.reloadData()
//        self.popOrDismissViewController(animated: true)
//    }
}
