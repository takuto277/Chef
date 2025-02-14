//
//  FoodDetailModel.swift
//  Chef
//
//  Created by 小野拓人 on 2025/01/18.
//

import SwiftUI

internal enum FieldSessionType: Hashable {
    case nameAndImage(titleField: FieldType, imageUrl: String)
    case category(FieldType)
    case expiration(expirationField: FieldType, quantity: Int)
    case memo(memoField: FieldType)
    case save
    
    static func allInitialCases(imageUrl: String?, quantity: Int = 0) -> [FieldSessionType] {
        return [
            .nameAndImage(titleField: .name, imageUrl: imageUrl ?? ""),
            .category(.category),
            .expiration(expirationField: .expiration, quantity: quantity),
            .memo(memoField: .memo),
            .save
        ]
    }
}

internal enum FieldType: CaseIterable {
    case name
    case category
    case expiration
    case memo
    case none

    var id: FieldType { self }

    var title: String {
        switch self {
        case .name:
            return "食材名"
        case .category:
            return "カテゴリー"
        case .expiration:
            return "購入日"
        case .memo:
            return "メモ"
        case .none:
            assertionFailure("想定外")
            return ""
        }
    }
    
    var animation: CGFloat {
        switch self {
        case .name:
            return -50
        case .category, .expiration, .memo:
            return -30
        case .none:
            assertionFailure("想定外")
            return 0
        }
    }
    
    var width: CGFloat {
        let fieldFont: UIFont = UIFont.systemFont(ofSize: 17, weight: .bold)
        return title.width(usingFont: fieldFont) + 15
    }
    
    func getAnimation(fieldType: FieldType?, title: String?) -> CGFloat {
        guard let fieldType = fieldType, let title = title else { return 0 }
        if fieldType == self {
            return fieldType.animation
        } else if title.isEmpty {
            return 0
        } else {
            return fieldType.animation
        }
    }
    
    func getWidth(fieldType: FieldType?, title: String?) -> CGFloat {
        guard let fieldType = fieldType, let title = title else { return 0 }
        if fieldType == self {
            return fieldType.width
        } else if title.isEmpty {
            return 0
        } else {
            return fieldType.width
        }
    }
}

enum AlertType {
    case changeImage
    case emptyField
    case save
}
