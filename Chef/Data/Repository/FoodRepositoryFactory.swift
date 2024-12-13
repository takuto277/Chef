//
//  FoodRepositoryFactory.swift
//  Chef
//
//  Created by 小野拓人 on 2024/11/22.
//

import Foundation

internal class FoodRepositoryFactory {
    static func createRepository() -> FoodRepositoryImpl {
        let gateway = SwiftDataGatewayImpl(modelContainer: ModelContainerProvider.shared)
        return FoodRepositoryImpl(gateway: gateway)
    }
}
