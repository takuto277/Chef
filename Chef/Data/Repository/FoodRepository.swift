//
//  FoodRepository.swift
//  Chef
//
//  Created by 小野拓人 on 2024/11/21.
//

import Foundation

internal protocol FoodRepository: Actor {
    func addFood(food: Food) async throws
    func fetchAllFoods() async throws -> [Food]
    func removeFood() async throws
    func fetchMaxIdCount() async throws -> Int
    func updateFood(oldFood: Food) async throws
}

internal actor FoodRepositoryImpl: FoodRepository {
    private let gateway: SwiftDataGatewayImpl
    
    init(gateway: SwiftDataGatewayImpl) {
        self.gateway = gateway
    }
    
    internal func addFood(food: Food) async throws {
        try await gateway.create(model: food)
    }
    
    internal func fetchAllFoods() async throws -> [Food] {
        return try await gateway.fetchAll(ofType: Food.self)
    }
    
    internal func removeFood() async throws {
        try await gateway.deleteAll(ofType: Food.self)
    }
    
    internal func fetchMaxIdCount() async throws -> Int {
        let foods = try await gateway.fetchAll(ofType: Food.self)
       let maxId = foods.map { $0.id }.max() ?? 0
        return maxId + 1
    }
    
    internal func updateFood(oldFood: Food) async throws {
        // TODO: 更新したいパラメータを引数に持たせ代入させる
        oldFood.updateTime = Date.getCurrentDateString()
        oldFood.purchaseCount += 1
        
        try await gateway.update()
    }
}
