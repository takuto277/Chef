//
//  FoodRepository.swift
//  Chef
//
//  Created by 小野拓人 on 2024/11/21.
//

import Foundation

internal protocol FoodRepository: Actor {
    func addFood(food: Food) async throws
    func getAllFoods() async throws -> [Food]
    func removeFood() async throws
    func fetchMaxIdCount() async throws -> Int
}

internal actor FoodRepositoryImpl: FoodRepository {
    private let gateway: SwiftDataGatewayImpl<Food>
    
    init(gateway: SwiftDataGatewayImpl<Food>) {
        self.gateway = gateway
    }
    
    internal func addFood(food: Food) async throws {
        try await gateway.create(data: food)
    }
    
    internal func getAllFoods() async throws -> [Food] {
        return try await gateway.fetchAllFoods()
    }
    
    internal func removeFood() async throws {
        try await gateway.deleteFood()
    }
    
    internal func fetchMaxIdCount() async throws -> Int {
       let foods = try await gateway.fetchAllFoods()
       let maxId = foods.map { $0.id }.max() ?? 0
        return maxId + 1
    }
}
