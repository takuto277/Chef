//
//  GeminiError.swift
//  Chef
//
//  Created by 小野拓人 on 2025/03/16.
//

enum GeminiError: Error {
    case imageConversionFailed
    case invalidResponse
    case parsingError(String, String)
    case noFoodItemsDetected
    
    var localizedDescription: String {
        switch self {
        case .imageConversionFailed:
            return "画像の変換に失敗しました"
        case .invalidResponse:
            return "AIからの応答の解析に失敗しました"
        case let .parsingError(errorMessage, jsonString):
            return "データの解析エラー: errorMessage:\(errorMessage), jsonString: \(jsonString)"
        case .noFoodItemsDetected:
            return "画像内に食品アイテムが検出されませんでした"
        }
    }
}
