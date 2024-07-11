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
//    private lazy var  filteringSettingNavigationBar = CustomNavigation
    
    // MARK: - LifeCycles
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTarget()
    }
}

// MARK: - UI & Layout

extension FilteringSettingViewController {
    
    func setTarget() {
        rootView.gradeButton1.addTarget(self, action: #selector(gradeButton1DidTap), for: .touchUpInside)
        rootView.gradeButton2.addTarget(self, action: #selector(gradeButton2DidTap), for: .touchUpInside)
        rootView.gradeButton3.addTarget(self, action: #selector(gradeButton3DidTap), for: .touchUpInside)
        rootView.gradeButton4.addTarget(self, action: #selector(gradeButton4DidTap), for: .touchUpInside)
    }
    
    // MARK: - ButtonClickEvent
    
    @objc
    func gradeButton1DidTap() {
        print("1학년")
        

        if rootView.gradeButton1.isSelected {
            rootView.gradeButton1.backgroundColor = .clear
            rootView.gradeButton1.isSelected.toggle()
            
        } else {
            rootView.gradeButton1.backgroundColor = .terningMain
            rootView.gradeButton1.isSelected.toggle()
        }
    }
    
    @objc
    func gradeButton2DidTap() {
        print("2학년")
        
        if rootView.gradeButton2.isSelected {
            rootView.gradeButton2.backgroundColor = .clear
            rootView.gradeButton2.isSelected.toggle()
            
        } else {
            rootView.gradeButton2.backgroundColor = .terningMain
            rootView.gradeButton2.isSelected.toggle()
        }
    }
    
    @objc
    func gradeButton3DidTap() {
        print("3학년")
        
        if rootView.gradeButton3.isSelected {
            rootView.gradeButton3.backgroundColor = .clear
            rootView.gradeButton3.isSelected.toggle()
            
        } else {
            rootView.gradeButton3.backgroundColor = .terningMain
            rootView.gradeButton3.isSelected.toggle()
        }
    }
    
    @objc
    func gradeButton4DidTap() {
        print("4학년")
        if rootView.gradeButton4.isSelected {
            rootView.gradeButton4.backgroundColor = .clear
            rootView.gradeButton4.isSelected.toggle()
            
        } else {
            rootView.gradeButton4.backgroundColor = .terningMain
            rootView.gradeButton4.isSelected.toggle()
        }
    }
}
