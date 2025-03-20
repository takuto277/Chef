//
//  SegmentFood.swift
//  Chef
//
//  Created by 小野拓人 on 2025/03/16.
//

import Foundation
import UIKit

struct SegmentedFood: Identifiable {
    let id: UUID
    var name: String
    var quantity: String
    var image: UIImage?
    
    init(id: UUID, name: String, quantity: String, image: UIImage?) {
        self.id = id
        self.name = name
        self.quantity = quantity
        self.image = image
    }
}
