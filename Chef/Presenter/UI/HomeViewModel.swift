//
//  HomeViewModel.swift
//  Chef
//
//  Created by 小野拓人 on 2024/11/21.
//

import Foundation
import Combine

internal class HomeViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    private let useCase: HomeUseCase
    
    // CombineのPassthroughSubjectでボタンタップイベントを受け取る
    let addFoodSubject = PassthroughSubject<(String, Int), Never>()
    
    init(useCase: HomeUseCase) {
        self.useCase = useCase
        setupBindings()
    }

    static func create() -> HomeViewModel {
        let useCase = HomeUseCaseImpl()
        return HomeViewModel(useCase: useCase)
    }
    
    private func setupBindings() {
        addFoodSubject
            .sink { [weak self] name, calories in
                Task {
                    do {
                        if let foods = try await self?.useCase.addFoodAndFetchAll(name: name, calories: calories) {
                            for i in foods {
                                print("保存された食品: \(i.name), \(i.calories)カロリー")
                            }
                        }
                    } catch {
                        print("エラーが発生しました: \(error)")
                    }
                }
            }
            .store(in: &cancellables)
    }
}
