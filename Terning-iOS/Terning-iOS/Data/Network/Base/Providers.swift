//
//  Providers.swift
//  Terning-iOS
//
//  Created by 이명진 on 7/16/24.
//

import Foundation

import Moya

struct Providers {
    static let calendarProvider = MoyaProvider<CalendarTargetType>(withAuth: true)
    static let authProvider = MoyaProvider<AuthTargetType>(withAuth: false)
    static let homeProvider = MoyaProvider<HomeTargetType>(withAuth: true)
    static let myPageProvider = MoyaProvider<MyPageTargetType>(withAuth: true)
    static let scrapsProvider = MoyaProvider<ScrapsTargetType>(withAuth: true)
    static let filtersProvider = MoyaProvider<FiltersTargetType>(withAuth: true)
    static let announcementsProvider = MoyaProvider<AnnouncementsTargetType>(withAuth: true)
    static let searchProvider = MoyaProvider<SearchTargetType>(withAuth: true)
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
