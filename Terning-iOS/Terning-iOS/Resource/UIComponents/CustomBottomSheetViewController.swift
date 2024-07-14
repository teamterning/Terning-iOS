//
//  CustomBottomSheet.swift
//  Terning-iOS
//
//  Created by 김민성 on 7/13/24.
//

import UIKit

import SnapKit
import Then

class CustomBottomSheetViewController: UIViewController {
    
    var bottomSheetContainer = SortBottomSheetView()
    
    // MARK: - UIComponents
    
    private let dimmedView = UIView().then {
        $0.backgroundColor = .darkGray.withAlphaComponent(0.7)
    }
    
    private let bottomSheetView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 30
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.clipsToBounds = true
    }
    
    private let floatingPanel = UIView().then {
        $0.backgroundColor = .grey300
        $0.layer.cornerRadius = 2
    }
    
    // MARK: LifeCycles
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showBottomSheet()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setHierarchy()
        setLayout()
        setTapGesture()
        setAddTarget()
    }
}

// MARK: - UI & Layout

extension CustomBottomSheetViewController {
    func setUI() {
        dimmedView.alpha = 0.0
    }
    
    func setHierarchy() {
        view.addSubviews(dimmedView, bottomSheetView)
        
        bottomSheetView.addSubviews(bottomSheetContainer, floatingPanel)
    }
    
    func setLayout() {
        dimmedView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        bottomSheetView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        bottomSheetContainer.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(8)
        }
        
        floatingPanel.snp.makeConstraints {
            $0.top.equalTo(bottomSheetView.snp.top).offset(12)
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(157)
            $0.height.equalTo(4)
        }
    }
    
    func setAddTarget() {
        bottomSheetContainer.sortByDeadline.addTarget(self, action: #selector(sortButtonSelected), for: .touchUpInside)
    }
}

extension CustomBottomSheetViewController {
    
    // MARK: - Methods
    
    func setTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dimmedViewTapped))
        dimmedView.addGestureRecognizer(tapGesture)
    }
    
    private func showBottomSheet() {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: { [weak self] in
            
            self?.bottomSheetView.snp.makeConstraints {
                $0.height.equalTo(380)
            }
            
            self?.dimmedView.alpha = 0.7
            
            self?.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func hideButtonSheet() {
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.bottomSheetView.snp.updateConstraints {
                $0.bottom.equalTo(380)
            }
            self?.dimmedView.backgroundColor = .clear
            
            self?.view.layoutIfNeeded()
        } completion: { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - objc Functions
    
    @objc
    func dimmedViewTapped() {
        hideButtonSheet()
    }
    
    @objc
    func sortButtonSelected(_ sender: UIButton) {
        print("sort button selected")
    }
}
