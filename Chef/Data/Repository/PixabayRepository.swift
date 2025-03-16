//
//  PixabayRepository.swift
//  Chef
//
//  Created by 小野拓人 on 2025/03/16.
//

import Foundation
import UIKit

internal protocol PixabayRepository: Actor {
    func fetchFoodImageFromPixabay(foodName: String) async throws -> UIImage?
}

internal actor PixabayRepositoryImpl: PixabayRepository {
    static let shared = PixabayRepositoryImpl()
    
    
    internal func fetchFoodImageFromPixabay(foodName: String) async throws -> UIImage? {
        let searchQuery = "\(foodName)"
        guard let encodedQuery = searchQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            throw NSError(domain: "Invalid search query", code: 400, userInfo: nil)
        }
        
        let apiKey = PixabayAPIKey.default
        let urlString = "https://pixabay.com/api/?key=\(apiKey)&q=\(encodedQuery)&image_type=photo&per_page=3"
        
        guard let url = URL(string: urlString) else {
            throw NSError(domain: "Invalid URL", code: 400, userInfo: nil)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NSError(domain: "Invalid response", code: (response as? HTTPURLResponse)?.statusCode ?? 500, userInfo: nil)
        }
        
        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
              let hits = json["hits"] as? [[String: Any]],
              let firstHit = hits.first,
              let imageUrl = firstHit["webformatURL"] as? String,
              let imageURL = URL(string: imageUrl) else {
            throw NSError(domain: "Failed to parse JSON", code: 500, userInfo: nil)
        }
        
        let (imageData, _) = try await URLSession.shared.data(from: imageURL)
        return UIImage(data: imageData)
    }
}
