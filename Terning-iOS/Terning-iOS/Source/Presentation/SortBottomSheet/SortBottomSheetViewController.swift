//
//  SortBottomSheetViewController.swift
//  Terning-iOS
//
//  Created by 김민성 on 7/12/24.
//

import UIKit

import SnapKit
import Then

class SortBottomSheetViewController: UIViewController {
    
    // MARK: - UIComponents
    
    var rootView = SortBottomSheetView()
    
    // MARK: - LifeCycles
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
