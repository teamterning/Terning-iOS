//
//  ViewController+.swift
//  Terning-iOS
//
//  Created by 이명진 on 7/5/24.
//

import UIKit

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
