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
    let focusTextField = PassthroughSubject<(FieldType?, FieldType?), Never>()
    let updateField = PassthroughSubject<(FieldType, String), Never>()
    
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
        VStack {
            ForEach(output.fields, id: \.type) { field in
                TextField("", text: Binding(
                    get: { field.name },
                    set: { newValue in
                        updateField.send((field.type, newValue))
                    }
                ))
                .padding()
                .textFStyle(width: field.width, text: field.type.title, anim: field.animation)
                .focused($focus, equals: field.type)
            }
        }
        .onChange(of: focus) { oldValue, newValue in
            focusTextField.send((oldValue, newValue))
        }
    }
}

struct TextFStyle: ViewModifier {
    var width: CGFloat
    var text: String
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
                        Text(text).bold()
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
    func textFStyle(width: CGFloat, text: String, anim: CGFloat) -> some View {
        modifier(TextFStyle(width: width, text: text, anim: anim))
    }
}
