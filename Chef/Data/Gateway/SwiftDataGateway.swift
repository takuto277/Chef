//
//  SwiftDataGateway.swift
//  Chef
//
//  Created by 小野拓人 on 2024/11/21.
//

import SwiftData

internal actor SwiftDataGatewayImpl<T: PersistentModel> {
    private var container: ModelContainer?
    
    init() {
        self.container = try? ModelContainer(for: T.self)
    }

    func create(data: T) async throws {
        guard let container = self.container else { return }
        let context = ModelContext(container)
        
        context.insert(data)
        try context.save()
    }

    func fetchAllFoods() async throws -> [T] {
        guard let container = self.container else { return [] }
        let context = ModelContext(container)
        
        do {
            let descriptor = FetchDescriptor<T>()
            return try context.fetch(descriptor)
        } catch {
            print("データの取得に失敗しました: \(error)")
            return []
        }
    }

    func deleteFood() async throws {
        guard let container = self.container else { return }
        let context = ModelContext(container)
        
        do {
            try context.delete(model: T.self)
            try context.save()
        } catch {
            print("全データの削除に失敗しました: \(error)")
        }
    }
}
