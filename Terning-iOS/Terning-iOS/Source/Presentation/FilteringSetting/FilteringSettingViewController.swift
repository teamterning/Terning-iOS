//
//  FilteringSettingViewController.swift
//  Terning-iOS
//
//  Created by 김민성 on 7/11/24.
//

import UIKit

import SnapKit
import Then

protocol SaveButtonProtocol: AnyObject {
    func didSaveSetting()
}

class FilteringSettingViewController: UIViewController, UIAdaptivePresentationControllerDelegate {
    
    // MARK: - Properties
    
    weak var saveButtonDelegate: SaveButtonProtocol?
    
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
        setPickerView()
        bindData(model: data)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        setUserFilterInfo()
    }
}

// MARK: - UI & Layout

extension FilteringSettingViewController {
    
    func setPickerView() {
        rootView.monthPickerView.onDateSelected = { [weak self] (year, month) in
            self?.startYear = year
            self?.startMonth = month
            print("Selected Year: \(year), Month: \(month)")
        }
    }
    
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
        updateButtonSelection(for: gradeButtons_dict, selectedValue: grade ?? 0)
        updateButtonSelection(for: periodButtons_dict, selectedValue: workingPeriod ?? 0)
        // 초기에 데이터 픽커뷰 표시해놓는것
    }
    
    func updateButtonSelection(for buttonsDict: [UIButton: Int], selectedValue: Int) {
        for (button, value) in buttonsDict {
            let isSelected = (value == selectedValue)
            button.isSelected = isSelected
            button.setBackgroundColor(isSelected ? .terningMain : .clear, for: .normal)
            button.setTitleColor(isSelected ? .white : .grey400, for: .normal)
        }
    }
    
    // MARK: - Network
    
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
                        
                        print("필터링 설정 성공")
                        
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
