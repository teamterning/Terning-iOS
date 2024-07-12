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
            ),
            ScrapByDeadline(
                deadline: "2024-07-10",
                scraps: [
                    Scrap(scrapId: 5, title: "HR 인턴 모집", deadline: "2024-07-10", color: "#FF0000"),
                    Scrap(scrapId: 6, title: "회계 인턴 모집", deadline: "2024-07-10", color: "#00FF00"),
                    Scrap(scrapId: 7, title: "경영 인턴 모집", deadline: "2024-07-10", color: "#0000FF")
                ]
            ),
            ScrapByDeadline(
                deadline: "2024-07-15",
                scraps: [
                    Scrap(scrapId: 8, title: "데이터 분석 인턴 모집", deadline: "2024-07-15", color: "#FF12B4"),
                    Scrap(scrapId: 9, title: "컨설팅 인턴 모집", deadline: "2024-07-15", color: "#FF98F7"),
                    Scrap(scrapId: 10, title: "엔지니어 인턴 모집", deadline: "2024-07-15", color: "#1234FF"),
                    Scrap(scrapId: 11, title: "프로젝트 매니저 인턴 모집", deadline: "2024-07-15", color: "#00FF00")
                ]
            )
        ]
    )
}
