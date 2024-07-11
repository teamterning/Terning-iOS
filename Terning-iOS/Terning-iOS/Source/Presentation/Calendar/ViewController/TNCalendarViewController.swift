//
//  TNCalendarViewController.swift
//  Terning-iOS
//
//  Created by 이명진 on 7/11/24.
//

import UIKit

final class TNCalendarViewController: UIViewController {
    
    // MARK: - UIComponents
    
    private let rootView = TNCalendarView()
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setDelegate()
        setRegister()
    }
    
    override func loadView() {
        self.view = rootView
    }
    
    // MARK: - UI & Layout
    
    private func setUI() {
        view.backgroundColor = .white
    }
    
    private func setDelegate() {
        
    }
    
    private func setRegister() {
        
    }
    
}
