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
        let imageTapped: AnyPublisher<Void, Never>
        let showImagePicker: AnyPublisher<Void, Never>
        let selectedImage: AnyPublisher<UIImage, Never>
        let saveTapped: AnyPublisher<Void, Never>
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
        @Published var showAlert: Bool = false
        @Published var alertType: AlertType = .save
        @Published var showImagePicker: Bool = false
    }
}

@MainActor
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
        input.imageTapped
            .sink { [weak self] in
                guard let self else { return }
                self.output.showAlert = true
                self.output.alertType = .changeImage
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
                self.saveImage(image)
            }
            .store(in: &cancellables)
        input.saveTapped
            .sink { [weak self] in
                guard let self else { return }
                self.saveTapped()
            }
            .store(in: &cancellables)
        return output
    }
    
    private func saveImage(_ uiImage: UIImage) {
        guard let imageData = uiImage.jpegData(compressionQuality: 0.8) else {
            print("JPEGデータへの変換に失敗しました。")
            return
        }
        let filename = UUID().uuidString + ".jpg"
        let url = getDocumentsDirectory().appendingPathComponent(filename)
        do {
            try imageData.write(to: url)
            let imageUrlString = url.absoluteString
            updateImageUrlInFieldSessionType(newUrl: imageUrlString)
            print("画像が保存されました: \(url)")
        } catch {
            print("画像の保存に失敗しました: \(error)")
        }
    }
    
    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    private func saveTapped() {
        if isFoodDetailEmpty() {
            output.showAlert = true
            output.alertType = .emptyField
        } else {
            output.showAlert = true
            output.alertType = .save
        }
    }
    
    private func isFoodDetailEmpty() -> Bool {
        return output.fields.contains { $0.name.isEmpty }
    }
    
    func updateImageUrlInFieldSessionType(newUrl: String) {
        guard let index = output.fieldSessionTypes.firstIndex(where: { session in
            return session.isNameAndImage
        }) else {
            print("指定されたフィールドタイプに対応する FieldSessionType が見つかりません。")
            return
        }
        let updatedSession = FieldSessionType.nameAndImage(titleField: .name, imageUrl: newUrl)
        output.fieldSessionTypes[index] = updatedSession
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

private extension FieldSessionType {
    var isNameAndImage: Bool {
        switch self {
        case .nameAndImage:
            return true
        case .category, .expiration, .memo, .save:
            return false
        }
    }
}
