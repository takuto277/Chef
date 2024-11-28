//
//  Date.swift
//  Chef
//
//  Created by 小野拓人 on 2024/11/29.
//

import Foundation

extension Date {
    static func getCurrentDateString() -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        formatter.dateFormat = "yyyyMMddHHmm"
        return formatter.string(from: Date())
    }
}
