//
//  ModelContainerProvider.swift
//  Chef
//
//  Created by 小野拓人 on 2024/11/22.
//

import SwiftData

struct ModelContainerProvider {
    static var shared: ModelContainer = {
        let schema = Schema([
            Food.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
}
