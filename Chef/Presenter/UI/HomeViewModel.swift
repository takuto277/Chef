//
//  HomeViewModel.swift
//  Chef
//
//  Created by 小野拓人 on 2024/11/21.
//

import Foundation

final class HomeViewModel: ObservableObject {
    private let useCase: HomeUseCase
    
    init(
        useCase: HomeUseCase = HomeUseCaseImpl()
    ) {
        self.useCase = useCase
    }
}
