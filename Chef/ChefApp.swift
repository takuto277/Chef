//
//  ChefApp.swift
//  Chef
//
//  Created by 小野拓人 on 2024/11/20.
//

import SwiftUI
import SwiftData

@main
struct ChefApp: App {
    var body: some Scene {
        WindowGroup {
            SplashView()
        }
        .modelContainer(ModelContainerProvider.shared)
    }
}
