//
//  RefrigeratorModel.swift
//  Chef
//
//  Created by 小野拓人 on 2025/02/09.
//

import SwiftUI

enum RefrigeratorButtonType {
    case camera
    case search
    case plus
    case menu
}

enum RefrigeratorNavigationType {
    case foodDetail
}

enum RefrigeratorAlertType {
    case camera
    
    var title: String {
        switch self {
        case .camera:
            "画像から食材を保存します"
        }
    }
}
