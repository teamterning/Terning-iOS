//
//  Providers.swift
//  Terning-iOS
//
//  Created by 이명진 on 7/16/24.
//

import Foundation

import Moya

struct Providers {
    static let calendarProvider = MoyaProvider<CalendarTargerType>(withAuth: false)
    static let authProvider = MoyaProvider<AuthTargetType>(withAuth: false)
    static let homeProvider = MoyaProvider<HomeTargertType>(withAuth: false)
    static let myPageProvider = MoyaProvider<MyPageTargetType>(withAuth: false)
    static let scrapsProvider = MoyaProvider<ScrapsTargetType>(withAuth: false)
    static let filtersProvider = MoyaProvider<FiltersTargetType>(withAuth: false)
    static let announcementsProvider = MoyaProvider<AnnouncementsProviderTargetType>(withAuth: false)
    static let searchProvider = MoyaProvider<SearchTargetType>(withAuth: false)
}

extension MoyaProvider {
    convenience init(withAuth: Bool) {
        if withAuth {
            self.init(session: Session(interceptor: AuthInterceptor.shared),
                      plugins: [NetworkLoggerPlugin(verbose: true)])
        } else {
            self.init(plugins: [NetworkLoggerPlugin(verbose: true)])
        }
    }
}

