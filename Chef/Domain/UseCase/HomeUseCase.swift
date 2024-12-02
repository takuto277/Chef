//
//  HomeUseCase.swift
//  Chef
//
//  Created by 小野拓人 on 2024/11/21.
//

import Foundation

internal protocol HomeUseCase {
    func create(name: String, imageData: Data?, category: String, quantity: Int, expirationDate: String, memo: String) async throws
    func fetchAll() async throws -> [Food]
    func update(oldFood: Food) async throws
}

final class HomeUseCaseImpl: HomeUseCase {
    private let foodRepository: FoodRepository
    
    internal init(
        foodRepository: FoodRepository = FoodRepositoryFactory.createRepository()
    ) {
        self.foodRepository = foodRepository
    }
    
    internal func create(
        name: String,
        imageData: Data?,
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
            imageData: imageData,
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
}
