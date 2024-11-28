//
//  HomeViewModel.swift
//  Chef
//
//  Created by 小野拓人 on 2024/11/21.
//

import Foundation
import Combine

extension HomeViewModel {
    struct Input {
        let addFoodSubject: AnyPublisher<Void, Never>
    }
    
    class Output: ObservableObject {
        @Published var foodName: String = ""
        @Published var foodCalories: String = ""
    }
}

internal class HomeViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    private let useCase: HomeUseCase
    var output = Output()
    
    
    init(useCase: HomeUseCase) {
        self.useCase = useCase
    }
    
    internal func subscribe(input: Input) -> Output {
        input.addFoodSubject
            .sink { [weak self] in
                guard let self else { return }
                Task {
                    
                }
            }
            .store(in: &cancellables)
        return output
    }
}
