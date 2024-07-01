//
//  TNTabBarController.swift
//  Terning-iOS
//
//  Created by 이명진 on 6/29/24.
//

import UIKit

import Then

final class TNTabBarController: UITabBarController {
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setTabBarControllers()
    }
}

// MARK: - Methods

extension TNTabBarController {
    private func setUI() {
        tabBar.do {
            $0.backgroundColor = .white
            $0.unselectedItemTintColor = .gray
            $0.tintColor = .terningGreen
            $0.layer.applyShadow(alpha: 0.05, y: -2, blur: 5)
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
    
    private func templateNavigationController(title: String, unselectedImage: UIImage?, selectedImage: UIImage?, rootViewController: UIViewController) -> UINavigationController {
        return UINavigationController(rootViewController: rootViewController).then {
            $0.title = title
            $0.tabBarItem.image = unselectedImage
            $0.tabBarItem.selectedImage = selectedImage
            $0.navigationBar.isHidden = true
        }
    }
}
