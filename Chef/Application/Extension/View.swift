//
//  View.swift
//  Chef
//
//  Created by 小野拓人 on 2024/12/07.
//

import SwiftUI

extension View {
    func reflection(opacity:Double = 0.4 ,spacing:CGFloat = 0) -> some View {
        self.modifier(ReflectionModifier(opacity: opacity, spacing: spacing))
    }
}

struct ReflectionModifier:ViewModifier {
    var opacity:Double
    var spacing:CGFloat
    func body (content: Content) -> some View {
        VStack(spacing:0) {
            content
            content
                .scaleEffect(-1)
                .mask(
                    LinearGradient(gradient: Gradient(colors: [.black, .black.opacity(0)]), startPoint:
                            . top, endPoint: .bottom)
                )
                .mask(
                    LinearGradient(gradient: Gradient(colors: [.black,.black.opacity(0)]), startPoint:
                            . top, endPoint: .bottom)
                )
                .opacity(opacity)
        }
    }
}
