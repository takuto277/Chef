//
//  FoodModel.swift
//  Chef
//
//  Created by 小野拓人 on 2024/11/21.
//

import SwiftData
import Foundation

@Model
final class Food {
    @Attribute(.unique) var id: UUID
    var name: String
    var calories: Int
    
    init(id: UUID = UUID(), name: String, calories: Int) {
        self.id = id
        self.name = name
        self.calories = calories
    }
}
