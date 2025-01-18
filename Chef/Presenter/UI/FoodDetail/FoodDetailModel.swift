//
//  FoodDetailModel.swift
//  Chef
//
//  Created by 小野拓人 on 2025/01/18.
//

import SwiftUI

internal enum FieldType: CaseIterable {
    case email
    case address
    case memo
    case none

    var id: FieldType { self }

    var title: String {
        switch self {
        case .email:
            return "Email"
        case .address:
            return "Address"
        case .memo:
            return "Memo"
        case .none:
            assertionFailure("想定外")
            return ""
        }
    }
    
    var animation: CGFloat {
        switch self {
        case .email, .address, .memo:
            return -30
        case .none:
            assertionFailure("想定外")
            return 0
        }
    }
    
    var width: CGFloat {
        switch self {
        case .email, .memo:
            return 60
        case .address:
            return 120
        case .none:
            assertionFailure("想定外")
            return 0
        }
    }
    
    func getAnimation(fieldType: FieldType, title: String) -> CGFloat {
        if fieldType == self {
            return fieldType.animation
        } else if title.isEmpty {
            return 0
        } else {
            return fieldType.animation
        }
    }
    
    func getWidth(fieldType: FieldType, title: String) -> CGFloat {
        if fieldType == self {
            return fieldType.width
        } else if title.isEmpty {
            return 0
        } else {
            return fieldType.width
        }
    }
}
