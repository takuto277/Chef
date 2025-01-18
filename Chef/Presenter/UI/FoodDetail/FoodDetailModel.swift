//
//  FoodDetailModel.swift
//  Chef
//
//  Created by 小野拓人 on 2025/01/18.
//

import SwiftUI

internal enum FieldSessionType: Hashable {
    case titleImage(titleField: FieldType, imageName: String)
    case category(FieldType)
    case expiration(expirationField: FieldType, count: Int)
    case memo(memoField: FieldType)
    
    static var allInitialCases: [FieldSessionType] {
        return [
            .titleImage(titleField: .title, imageName: ""),
            .category(.category),
            .expiration(expirationField: .expiration, count: 30),
            .memo(memoField: .memo)
        ]
    }
}

internal enum FieldType: CaseIterable {
    case title
    case category
    case expiration
    case memo
    case none

    var id: FieldType { self }

    var title: String {
        switch self {
        case .title:
            return "タイトル"
        case .category:
            return "カテゴリー"
        case .expiration:
            return "賞味期限"
        case .memo:
            return "メモ"
        case .none:
            assertionFailure("想定外")
            return ""
        }
    }
    
    var animation: CGFloat {
        switch self {
        case .title, .category, .expiration, .memo:
            return -30
        case .none:
            assertionFailure("想定外")
            return 0
        }
    }
    
    var width: CGFloat {
        switch self {
        case .title, .memo:
            return 60
        case .category, .expiration:
            return 120
        case .none:
            assertionFailure("想定外")
            return 0
        }
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
