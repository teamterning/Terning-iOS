//
//  FilteringSettingViewController.swift
//  Terning-iOS
//
//  Created by 김민성 on 7/11/24.
//

import UIKit

import SnapKit
import Then

protocol SaveButtonDelegate: AnyObject {
    func didSaveSetting()
}

class FilteringSettingViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIAdaptivePresentationControllerDelegate {
    
    // MARK: - Properties
    
    weak var saveButtonDelegate: SaveButtonDelegate?
    
    private let filterProvider = Providers.filtersProvider
    
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
    
    lazy var grade: Int? = data.grade
    lazy var workingPeriod: Int? = data.workingPeriod
    lazy var startYear: Int? = data.startYear
    lazy var startMonth: Int? = data.startMonth
    
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
        
        setAddTarget()
        bindData(model: data)
        
        rootView.monthPickerView.delegate = self
        rootView.monthPickerView.dataSource = self
    }
}

// MARK: - UI & Layout

extension FilteringSettingViewController {
    
    func setAddTarget() {
        // 재학 상태 설정 버튼
        gradeButtons_dict.keys.forEach {
            $0.addTarget(self, action: #selector(gradeButtonDidTap), for: .touchUpInside)
        }
        
        // 희망하는 인턴 근무 기간 설정 버튼
        periodButtons_dict.keys.forEach {
            $0.addTarget(self, action: #selector(periodButtonDidTap), for: .touchUpInside)
        }
        
        rootView.saveButton.addTarget(self, action: #selector(saveButtonDidTap), for: .touchUpInside)
        
    }
    
    // MARK: - Methods
    
    func bindData(model: UserFilteringInfoModel) {
        print(model)
        updateButtonSelection(for: gradeButtons_dict, selectedValue: grade ?? 0)
        updateButtonSelection(for: periodButtons_dict, selectedValue: workingPeriod ?? 0)
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
            return String(row+1)
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            startYear = 2023 + row
            print(startYear ?? 0)
        case 1:
            startMonth = row + 1
            print(startMonth ?? 0)
        default:
            break
        }
    }
    
    func setUserFilterInfo() {
        filterProvider.request(
            .setFilterDatas(
                grade: grade,
                workingPeriod: workingPeriod,
                startYear: startYear ?? 0,
                startMonth: startMonth ?? 0
            )
        ) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let result):
                let status = result.statusCode
                if 200..<300 ~= status {
                    do {
                        _ = try result.map(BaseResponse<BlankData>.self)
                        
                        print("필터링 섧정 성공")
                    } catch {
                        print(error.localizedDescription)
                    }
                }
                if status >= 400 {
                    print("400 error")
                    self.showNetworkFailureToast()
                }
            case .failure(let error):
                print(error.localizedDescription)
                self.showNetworkFailureToast()
            }
        }
    }
    
    // MARK: - @objc Function
    
    @objc
    func gradeButtonDidTap(_ sender: UIButton) {
        updateButtonSelection(for: gradeButtons_dict, selectedValue: gradeButtons_dict[sender]!)
        grade = gradeButtons_dict[sender]!
    }
    
    @objc
    func periodButtonDidTap(_ sender: UIButton) {
        updateButtonSelection(for: periodButtons_dict, selectedValue: periodButtons_dict[sender]!)
        workingPeriod = periodButtons_dict[sender]!
    }
    
    @objc
    func saveButtonDidTap() {
        self.setUserFilterInfo()
    
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.showToast(message: "스크랩 설정이 완료 되었어요 !")
            self.saveButtonDelegate?.didSaveSetting()
            self.popOrDismissViewController()
        }
    }
}
