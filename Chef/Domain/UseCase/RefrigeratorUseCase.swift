//
//  RefrigeratorUseCase.swift
//  Chef
//
//  Created by 小野拓人 on 2024/11/21.
//

import Foundation
import UIKit

internal protocol RefrigeratorUseCase {
    func create(name: String, imageUrl: String?, category: String, quantity: Int, expirationDate: String, memo: String) async throws
    func fetchAll() async throws -> [Food]
    func update(oldFood: Food) async throws
    func analyzeFoodItems(_ image: UIImage) async throws -> [AnalyzeFood]
}

final class RefrigeratorUseCaseImpl: RefrigeratorUseCase {
    private let foodRepository: FoodRepository
    private let generativeAIRepository: GenerativeAIRepository
    
    internal init(
        foodRepository: FoodRepository = FoodRepositoryFactory.createRepository(),
        generativeAIRepository: GenerativeAIRepository = GenerativeAIRepositoryImpl.shared
    ) {
        self.foodRepository = foodRepository
        self.generativeAIRepository = generativeAIRepository
    }
    
    internal func create(
        name: String,
        imageUrl: String?,
        category: String,
        quantity: Int,
        expirationDate: String,
        memo: String
    ) async throws {
        let id = try await foodRepository.fetchMaxIdCount()
        let nowDate = Date.getCurrentDateString()
        let food = Food(
            id: id,
            name: name,
            category: category,
            quantity: quantity,
            expirationDate: expirationDate,
            memo: memo,
            imageUrl: imageUrl,
            createTime: nowDate,
            updateTime: nowDate,
            purchaseCount: 0
        )
        try await foodRepository.addFood(food: food)
    }
    
    internal func fetchAll() async throws -> [Food] {
        try await foodRepository.fetchAllFoods()
    }
    
    internal func update(oldFood: Food) async throws {
        try await foodRepository.updateFood(oldFood: oldFood)
    }
    
    internal func analyzeFoodItems(_ image: UIImage) async throws -> [AnalyzeFood] {
        try await generativeAIRepository.analyzeFoodItems(image)
    }
}
