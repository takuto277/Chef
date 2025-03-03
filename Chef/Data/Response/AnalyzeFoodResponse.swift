//
//  AnalyzeFoodResponse.swift
//  Chef
//
//  Created by 小野拓人 on 2025/03/04.
//

import Foundation

struct AnalyzeFoodResponse: Codable {
    let foods: [AnalyzeFood]
}

struct AnalyzeFood: Codable, Identifiable {
    let id: UUID
    let name: String
    let quantity: String
    
    enum CodingKeys: String, CodingKey {
        case name, quantity
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = UUID()
        name = try container.decode(String.self, forKey: .name)
        quantity = try container.decode(String.self, forKey: .quantity)
    }
}
