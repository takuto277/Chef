//
//  String.swift
//  Chef
//
//  Created by 小野拓人 on 2025/02/09.
//

import Foundation
import UIKit

extension String {
    func width(usingFont font: UIFont) -> CGFloat {
        let attributes = [NSAttributedString.Key.font: font]
        let size = (self as NSString).size(withAttributes: attributes)
        return size.width
    }
    /// 文字列から数値部分を抽出する
    /// 例: "2個" → 2, "1束" → 1, "約10" → 10
    func extractNumber() -> Int {
        // 正規表現で数字部分を抽出
        let pattern = "^[0-9]+"
        let regex = try? NSRegularExpression(pattern: pattern)
        let range = NSRange(location: 0, length: self.utf16.count)
        
        if let match = regex?.firstMatch(in: self, range: range) {
            let matchRange = match.range
            if let range = Range(matchRange, in: self) {
                let numberString = String(self[range])
                return Int(numberString) ?? 1
            }
        }
        
        // 「約10」「およそ5」などの表現に対応
        if self.contains("約") || self.contains("およそ") {
            let cleanedString = self
                .replacingOccurrences(of: "約", with: "")
                .replacingOccurrences(of: "およそ", with: "")
                .trimmingCharacters(in: .whitespacesAndNewlines)
            
            // 再度数字を抽出
            if let match = regex?.firstMatch(in: cleanedString, range: NSRange(location: 0, length: cleanedString.utf16.count)) {
                let matchRange = match.range
                if let range = Range(matchRange, in: cleanedString) {
                    let numberString = String(cleanedString[range])
                    return Int(numberString) ?? 1
                }
            }
        }
        
        // 特定の表現に対する固定値マッピング
        let specialCases: [String: Int] = [
            "一": 1, "二": 2, "三": 3, "四": 4, "五": 5,
            "六": 6, "七": 7, "八": 8, "九": 9, "十": 10,
            "ひとつ": 1, "ふたつ": 2, "みっつ": 3,
            "少々": 1, "適量": 1, "一束": 1, "一袋": 1
        ]
        
        for (key, value) in specialCases {
            if self.contains(key) {
                return value
            }
        }
        
        // デフォルト値
        return 1
    }
}
