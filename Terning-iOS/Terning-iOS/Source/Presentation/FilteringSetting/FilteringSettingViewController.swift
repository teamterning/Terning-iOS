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
    
    // MARK: - UIComponents
    
    var rootView = FilteringSettingView()
    
    // MARK: - LifeCycles
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAddTarget()
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
    }
    
    // MARK: - ButtonClickEvent
    
    @objc
    func gradeButtonDidTap(_ sender: UIButton) {
        var gradeButtons: [UIButton] {
            return [
                rootView.gradeButton1,
                rootView.gradeButton2,
                rootView.gradeButton3,
                rootView.gradeButton4
            ]
            }
        
        for gradeButton in gradeButtons {
            if gradeButton == sender {
                gradeButton.backgroundColor = .terningMain
                gradeButton.setTitleColor(.white, for: .normal)
                gradeButton.isSelected.toggle()
                print("선택되었습니다.")
            } else {
                gradeButton.backgroundColor = .clear
                gradeButton.setTitleColor(.grey400, for: .normal)
                gradeButton.isSelected = false
                print("취소되었습니다.")
            }
        }
    }
    
    @objc
    func periodButtonDidTap(_ sender: UIButton) {
        var periodButtons: [UIButton] {
            return [
                rootView.periodButton1,
                rootView.periodButton2,
                rootView.periodButton3
            ]
        }
        
        for periodButton in periodButtons {
            if periodButton == sender {
                periodButton.backgroundColor = .terningMain
                periodButton.setTitleColor(.white, for: .normal)
                periodButton.isSelected.toggle()
                print("선택되었습니다.")
            } else {
                periodButton.backgroundColor = .clear
                periodButton.setTitleColor(.grey400, for: .normal)
                periodButton.isSelected = false
                print("취소되었습니다.")
            }
        }
    }
}
