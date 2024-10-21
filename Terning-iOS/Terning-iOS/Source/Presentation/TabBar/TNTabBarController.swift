//
//  TNTabBarController.swift
//  Terning-iOS
//
//  Created by 이명진 on 6/29/24.
//

import UIKit

import Then
import AmplitudeSwift

final class TNTabBarController: UITabBarController {
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setTabBarControllers()
        setDelegate()
    }
}

// MARK: - Methods

extension TNTabBarController {
    private func setUI() {
        tabBar.do {
            $0.backgroundColor = .white
            $0.unselectedItemTintColor = .gray
            $0.tintColor = .terningMain
            $0.layer.applyShadow(color: .tabBarShadow, alpha: 1, y: -2, blur: 2)
        }
    }
    
    private func setTabBarControllers() {
        let tabBarItems: [TNTabBarItem] = [
            .home,
            .calendar,
            .search,
            .myPage
        ]
        
        viewControllers = tabBarItems.map { item in
            return templateNavigationController(
                title: item.title,
                unselectedImage: item.unselectedImage,
                selectedImage: item.selectedImage,
                rootViewController: item.viewController
            )
        }
    }
    
    private func setDelegate() {
        self.delegate = self
    }
    
    private func templateNavigationController(title: String, unselectedImage: UIImage?, selectedImage: UIImage?, rootViewController: UIViewController) -> UINavigationController {
        return UINavigationController(rootViewController: rootViewController).then {
            $0.title = title
            $0.tabBarItem.image = unselectedImage
            $0.tabBarItem.selectedImage = selectedImage
            $0.navigationBar.isHidden = true
        }
    }
}

// MARK: - UITabBarControllerDelegate

extension TNTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        trackTabBarClick(for: viewController, in: tabBarController)
    }
}

extension TNTabBarController {
    func trackTabBarClick(for viewController: UIViewController, in tabBarController: UITabBarController) {
        guard let selectedIndex = tabBarController.viewControllers?.firstIndex(of: viewController) else { return }
        
        let eventType: AmplitudeEventType
        
        print(selectedIndex)
        
        switch selectedIndex {
        case 0:
            eventType = .clickNavigationHome
        case 1:
            eventType = .clickNavigationCalendar
        case 2:
            eventType = .clickNavigationSearch
        case 3:
            eventType = .clickNavigationMyPage
        default:
            return
        }
        
        AmplitudeManager.shared.track(eventType: eventType)
    }
}
