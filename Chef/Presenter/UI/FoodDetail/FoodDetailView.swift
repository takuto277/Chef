//
//  FoodDetailView.swift
//  Chef
//
//  Created by 小野拓人 on 2024/12/15.
//

import Combine
import SwiftUI

struct FoodDetailView: View {
    @StateObject private var viewModel: FoodDetailViewModel
    @FocusState private var focus: FieldType?
    
    @ObservedObject private var output: FoodDetailViewModel.Output
    let focusTextField = PassthroughSubject<(FieldType?), Never>()
    let updateField = PassthroughSubject<(FieldType?, String), Never>()
    
    init() {
        let viewModel = FoodDetailViewModel()
        _viewModel = StateObject(wrappedValue: viewModel)
        let input = FoodDetailViewModel.Input(
            focusTextField: focusTextField.eraseToAnyPublisher(),
            updateField: updateField.eraseToAnyPublisher()
        )
        output = viewModel.subscribe(input: input)
    }
    
    var body: some View {
        inputContents
    }
    
    private var inputContents: some View {
        ScrollView {
            VStack {
                displayEachSession
            }
            .onChange(of: focus) { _, newValue in
                focusTextField.send(newValue)
            }
            .onReceive(output.$keyboardVisible) { isVisible in
                if !isVisible {
                    focusTextField.send(FieldType.none)
                }
            }
        }
    }
    
    private var displayEachSession: some View {
        ForEach(output.fieldSessionTypes, id: \.self) { session in
            switch session {
            case let .titleImage(titleField: titleFieldType, imageName: imageName):
                HStack {
                    let fieldState: FoodDetailViewModel.FieldState? = output.fields.first { field in
                        field.type == titleFieldType
                    }
                    TextField("", text: Binding(
                        get: { fieldState?.name ?? "想定外" },
                        set: { newValue in
                            updateField.send((fieldState?.type, newValue))
                        }
                    ))
                    .padding()
                    .frame(height: 100)
                    .textFStyle(
                        width: output.fieldType.getWidth(fieldType: fieldState?.type, title: fieldState?.name),
                        text: fieldState?.type.title,
                        anim: output.fieldType.getAnimation(fieldType: fieldState?.type, title: fieldState?.name)
                    )
                    .focused($focus, equals: fieldState?.type)
                    
                    Image(systemName: "photo")
                        .frame(width: 150, height: 150)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.blue, lineWidth: 3)
                        )
                }
                .padding()
            case let .category(categoryFieldType):
                let fieldState: FoodDetailViewModel.FieldState? = output.fields.first { field in
                    field.type == categoryFieldType
                }
                TextField("", text: Binding(
                    get: { fieldState?.name ?? "想定外" },
                    set: { newValue in
                        updateField.send((fieldState?.type, newValue))
                    }
                ))
                .padding()
                .textFStyle(
                    width: output.fieldType.getWidth(fieldType: fieldState?.type, title: fieldState?.name),
                    text: fieldState?.type.title,
                    anim: output.fieldType.getAnimation(fieldType: fieldState?.type, title: fieldState?.name)
                )
                .focused($focus, equals: fieldState?.type)
            case let .expiration(expirationField: expirationFieldType, count: count):
                HStack {
                    let fieldState: FoodDetailViewModel.FieldState? = output.fields.first { field in
                        field.type == expirationFieldType
                    }
                    TextField("", text: Binding(
                        get: { fieldState?.name ?? "想定外" },
                        set: { newValue in
                            updateField.send((fieldState?.type, newValue))
                        }
                    ))
                    .padding()
                    .textFStyle(
                        width: output.fieldType.getWidth(fieldType: fieldState?.type, title: fieldState?.name),
                        text: fieldState?.type.title,
                        anim: output.fieldType.getAnimation(fieldType: fieldState?.type, title: fieldState?.name)
                    )
                    .focused($focus, equals: fieldState?.type)
                    
                    Text("55555")
                }
            case let .memo(memoField: memoFieldType):
                let fieldState: FoodDetailViewModel.FieldState? = output.fields.first { field in
                    field.type == memoFieldType
                }
                TextField("", text: Binding(
                    get: { fieldState?.name ?? "想定外" },
                    set: { newValue in
                        updateField.send((fieldState?.type, newValue))
                    }
                ))
                .padding()
                .textFStyle(
                    width: output.fieldType.getWidth(fieldType: fieldState?.type, title: fieldState?.name),
                    text: fieldState?.type.title,
                    anim: output.fieldType.getAnimation(fieldType: fieldState?.type, title: fieldState?.name)
                )
                .focused($focus, equals: fieldState?.type)
                .frame(height: 500)
            }
        }
    }
}

struct TextFStyle: ViewModifier {
    var width: CGFloat
    var text: String?
    var anim: CGFloat
    func body(content: Content) -> some View {
        content
            .overlay {
                ZStack{
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(lineWidth: 2.5)
                    ZStack (alignment: .leading) {
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .frame(width: width, height: 27)
                            .padding(.leading, 12)
                            .foregroundColor(.gray)
                        Text(text ?? "想定外").bold()
                            .padding(.leading, 20)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .offset(y: anim)
                }
            }
    }
}

struct FoodDetailView_Previews: PreviewProvider {
    static var previews: some View {
        FoodDetailView()
    }
}

extension View {
    func textFStyle(width: CGFloat, text: String?, anim: CGFloat) -> some View {
        modifier(TextFStyle(width: width, text: text, anim: anim))
            .animation(.spring, value: anim)
    }
}
