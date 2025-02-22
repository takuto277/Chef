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
        let showCamera: AnyPublisher<Void, Never>
        let showImagePicker: AnyPublisher<Void, Never>
        let selectedImage: AnyPublisher<UIImage, Never>
    }
    
    class Output: ObservableObject {
        @Published var foodName: String = ""
        @Published var foodCalories: String = ""
        @Published var navigationPath = NavigationPath()
        @Published var foods: [Food] = []
        @Published var showAlert: Bool = false
        @Published var alertType: RefrigeratorAlertType = .camera
        @Published var showCamera: Bool = false
        @Published var showImagePicker: Bool = false
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
                    case .camera:
                        self.output.alertType = .camera
                        self.output.showAlert = true
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
        input.showCamera
            .sink { [weak self] in
                guard let self else { return }
                self.output.showCamera = true
            }
            .store(in: &cancellables)
        input.showImagePicker
            .sink { [weak self] in
                guard let self else { return }
                self.output.showImagePicker = true
            }
            .store(in: &cancellables)
        input.selectedImage
            .sink { [weak self] image in
                guard let self else { return }
                // TODO: 画像取得後にAPI叩く処理
            }
            .store(in: &cancellables)
        return output
    }
}
