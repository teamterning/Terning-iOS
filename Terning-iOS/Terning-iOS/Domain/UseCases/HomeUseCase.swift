//
//  HomeUseCase.swift
//  Terning-iOS
//
//  Created by 이명진 on 1/3/25.
//

import Foundation

protocol HomeUseCaseProtocol {
    func execute(sortBy: String, page: Int) async throws -> JobMainModel
    func executeToday() async throws -> UpcomingCardModel
}

final class HomeUseCase: HomeUseCaseProtocol {
    private let repository: HomeRepositoryProtocol

    init(repository: HomeRepositoryProtocol) {
        self.repository = repository
    }

    func execute(sortBy: String, page: Int) async throws -> JobMainModel {
        return try await repository.getHomeData(sortBy: sortBy, page: page)
    }

    func executeToday() async throws -> UpcomingCardModel {
        return try await repository.getHomeTodayData()
    }
}
