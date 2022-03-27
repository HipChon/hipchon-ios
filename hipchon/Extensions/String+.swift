//
//  String+.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/19.
//

import Foundation

extension String {
    func strToDate() -> Date {
        let dateString: String = self

        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = Date.defaultFormat
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?

        return dateFormatter.date(from: dateString) ?? Date()
    }
}
