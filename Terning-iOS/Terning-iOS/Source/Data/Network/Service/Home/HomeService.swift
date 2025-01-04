//
//  HomeService.swift
//  Terning-iOS
//
//  Created by 이명진 on 1/3/25.
//

import Foundation

protocol HomeServiceProtocol {
    func fetchHomeData(sortBy: String, page: Int) async throws -> JobMainModel
    func fetchHomeTodayData() async throws -> UpcomingCardModel
}

final class HomeService: HomeServiceProtocol {
    private let provider = Providers.homeProvider

    func fetchHomeData(sortBy: String, page: Int) async throws -> JobMainModel {
        return try await withCheckedThrowingContinuation { continuation in
            provider.request(.getHome(sortBy: sortBy, page: page)) { result in
                switch result {
                case .success(let response):
                    do {
                        let responseDto = try response.map(BaseResponse<JobMainModel>.self)
                        if let data = responseDto.result {
                            continuation.resume(returning: data)
                        } else {
                            continuation.resume(throwing: NSError(domain: "No data", code: -1))
                        }
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func fetchHomeTodayData() async throws -> UpcomingCardModel {
        return try await withCheckedThrowingContinuation { continuation in
            provider.request(.getHomeToday) { result in
                switch result {
                case .success(let response):
                    do {
                        let responseDto = try response.map(BaseResponse<UpcomingCardModel>.self)
                        if let data = responseDto.result {
                            continuation.resume(returning: data)
                        } else {
                            continuation.resume(throwing: NSError(domain: "No data", code: -1))
                        }
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
