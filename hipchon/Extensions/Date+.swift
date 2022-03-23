//
//  Date+.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/19.
//

import Foundation

public extension Date {
    static let defaultFormat = "YYYY-MM-DDTHH:mm:ss.SSS"
//    static let defaultFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

    static var currentDate: String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = defaultFormat
        let dateStr = dateFormatter.string(from: date)
        return dateStr
    }

    // "yyyy-MM-dd-hh-mm"
    func dateToStr(dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.locale = Locale(identifier: "ko_KR")
        let dateStr = dateFormatter.string(from: self)
        return dateStr
    }

    var relativeTime: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}
