//
//  HomeRepository.swift
//  Terning-iOS
//
//  Created by 이명진 on 1/3/25.
//

import Foundation

protocol HomeRepositoryProtocol {
    func getHomeData(sortBy: String, page: Int) async throws -> JobMainModel
    func getHomeTodayData() async throws -> UpcomingCardModel
}

final class HomeRepository: HomeRepositoryProtocol {
    private let homeService: HomeServiceProtocol

    init(homeService: HomeServiceProtocol) {
        self.homeService = homeService
    }

    func getHomeData(sortBy: String, page: Int) async throws -> JobMainModel {
        return try await homeService.fetchHomeData(sortBy: sortBy, page: page)
    }

    func getHomeTodayData() async throws -> UpcomingCardModel {
        return try await homeService.fetchHomeTodayData()
    }
}
