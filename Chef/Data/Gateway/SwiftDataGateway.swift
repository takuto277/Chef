//
//  SwiftDataGateway.swift
//  Chef
//
//  Created by 小野拓人 on 2024/11/21.
//

import SwiftData
import Foundation

@ModelActor
internal actor SwiftDataGatewayImpl {
    func create(model: any DBModel) async throws {
        modelContext.insert(model)
        do {
            try modelContext.save()
        } catch {
            print("データの作成に失敗しました: \(error)")
            throw error
        }
    }

    // 全モデルの取得
    func fetchAll<T: DBModel>(ofType type: T.Type) async throws -> [T] {
        do {
            let descriptor = FetchDescriptor<T>()
            return try modelContext.fetch(descriptor)
        } catch {
            print("データの取得に失敗しました: \(error)")
            throw error
        }
    }

    // 全モデルの削除
    func deleteAll<T: DBModel>(ofType type: T.Type) async throws {
        let models = try await fetchAll(ofType: type)
        for model in models {
            modelContext.delete(model)
        }
        do {
            try modelContext.save()
        } catch {
            print("データの削除に失敗しました: \(error)")
            throw error
        }
    }

    // データの更新
    func update() async throws {
        do {
            try modelContext.save()
        } catch {
            print("データの更新に失敗しました: \(error)")
            throw error
        }
    }
}
