//
//  JobCardModel.swift
//  Terning-iOS
//
//  Created by 김민성 on 7/10/24.
//

import UIKit

struct JobCardModel {
    let coverImage: UIImage
    let daysRemaining: String
    let title: String
    let period: String
    let isScraped: Bool
}

extension JobCardModel {
    static func getJobCardData() -> [JobCardModel] {
        return [
            JobCardModel(
                coverImage: UIImage(resource: .icHome),
                // scrapIcon: UIImage(resource: .ic28Bookmark),
                daysRemaining: "D-2",
                title: "[SomeOne] 콘텐츠 마케터 대학생 인턴 채용",
                period: "2개월",
                isScraped: false
            ),
            
            JobCardModel(
                coverImage: UIImage(resource: .icHome),
                // scrapIcon: UIImage(resource: .ic28Bookmark),
                daysRemaining: "D-2",
                title: "[SomeOne] 콘텐츠 마케터 대학생 인턴 채용",
                period: "2개월",
                isScraped: false
            ),
            
            JobCardModel(
                coverImage: UIImage(resource: .icHome),
                // scrapIcon: UIImage(resource: .ic28Bookmark),
                daysRemaining: "D-2",
                title: "[SomeOne] 콘텐츠 마케터 대학생 인턴 채용",
                period: "2개월",
                isScraped: false
            ),
            
            JobCardModel(
                coverImage: UIImage(resource: .icHome),
                // scrapIcon: UIImage(resource: .ic28Bookmark),
                daysRemaining: "D-2",
                title: "[SomeOne] 콘텐츠 마케터 대학생 인턴 채용",
                period: "2개월",
                isScraped: false
            ),
            
            JobCardModel(
                coverImage: UIImage(resource: .icHome),
                // scrapIcon: UIImage(resource: .ic28Bookmark),
                daysRemaining: "D-2",
                title: "[SomeOne] 콘텐츠 마케터 대학생 인턴 채용",
                period: "2개월",
                isScraped: false
            ),
            
            JobCardModel(
                coverImage: UIImage(resource: .icHome),
                // scrapIcon: UIImage(resource: .ic28Bookmark),
                daysRemaining: "D-2",
                title: "[SomeOne] 콘텐츠 마케터 대학생 인턴 채용",
                period: "2개월",
                isScraped: false
            ),
            
            JobCardModel(
                coverImage: UIImage(resource: .icHome),
                // scrapIcon: UIImage(resource: .ic28Bookmark),
                daysRemaining: "D-2",
                title: "[SomeOne] 콘텐츠 마케터 대학생 인턴 채용",
                period: "2개월",
                isScraped: false
            ),
            
            JobCardModel(
                coverImage: UIImage(resource: .icHome),
                // scrapIcon: UIImage(resource: .ic28Bookmark),
                daysRemaining: "D-2",
                title: "[SomeOne] 콘텐츠 마케터 대학생 인턴 채용",
                period: "2개월",
                isScraped: false
            ),
            
            JobCardModel(
                coverImage: UIImage(resource: .icHome),
                // scrapIcon: UIImage(resource: .ic28Bookmark),
                daysRemaining: "D-2",
                title: "[SomeOne] 콘텐츠 마케터 대학생 인턴 채용",
                period: "2개월",
                isScraped: false
            ),
            
            JobCardModel(
                coverImage: UIImage(resource: .icHome),
                // scrapIcon: UIImage(resource: .ic28Bookmark),
                daysRemaining: "D-2",
                title: "[SomeOne] 콘텐츠 마케터 대학생 인턴 채용",
                period: "2개월",
                isScraped: false
            ),
            
            JobCardModel(
                coverImage: UIImage(resource: .icHome),
                // scrapIcon: UIImage(resource: .ic28Bookmark),
                daysRemaining: "D-2",
                title: "[SomeOne] 콘텐츠 마케터 대학생 인턴 채용",
                period: "2개월",
                isScraped: false
            )
        ]
    }
}
