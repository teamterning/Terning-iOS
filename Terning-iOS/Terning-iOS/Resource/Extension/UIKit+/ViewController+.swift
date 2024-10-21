//
//  ViewController+.swift
//  Terning-iOS
//
//  Created by 이명진 on 7/5/24.
//

import UIKit
import AmplitudeSwift

extension UIViewController {
    convenience init(backgroundColor: UIColor) {
        self.init()
        self.view.backgroundColor = backgroundColor
    }
    
    func showToast(message: String, heightOffset: CGFloat? = nil) {
        let height = heightOffset ?? 88 // default 값
        
        Toast.show(
            message: message,
            view: self.view,
            safeAreaBottomInset: self.safeAreaBottomInset(),
            height: height
        )
    }
    
    func showNetworkFailureToast() {
        showToast(message: "네트워크 통신 실패")
    }
    
    private func safeAreaBottomInset() -> CGFloat {
        return view.safeAreaInsets.bottom
    }
}

public extension UIViewController {
    
    /**
     
     - Description:
     
     VC나 View 내에서 해당 함수를 호출하면, 햅틱이 발생하는 메서드입니다.
     버튼을 누르거나 유저에게 특정 행동이 발생했다는 것을 알려주기 위해 다음과 같은 햅틱을 활용합니다.
     
     - parameters:
     
     - degree: 터치의 세기 정도를 정의합니다. 보통은 medium,light를 제일 많이 활용합니다?!
     따라서 파라미터 기본값을 . medium으로 정의했습니다.
     
     */
    
    func makeVibrate(degree: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        let generator = UIImpactFeedbackGenerator(style: degree)
        generator.impactOccurred()
    }
    
    /// 뷰 컨트롤러가 네비게이션 스택에 있으면 pop 하고, 나머지는  dismiss 합니다.
    func popOrDismissViewController(animated: Bool = true) {
        if let navigationController = self.navigationController, navigationController.viewControllers.contains(self) {
            navigationController.popViewController(animated: animated)
        } else if self.presentingViewController != nil {
            self.dismiss(animated: animated)
        }
    }
}

extension UIViewController {
    
    /**
     
     - Description:
     
     텍스트 필드 외부를 터치하면, 키보드가 내려갑니다.
     
     */
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIViewController {
    
    /**
     
     - Description:
     
     Custom bottom sheet을 띄우는 역할을 합니다 .
     
     */
    
    func presentCustomBottomSheet(_ contentVC: UIViewController, heightFraction: CGFloat = 380, dimmingOpacity: CGFloat = 0.3) {
        
        let fraction = UISheetPresentationController.Detent.custom { _ in
            self.view.frame.height * (heightFraction/812)
        }
        
        if let sheet = contentVC.sheetPresentationController {
            sheet.detents = [fraction, fraction]
            sheet.largestUndimmedDetentIdentifier = nil
            contentVC.modalPresentationStyle = .custom
            
            if let presentingView = self.view {
                let dimmedBackgroundView = UIView(frame: presentingView.bounds)
                dimmedBackgroundView.backgroundColor = UIColor(white: 0, alpha: dimmingOpacity)
                dimmedBackgroundView.tag = 999
                presentingView.addSubview(dimmedBackgroundView)
                presentingView.bringSubviewToFront(contentVC.view)
            }
            
            contentVC.presentationController?.delegate = self as? UIAdaptivePresentationControllerDelegate
        }
        
        self.present(contentVC, animated: true)
    }
}

extension UIViewController {
    
    /**
     
     - Description:
     
     custom모달을 내릴때 BackgroundView를 삭제하는 역할을 합니다 .
     
     */
    
    func removeModalBackgroundView() {
        if let presentingView = self.view {
            presentingView.subviews.forEach { subview in
                if let dimmedBackgroundView = subview.viewWithTag(999) {
                    UIView.animate(withDuration: 0.3) {
                        dimmedBackgroundView.alpha = 0
                    } completion: { _ in
                        dimmedBackgroundView.removeFromSuperview()
                    }
                }
            }
        }
    }
}

extension UIViewController {
    
    /**
     
     - Description:
     
     Amplitude 추적 메서드
     
     */
    
    public func track(eventName: AmplitudeEventType , eventProperties: [String: Any]? = nil) {
        AmplitudeManager.shared.track(eventType: eventName, eventProperties: eventProperties)
    }
    
    public func trackScreenDuration(eventName: AmplitudeEventType, duration: TimeInterval) {
        let durationInSeconds = Int(duration)
        
        AmplitudeManager.shared.track(eventType: eventName, eventProperties: [
            "duration": durationInSeconds
        ])
    }
}
