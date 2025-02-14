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
        let buttonType: AnyPublisher<RefrigeratorButtonType, Never>
    }
    
    class Output: ObservableObject {
        @Published var foodName: String = ""
        @Published var foodCalories: String = ""
        @Published var navigationPath = NavigationPath()
        @Published var foods: [Food] = []
    }
}

@MainActor
internal class RefrigeratorViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    private let useCase: RefrigeratorUseCase
    var output = Output()
    
    
    init(
        useCase: RefrigeratorUseCase
    ) {
        self.useCase = useCase
        Task {
            await fetchAllFoods()
        }
    }
    
    private func fetchAllFoods() async {
        do {
            output.foods = try await useCase.fetchAll()
        } catch {
            // TODO: アラートの表示
            print("食べ物の取得に失敗しました: \(error)")
        }
    }
    
    internal func subscribe(input: Input) -> Output {
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
