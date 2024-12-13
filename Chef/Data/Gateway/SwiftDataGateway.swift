//
//  SwiftDataGateway.swift
//  Chef
//
//  Created by 小野拓人 on 2024/11/21.
//

import SwiftData
import Foundation

@ModelActor
internal actor SwiftDataGatewayImpl<T: PersistentModel> {
    typealias ModelType = T
    
    func create(data: T) async throws {
        do {
            modelContext.insert(data)
            try modelContext.save()
        } catch {
            print("データの取得に作成しました: \(error)")
        }
    }

    func fetchAllFoods() async throws -> [T] {
        do {
            let descriptor = FetchDescriptor<T>()
            return try modelContext.fetch(descriptor)
        } catch {
            print("データの取得に失敗しました: \(error)")
            return []
        }
    }

    func deleteFood() async throws {
        do {
            try modelContext.delete(model: T.self)
            try modelContext.save()
        } catch {
            print("全データの削除に失敗しました: \(error)")
        }
    }

    func update() async throws {
        do {
            try modelContext.save()
        } catch {
            print("データの更新に失敗しました: \(error)")
            throw error
        }
    }
}
