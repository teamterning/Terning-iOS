//
//  getKrDate.swift
//  Terning-iOS
//
//  Created by 정민지 on 7/10/24.
//

import Foundation

public extension Date {
    func getCurrentKrYearAndMonth() -> (year: Int, month: Int) {
        let currentDate = self
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
        let currentYear = calendar.component(.year, from: currentDate)
        let currentMonth = calendar.component(.month, from: currentDate)
        return (year: currentYear, month: currentMonth)
    }
}
