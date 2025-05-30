//
//  TNTabBarItem.swift
//  Terning-iOS
//
//  Created by 이명진 on 6/29/24.
//

import UIKit

enum TNTabBarItem {
    case home
    case calendar
    case search
    case myPage
    
    var title: String {
        switch self {
        case .home:
            return "홈"
        case .calendar:
            return "캘린더"
        case .search:
            return "탐색"
        case .myPage:
            return "마이"
        }
    }
    
    var unselectedImage: UIImage {
        switch self {
        case .home:
            return UIImage(resource: .icHome)
        case .calendar:
            return UIImage(resource: .icCalendar)
        case .search:
            return UIImage(resource: .icSearch)
        case .myPage:
            return UIImage(resource: .icPerson)
        }
    }
    
    var selectedImage: UIImage {
        switch self {
        case .home:
            return UIImage(resource: .icHomeFill)
        case .calendar:
            return UIImage(resource: .icCalendarFill)
        case .search:
            return UIImage(resource: .icSearchFill)
        case .myPage:
            return UIImage(resource: .icPersonFill)
        }
    }
    
    var viewController: UIViewController {
        switch self {
        case .home:
            return HomeViewController(
                viewModel: HomeViewModel(
                    useCase: HomeUseCase(
                        repository: HomeRepository(
                            homeService: HomeService()
                        )
                    ),
                    scrapUseCase: ScrapUseCase(
                        repository: ScrapRepository(
                            service: ScrapsService(
                                provider: Providers.scrapsProvider
                            )
                        )
                    )
                )
            )
        case .calendar:
            return TNCalendarViewController(
                viewModel: TNCalendarViewModel(
                    calendarRepository: TNCalendarRepository(
                        calendarService: TNCalendarService(
                            provider: Providers.calendarProvider
                        ),
                        scrapService: ScrapsService(
                            provider: Providers.scrapsProvider
                        )
                    )
                )
            )
        case .search:
            return SearchViewController(viewModel: SearchViewModel())
        case .myPage:
            return MyPageViewController(viewModel: MyPageViewModel())
        }
    }
}
