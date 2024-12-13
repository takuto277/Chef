//
//  FoodModel.swift
//  Chef
//
//  Created by 小野拓人 on 2024/11/21.
//

import SwiftData
import Foundation

@Model
final class Food: DBModel {
    var createTime: String
    var updateTime: String
    @Attribute(.unique) var id: Int
    var name: String
    var imageData: Data?
    var category: String
    var quantity: Int
    var expirationDate: String
    var memo: String
    var purchaseCount: Int
    var deleteFlag: Bool = false
    
    init(
        id: Int,
        name: String,
        category: String,
        quantity: Int,
        expirationDate: String,
        memo: String,
        imageData: Data?,
        createTime: String = "",
        updateTime: String = "",
        purchaseCount: Int
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.quantity = quantity
        self.expirationDate = expirationDate
        self.memo = memo
        self.imageData = imageData
        self.createTime = createTime
        self.updateTime = updateTime
        self.purchaseCount = purchaseCount
    }
}
