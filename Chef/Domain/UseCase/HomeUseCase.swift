//
//  HomeUseCase.swift
//  Chef
//
//  Created by 小野拓人 on 2024/11/21.
//

import Foundation

internal protocol HomeUseCase {
    
}

final class HomeUseCaseImpl: HomeUseCase {
    private let foodRepository: FoodRepository
    
    init(
        foodRepository: FoodRepository = FoodRepositoryFactory.createRepository()
    ) {
        self.foodRepository = foodRepository
    }
}
