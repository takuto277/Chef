//
//  RefrigeratorViewModel.swift
//  Chef
//
//  Created by 小野拓人 on 2024/11/21.
//

import Foundation
import Combine
import SwiftUI

extension RefrigeratorViewModel {
    struct Input {
        let addFoodSubject: AnyPublisher<Void, Never>
        let buttonType: AnyPublisher<RefrigeratorButtonType, Never>
    }
    
    class Output: ObservableObject {
        @Published var foodName: String = ""
        @Published var foodCalories: String = ""
        @Published var navigationPath = NavigationPath()
    }
}

internal class RefrigeratorViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    private let useCase: RefrigeratorUseCase
    var output = Output()
    
    
    init(
        useCase: RefrigeratorUseCase
    ) {
        self.useCase = useCase
    }
    
    internal func subscribe(input: Input) -> Output {
        input.addFoodSubject
            .sink { [weak self] in
                guard let self else { return }
                Task {
                    // テスト確認用 ゴミだからいつ消してもらっても構わない
                    try? await self.useCase.create(name: "これは更新前", imageUrl: nil, category: "", quantity: 1, expirationDate: "", memo: "")
                    let hoge = try? await self.useCase.fetchAll()
                    hoge?.forEach { i in
                        Task {
                            print("\(i.name):\(i.id)")
                            i.name = "これは更新後"
                            try? await self.useCase.update(oldFood: i)
                        }
                    }
                    let fuga = try? await self.useCase.fetchAll()
                    fuga?.forEach { i in
                        Task {
                    //        i.name = "これは更新後"
                     //       try? await self.useCase.update(oldFood: i)
                            print("\(i.name):\(i.id)")
                        }
                    }
                }
            }
            .store(in: &cancellables)
        input.buttonType
            .sink { [weak self] type in
                guard let self else { return }
                Task {
                    switch type {
                    case .search:
                        break
                    case .plus:
                        self.output.navigationPath.append(RefrigeratorNavigationType.foodDetail)
                    case .menu:
                        break
                    }
                }
            }
            .store(in: &cancellables)
        return output
    }
}
