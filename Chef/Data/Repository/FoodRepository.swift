//
//  FoodRepository.swift
//  Chef
//
//  Created by 小野拓人 on 2024/11/21.
//

import Foundation

internal protocol FoodRepository: Actor {
    
}

internal actor FoodRepositoryImpl: FoodRepository {
        private let gateway: SwiftDataGateway

    init(gateway: SwiftDataGateway) {
        self.gateway = gateway
    }

    func addFood(name: String, calories: Int) {
        do {
            try gateway.createFood(Food(name: name, calories: calories))
        } catch {
            print("Failed to add food: \(error)")
        }
    }

    func getAllFoods() -> [Food] {
        do {
            return try gateway.fetchAllFoods()
        } catch {
            print("Failed to fetch foods: \(error)")
            return []
        }
    }

    func removeFood(_ food: Food) {
        do {
            try gateway.deleteFood(food)
        } catch {
            print("Failed to delete food: \(error)")
        }
    }
}
