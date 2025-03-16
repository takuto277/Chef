//
//  GenerativeAIRepository.swift
//  Chef
//
//  Created by 小野拓人 on 2025/03/04.
//

import Foundation
import GoogleGenerativeAI
import UIKit

internal protocol GenerativeAIRepository: Actor {
    func analyzeFoodItems(_ image: UIImage) async throws -> [AnalyzeFood]
}

internal actor GenerativeAIRepositoryImpl: GenerativeAIRepository {
    static let shared = GenerativeAIRepositoryImpl()
    private let model: GenerativeModel
    
    init() {
        self.model = GenerativeModel(name: "gemini-1.5-flash", apiKey: APIKey.default)
    }
    
    func analyzeFoodItems(_ image: UIImage) async throws -> [AnalyzeFood] {
        
        let prompt = """
                    List all visible food items & quantities as JSON:
                    {
                        "foods": [
                            {"name": "食材名", "quantity": "数値"}
                        ]
                    }
                    Names in Japanese, count visible items only.
                    """
        let response = try await model.generateContent(prompt, image)
        
        guard let responseText = response.text else {
            throw GeminiError.invalidResponse
        }
        print("Geminiのレスポンスjson: \(responseText)")
        
        return try processResponseText(responseText)
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
        
        print("整形後のjson:\n\(jsonString)")
        
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
