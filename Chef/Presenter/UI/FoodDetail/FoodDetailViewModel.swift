//
//  FoodDetailViewModel.swift
//  Chef
//
//  Created by 小野拓人 on 2024/12/18.
//

import SwiftUI
import Combine

extension FoodDetailViewModel {
    struct Input {
        let focusTextField: AnyPublisher<(FieldType?), Never>
        let updateField: AnyPublisher<(FieldType?, String), Never>
    }

    class FieldState: ObservableObject, Identifiable {
        let id = UUID()
        let type: FieldType
        @Published var name: String

        init(type: FieldType, name: String = "") {
            self.type = type
            self.name = name
        }
    }

    internal class Output: ObservableObject {
        @Published var fieldSessionTypes: [FieldSessionType] = []
        @Published var fields: [FieldState] = []
        @Published var fieldType: FieldType = .none
        @Published var keyboardVisible = false
    }
}

internal final class FoodDetailViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    private var output = Output()
    private let keyboardMonitor: KeyboardMonitor
    
    init() {
        keyboardMonitor = KeyboardMonitor.shared
        
        keyboardMonitor.$isKeyboardVisible
            .receive(on: RunLoop.main)
            .assign(to: \.keyboardVisible, on: output)
            .store(in: &cancellables)
    }
    
    internal func setup(initialFoodDetail: Food?) {
        if let food = initialFoodDetail {
            output.fieldSessionTypes = FieldSessionType.allInitialCases(imageUrl: food.imageUrl, quantity: food.quantity)
            output.fields = [
                FieldState(type: .name, name: food.name),
                FieldState(type: .category, name: food.category),
                FieldState(type: .expiration, name: food.expirationDate),
                FieldState(type: .memo, name: food.memo)
            ]
        } else {
            output.fieldSessionTypes = FieldSessionType.allInitialCases(imageUrl: nil)
            output.fields = FieldType.allCases
                        .filter { !$0.isNone }
                        .map { FieldState(type: $0) }
        }
    }
    
    internal func subscribe(input: Input) -> Output {
        input.updateField
            .sink { [weak self] type, text in
                guard let self, let type = type else { return }
                self.updateField(type, with: text)
            }
            .store(in: &cancellables)
        input.focusTextField
            .sink { [weak self] newType in
                guard let self, let newType = newType else { return }
                self.output.fieldType = newType
            }
            .store(in: &cancellables)
        return output
    }
    
    func updateField(_ field: FieldType, with text: String) {
        if let index = output.fields.firstIndex(where: { $0.type == field }) {
            output.fields[index].name = text
        }
    }
}

private extension FieldType {
    var isNone: Bool {
        switch self {
        case .none:
            return true
        case .name, .category, .expiration, .memo:
            return false
        }
    }
}
