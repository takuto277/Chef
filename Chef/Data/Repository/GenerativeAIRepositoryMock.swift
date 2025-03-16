//
//  GenerativeAIRepositoryMock.swift
//  Chef
//
//  Created by 小野拓人 on 2025/03/16.
//

import Foundation
import UIKit

internal actor GenerativeAIRepositoryMock: GenerativeAIRepository {
    static let shared = GenerativeAIRepositoryMock()
    
    func analyzeFoodItems(_ image: UIImage) async throws -> [AnalyzeFood] {
        return try processMockResponse()
    }
    
    
    private func processMockResponse() throws -> [AnalyzeFood] {
        let mockJson = """
        ```json
        {
          "foods": [
            {"name": "キャベツ", "quantity": "2"},
            {"name": "ピーマン", "quantity": "2"},
            {"name": "パプリカ", "quantity": "1"},
            {"name": "玉ねぎ", "quantity": "2"},
            {"name": "ナス", "quantity": "2"},
            {"name": "トマト", "quantity": "2"},
            {"name": "じゃがいも", "quantity": "3"},
            {"name": "にんじん", "quantity": "3"},
            {"name": "アボカド", "quantity": "1"},
            {"name": "ミニトマト", "quantity": "8"},
            {"name": "キュウリ", "quantity": "1"},
            {"name": "ブロッコリー", "quantity": "1"},
            {"name": "アスパラガス", "quantity": "約10"},
            {"name": "カブ", "quantity": "1"},
            {"name": "マッシュルーム", "quantity": "7"},
            {"name": "パセリ", "quantity": "1束"}

          ]
        }
        ```
        """
        
        return try processResponseText(mockJson)
    }
    
    private func processResponseText(_ responseText: String) throws -> [AnalyzeFood] {
        var jsonString = responseText
        
        // マークダウンコードブロックの削除
        let codeBlockPattern = "```(?:json)?([\\s\\S]*?)```"
        if let regex = try? NSRegularExpression(pattern: codeBlockPattern),
           let match = regex.firstMatch(in: jsonString, range: NSRange(jsonString.startIndex..., in: jsonString)) {
            if let range = Range(match.range(at: 1), in: jsonString) {
                // コードブロック内のコンテンツだけを抽出
                jsonString = String(jsonString[range])
            }
        }
        
        // 各行の余分な空白を削除
        jsonString = jsonString.split(separator: "\n")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .joined(separator: "\n")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard let jsonData = jsonString.data(using: .utf8) else {
            throw GeminiError.invalidResponse
        }
        
        let decoder = JSONDecoder()
        do {
            let result = try decoder.decode(AnalyzeFoodResponse.self, from: jsonData)
            
            if result.foods.isEmpty {
                throw GeminiError.noFoodItemsDetected
            }
            return result.foods
        } catch let error {
            throw GeminiError.parsingError(error.localizedDescription, jsonString)
        }
    }
}
