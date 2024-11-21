//
//  FoodRepository.swift
//  Chef
//
//  Created by 小野拓人 on 2024/11/21.
//

import Foundation

internal protocol FoodRepository: Actor {
    func addFood(name: String, calories: Int) async throws
    func getAllFoods() async throws -> [Food]
    func removeFood() async throws
}

internal actor FoodRepositoryImpl: FoodRepository {
    private let gateway: SwiftDataGatewayImpl<Food>
    
    init(gateway: SwiftDataGatewayImpl<Food>) {
        self.gateway = gateway
    }
    
    func addFood(name: String, calories: Int) async throws {
        let food = Food(name: name, calories: calories)
        try await gateway.create(data: food)
    }
    
    func getAllFoods() async throws -> [Food] {
        return try await gateway.fetchAllFoods()
    }
    
    func removeFood() async throws {
        try await gateway.deleteFood()
    }
}
