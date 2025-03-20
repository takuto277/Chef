//
//  AddAnalyzeFoodView.swift
//  Chef
//
//  Created by 小野拓人 on 2025/03/20.
//

import SwiftUI

struct AddAnalyzeFoodView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var foodName: String
    @State private var quantity: String
    @State private var foodImage: UIImage?
    @State private var showingImagePicker = false
    
    let onAdd: (SegmentedFood) -> Void
    
    init(
        segmentedFood: SegmentedFood = SegmentedFood(
            id: UUID(),
            name: "",
            quantity: "1",
            image: nil
        ),
        onAdd: @escaping (SegmentedFood?) -> Void
    ) {
        self._foodName = State(initialValue: segmentedFood.name)
        self._quantity = State(initialValue: segmentedFood.quantity)
        self._foodImage = State(initialValue: segmentedFood.image)
        self.onAdd = onAdd
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("食材情報")) {
                    TextField("食材名", text: $foodName)
                    TextField("数量", text: $quantity)
                        .keyboardType(.numberPad)
                }
                
                Section(header: Text("画像 (※画像を選択しない場合は、食材名に関連する画像が表示されます。)")) {
                    Button(action: {
                        showingImagePicker = true
                    }) {
                        HStack {
                            Text("画像を選択")
                            Spacer()
                            Image(uiImage: foodImage ?? UIImage())
                                .resizable()
                                .scaledToFill()
                                .frame(width: 60, height: 60)
                                .cornerRadius(8)
                        }
                    }
                }
            }
            .navigationTitle("食材を追加")
            .navigationBarItems(
                leading: Button("キャンセル") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("追加") {
                    let newFood = SegmentedFood(
                        id: UUID(),
                        name: foodName,
                        quantity: quantity,
                        image: foodImage
                    )
                    onAdd(newFood)
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(foodName.isEmpty)
            )
            .sheet(isPresented: $showingImagePicker) {
                EditableImagePicker(selectedImage: $foodImage)
            }
        }
    }
}
