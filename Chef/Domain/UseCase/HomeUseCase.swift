//
//  HomeUseCase.swift
//  Chef
//
//  Created by 小野拓人 on 2024/11/21.
//

import Foundation

internal protocol HomeUseCase {
    func addFoodAndFetchAll(name: String, calories: Int) async throws -> [Food]
}

final class HomeUseCaseImpl: HomeUseCase {
    private let foodRepository: FoodRepository
    
    init(
        foodRepository: FoodRepository = FoodRepositoryFactory.createRepository()
    ) {
        self.foodRepository = foodRepository
    }

    func addFoodAndFetchAll(name: String, calories: Int) async throws -> [Food] {
        try await foodRepository.addFood(name: name, calories: calories)
        let allFoods = try await foodRepository.getAllFoods()
        return allFoods
    }
}
