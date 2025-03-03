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
        self.model = GenerativeModel(name: "gemini-pro", apiKey: APIKey.default)
    }
    
    func analyzeFoodItems(_ image: UIImage) async throws -> [AnalyzeFood] {
        guard let imageData = image.jpegData(compressionQuality: 0.5),
              let base64String = imageData.base64EncodedString().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            throw GeminiError.imageConversionFailed
        }
        
        let generativeModel = GenerativeModel(name: "gemini-1.5-flash", apiKey: APIKey.default)
        
        let prompt = """
                    List all visible food items & quantities as JSON:
                    {
                        "foods": [
                            {"name": "食材名", "quantity": "数値"}
                        ]
                    }
                    Names in Japanese, count visible items only.
                    Image: \(base64String)
                    """
        let response = try await model.generateContent(prompt)
        if let text = response.text {
            print("🌱\(text)")
        }
        
        guard let jsonString = response.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              let jsonData = jsonString.data(using: .utf8) else {
            throw GeminiError.invalidResponse
        }
        
        let decoder = JSONDecoder()
        do {
            let result = try decoder.decode(AnalyzeFoodResponse.self, from: jsonData)
            return result.foods
        } catch let error {
            throw GeminiError.parsingError(error.localizedDescription)
        }
    }
}

enum GeminiError: Error {
    case imageConversionFailed
    case invalidResponse
    case parsingError(String)
    
    var localizedDescription: String {
        switch self {
        case .imageConversionFailed:
            return "画像の変換に失敗しました"
        case .invalidResponse:
            return "AIからの応答の解析に失敗しました"
        case .parsingError(let message):
            return "データの解析エラー: \(message)"
        }
    }
}
