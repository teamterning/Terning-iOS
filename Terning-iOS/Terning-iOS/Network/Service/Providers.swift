//
//  Providers.swift
//  Terning-iOS
//
//  Created by 이명진 on 7/16/24.
//

import Foundation

import Moya

struct Providers {
    static let calendarProvider = MoyaProvider<CalendarTargertType>(withAuth: false)
    static let authProvider = MoyaProvider<AuthTargertType>(withAuth: false)
    static let homeProvider = MoyaProvider<HomeTargertType>(withAuth: false)
    static let myPageProvider = MoyaProvider<MyPageTargertType>(withAuth: false)
    static let scrapsProvider = MoyaProvider<ScrapsTargertType>(withAuth: false)
    static let filtersProvider = MoyaProvider<FiltersTargertType>(withAuth: false)
    static let announcementsProvider = MoyaProvider<AnnouncementsProviderTargertType>(withAuth: false)
    static let searchProvider = MoyaProvider<SearchTargertType>(withAuth: false)
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

