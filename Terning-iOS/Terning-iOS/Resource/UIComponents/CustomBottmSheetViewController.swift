//
//  CustomBottmSheetViewController.swift
//  Terning-iOS
//
//  Created by 이명진 on 7/17/24.
//

import UIKit
import RxSwift

import SnapKit
import Then

enum BottomSheet: CaseIterable {
    case expand, middle, low, end
    
    var height: Double {
        switch self {
        case .expand:
            return UIScreen.main.bounds.height * 0.86
        case .middle:
            return UIScreen.main.bounds.height * 0.6
        case .low:
            return UIScreen.main.bounds.height * 0.46
        default:
            return 0
        }
    }
}

final class CustomBottomSheetViewController: UIViewController {
    
    // MARK: - Property
    
    private lazy var screenHeight = UIScreen.main.bounds.height
    
    private var bottomHeight: Double = 380.0
    private var cancelBag = DisposeBag()
    
    private var upScroll: Bool
    private var isNotch: Bool
    
    // MARK: - UIComponents
    
    let contentViewController: UIViewController
    
    private let dimmedView = UIView().then {
        $0.backgroundColor = .black.withAlphaComponent(0.3)
        $0.isUserInteractionEnabled = true
    }
    
    private let notchView = UIView().then {
        $0.backgroundColor = .grey300
        $0.layer.cornerRadius = 2
        $0.isUserInteractionEnabled = true
    }
    
    private var bottomSheetView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.isUserInteractionEnabled = true
    }
    
    // MARK: - Life Cycles
    
    init(bottomType: BottomSheet, contentViewController: UIViewController = ViewController(), upScroll: Bool = true, isNotch: Bool = true) {
        self.contentViewController = contentViewController
        self.bottomHeight = bottomType.height
        self.upScroll = upScroll
        self.isNotch = isNotch
        
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setHierarchy()
        setLayout()
        setAddTarget()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        showBottomSheet()
    }
    
    // MARK: - UI & Layout
    
    private func setUI() {
        addChild(contentViewController)
        bottomSheetView.addSubview(contentViewController.view)
        contentViewController.didMove(toParent: self)
    }
    
    private func setHierarchy() {
        view.addSubviews(
            dimmedView,
            bottomSheetView
        )
        
        if isNotch {
            view.addSubview(notchView)
        }
        
        dimmedView.alpha = 0.0
    }
    
    private func setLayout() {
        dimmedView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        if isNotch {
            notchView.snp.makeConstraints {
                $0.top.equalTo(bottomSheetView.snp.top).offset(12)
                $0.centerX.equalTo(bottomSheetView.snp.centerX)
                $0.width.equalTo(60)
                $0.height.equalTo(4)
            }
        }
        
        bottomSheetView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.top.equalTo(view.snp.bottom).offset(0)
        }
        
        contentViewController.view.snp.makeConstraints {
            $0.top.equalTo(view.snp.bottom).offset(-349)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    // MARK: - Methods
    
    func closeBottomSheet() {
        hideBottomSheetAndGoBack()
    }
    
    private func setAddTarget() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dimmedViewDidTap))
        dimmedView.addGestureRecognizer(tapGesture)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(sender:)))
        bottomSheetView.addGestureRecognizer(panGesture)
        
    }
    
    private func showBottomSheet() {
        
        bottomSheetView.snp.remakeConstraints {
            $0.bottom.horizontalEdges.equalToSuperview()
            $0.top.equalToSuperview().inset(screenHeight - bottomHeight)
        }
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn) {
            self.dimmedView.alpha = 0.7
            self.view.layoutIfNeeded()
        }
    }
    
    private func hideBottomSheetAndGoBack() {
        
        bottomSheetView.snp.remakeConstraints {
            $0.bottom.horizontalEdges.equalToSuperview()
            $0.top.equalToSuperview().inset(screenHeight)
        }
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn) {
            self.dimmedView.alpha = 0.0
            self.view.layoutIfNeeded()
        } completion: { _ in
            if self.presentingViewController != nil {
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
    
    @objc private func handlePanGesture(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)
        let currentTop = bottomSheetView.frame.origin.y + translation.y
        
        switch sender.state {
        case .changed:
            // upScrollLimit이 false이면 위로 올리는 것을 제한 true 값이여야 올릴 수 있음
            if !upScroll && translation.y < 0 {
                return // 위로 이동하는 제스처 차단
            }
            // 현재 바텀 시트의 top 위치를 계산하고, 제한적으로 이동 가능하게 설정
            let newTop = max(0, currentTop)
            bottomSheetView.snp.updateConstraints { make in
                make.top.equalToSuperview().inset(newTop)
            }
            sender.setTranslation(CGPoint.zero, in: view)
            
        case .ended, .cancelled:
            // 종료 시, 속도가 빠르고 아래로 이동하는 경우 바텀시트를 숨김
            if velocity.y > 1500 {
                hideBottomSheetAndGoBack()
            } else {
                if upScroll { // true 이면 스냅 가능
                    snapBottomSheetToNearestPosition()
                } else { // false면 그냥 숨기기로 넘어감
                    hideBottomSheetAndGoBack()
                }
            }
            
        default:
            break
        }
    }
    
    private func snapBottomSheetToNearestPosition() {
        let positions: [Double] = BottomSheet.allCases.map { $0.height }
        let currentTop = screenHeight - bottomSheetView.frame.minY
        let closestPosition = positions.min(by: { abs(currentTop - $0) < abs(currentTop - $1) })!
        
        if closestPosition == 0 {
            hideBottomSheetAndGoBack()
        } else {
            bottomSheetView.snp.updateConstraints { make in
                make.top.equalToSuperview().inset(screenHeight - closestPosition)
            }
            
            UIView.animate(withDuration: 0.25, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @objc
    private func dimmedViewDidTap() {
        self.hideBottomSheetAndGoBack()
    }
}
