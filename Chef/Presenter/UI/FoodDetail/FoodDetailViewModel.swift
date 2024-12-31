//
//  FoodDetailViewModel.swift
//  Chef
//
//  Created by 小野拓人 on 2024/12/18.
//

import SwiftUI
import Combine

enum FieldType: CaseIterable {
    case email
    case address
    case memo

    var id: FieldType { self }

    var title: String {
        switch self {
        case .email:
            return "Email"
        case .address:
            return "Address"
        case .memo:
            return "Memo"
        }
    }
}

extension FoodDetailViewModel {
    struct Input {
        let focusTextField: AnyPublisher<(FieldType?, FieldType?), Never>
        let updateField: AnyPublisher<(FieldType, String), Never>
    }

    class FieldState: ObservableObject, Identifiable {
        let id = UUID()
        let type: FieldType
        @Published var name: String
        @Published var animation: CGFloat
        @Published var width: CGFloat

        init(type: FieldType, name: String = "", animation: CGFloat = 0, width: CGFloat = 0) {
            self.type = type
            self.name = name
            self.animation = animation
            self.width = width
        }
    }

    internal class Output: ObservableObject {
        @Published var fields: [FieldState] = []
    }
}

internal final class FoodDetailViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    private var output = Output()
    
    init() {
        output.fields = FieldType.allCases.map { FieldState(type: $0) }
    }
    
    internal func subscribe(input: Input) -> Output {
        input.updateField
            .sink { [weak self] type, text in
                guard let self else { return }
                self.updateField(type, with: text)
            }
            .store(in: &cancellables)
        input.focusTextField
            .sink { [weak self] oldType, newType in
                guard let self else { return }
                self.updateFocus(oldType: oldType, newType: newType)
            }
            .store(in: &cancellables)
        return output
    }
    
    func updateField(_ field: FieldType, with text: String) {
        if let index = output.fields.firstIndex(where: { $0.type == field }) {
            output.fields[index].name = text
        }
    }
    
    private func updateFocus(oldType: FieldType?, newType: FieldType?) {
        guard let newFieldType = newType else { return }
        if let index = output.fields.firstIndex(where: { $0.type == newFieldType }) {
            withAnimation(.spring()) {
                switch newFieldType {
                case .email:
                    output.fields[index].animation = -30
                    output.fields[index].width = 60
                case .address:
                    output.fields[index].animation = -30
                    output.fields[index].width = 120
                case .memo:
                    output.fields[index].animation = -30
                    output.fields[index].width = 60
                }
            }
        }
        
        if let oldFieldType = oldType,
           let index = output.fields.firstIndex(where: { $0.type == oldFieldType }) {
            if output.fields[index].name.isEmpty {
                withAnimation(.spring()) {
                    output.fields[index].animation = 0
                    output.fields[index].width = 0
                }
            }
        }
    }
}
