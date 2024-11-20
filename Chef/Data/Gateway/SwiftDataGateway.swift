//
//  SwiftDataGateway.swift
//  Chef
//
//  Created by 小野拓人 on 2024/11/21.
//

import SwiftData

internal protocol SwiftDataGateway: Actor {
    associatedtype ModelType: PersistentModel
    func create(data: ModelType) throws
    func fetchAllFoods() throws -> [ModelType]
    func deleteFood() throws
}

internal actor SwiftDataGatewayImpl<T: PersistentModel>: SwiftDataGateway {
    typealias ModelType = T
    private var container: ModelContainer?
    
    init() {
        self.container = try? ModelContainer(for: T.self)
    }

    func create(data: T) throws {
        guard let container = self.container else { return }
        let context = ModelContext(container)
        
        context.insert(data)
        try context.save()
    }

    func fetchAllFoods() throws -> [T] {
        guard let container = self.container else { return []}
        let context = ModelContext(container)
        
        do {
            let descriptor = FetchDescriptor<T>()
            return try context.fetch(descriptor)
        } catch {
            print("データの取得に失敗しました: \(error)")
            return []
        }
    }

    func deleteFood() throws {
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
