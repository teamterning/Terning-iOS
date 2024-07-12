//
//  ScrapResult.swift
//  Terning-iOS
//
//  Created by 이명진 on 7/12/24.
//

import Foundation

struct ScrapResult: Codable {
    let scrapsByDeadline: [ScrapByDeadline]
}

struct ScrapByDeadline: Codable {
    let deadline: String
    let scraps: [Scrap]
}

struct Scrap: Codable {
    let scrapId: Int
    let title: String
    let deadline: String
    let color: String
}

import Foundation

func createDummyData() -> ScrapResult {
    return ScrapResult(
        scrapsByDeadline: [
            ScrapByDeadline(
                deadline: "2024-07-01",
                scraps: [
                    Scrap(scrapId: 1, title: "마케팅 인턴 모집", deadline: "2024-07-01", color: "#FF12B4")
                ]
            ),
            ScrapByDeadline(
                deadline: "2024-07-05",
                scraps: [
                    Scrap(scrapId: 3, title: "개발자 인턴 모집", deadline: "2024-07-05", color: "#FF98F7"),
                    Scrap(scrapId: 4, title: "디자인 인턴 모집", deadline: "2024-07-05", color: "#1234FF")
                ]
            )
        ]
    )
}

