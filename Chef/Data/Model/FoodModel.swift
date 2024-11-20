//
//  FoodModel.swift
//  Chef
//
//  Created by 小野拓人 on 2024/11/21.
//

import SwiftData

@Model
class Food: PersistentModel {
    var name: String
    var calories: Int

    init(name: String, calories: Int) {
        self.name = name
        self.calories = calories
    }
}
