//
//  SwiftDataGateway.swift
//  Chef
//
//  Created by 小野拓人 on 2024/11/21.
//

import SwiftData

internal actor SwiftDataGatewayImpl<T: PersistentModel> {
    typealias ModelType = T
    
    private var context: ModelContext
    
    init() {
        self.context = ModelContext(ModelContainerProvider.shared)
    }
    func create(data: T) async throws {
        do {
            context.insert(data)
            try context.save()
        } catch {
            print("データの取得に作成しました: \(error)")
        }
    }

    func fetchAllFoods() async throws -> [T] {
        do {
            let descriptor = FetchDescriptor<T>()
            return try context.fetch(descriptor)
        } catch {
            print("データの取得に失敗しました: \(error)")
            return []
        }
    }

    func deleteFood() async throws {
        do {
            try context.delete(model: T.self)
            try context.save()
        } catch {
            print("全データの削除に失敗しました: \(error)")
        }
    }
}
