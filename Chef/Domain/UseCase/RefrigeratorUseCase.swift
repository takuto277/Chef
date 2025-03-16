//
//  RefrigeratorUseCase.swift
//  Chef
//
//  Created by 小野拓人 on 2024/11/21.
//

import Foundation
import UIKit
import Vision
import CoreML

internal protocol RefrigeratorUseCase {
    func create(name: String, imageUrl: String?, category: String, quantity: Int, expirationDate: String, memo: String) async throws
    func fetchAll() async throws -> [Food]
    func update(oldFood: Food) async throws
    func analyzeFoodItems(_ image: UIImage) async throws -> [AnalyzeFood]
    func segmentFoods(image: UIImage, foods: [AnalyzeFood]) async throws -> [SegmentedFood]
}

final class RefrigeratorUseCaseImpl: RefrigeratorUseCase {
    private let foodRepository: FoodRepository
    private let generativeAIRepository: GenerativeAIRepository
    private let pixabayRepository: PixabayRepository
    
    internal init(
        foodRepository: FoodRepository = FoodRepositoryFactory.createRepository(),
        generativeAIRepository: GenerativeAIRepository = GenerativeAIRepositoryImpl.shared,
        pixabayRepository: PixabayRepository = PixabayRepositoryImpl.shared
    ) {
        self.foodRepository = foodRepository
        self.generativeAIRepository = generativeAIRepository
        self.pixabayRepository = pixabayRepository
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
    
    internal func segmentFoods(image: UIImage, foods: [AnalyzeFood]) async throws -> [SegmentedFood] {
        var segmentedFoods: [SegmentedFood] = []
        
        if foods.count == 1 {
            let food = foods[0]
            let segmentedFood = SegmentedFood(
                id: UUID(),
                name: food.name,
                quantity: food.quantity,
                image: image
            )
            segmentedFoods.append(segmentedFood)
            return segmentedFoods
        }
        
        for food in foods {
            if let foodImage = try? await pixabayRepository.fetchFoodImageFromPixabay(foodName: food.name) {
                let segmentedFood = SegmentedFood(
                    id: UUID(),
                    name: food.name,
                    quantity: food.quantity,
                    image: foodImage
                )
                segmentedFoods.append(segmentedFood)
            } else {
                let segmentedFood = SegmentedFood(
                    id: UUID(),
                    name: food.name,
                    quantity: food.quantity,
                    image: image
                )
                segmentedFoods.append(segmentedFood)
            }
        }
        
        return segmentedFoods
    }
}
