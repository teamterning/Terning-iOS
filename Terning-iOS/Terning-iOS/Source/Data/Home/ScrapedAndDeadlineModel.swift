//
//  ScrapedAndDeadlineModel.swift
//  Terning-iOS
//
//  Created by 김민성 on 7/10/24.
//

import UIKit

struct ScrapedAndDeadlineModel {
    let color: CGColor
    let title: String
}

extension ScrapedAndDeadlineModel {
    static func getScrapedData() -> [ScrapedAndDeadlineModel] {
        return [
            ScrapedAndDeadlineModel(
                color: UIColor(resource: .calYellow).cgColor,
                title: "[유한킴벌리] 그린캠프 w.대학생 숲활동가 모집3"
            ),
            
            ScrapedAndDeadlineModel(
                color: UIColor(resource: .calPurple).cgColor,
                title: "[유한킴벌리] 그린캠프 w.대학생 숲활동가 모집3"
            ),
            
            ScrapedAndDeadlineModel(
                color: UIColor(resource: .calOrange).cgColor,
                title: "[유한킴벌리] 그린캠프 w.대학생 숲활동가 모집3"
            ),
            
            ScrapedAndDeadlineModel(
                color: UIColor(resource: .calBlue1).cgColor,
                title: "[유한킴벌리] 그린캠프 w.대학생 숲활동가 모집3"
            )
        ]
    }
}
