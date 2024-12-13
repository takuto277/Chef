//
//  RefrigeratorView.swift
//  Chef
//
//  Created by 小野拓人 on 2024/11/21.
//

import SwiftUI
import Combine

struct RefrigeratorView: View {
    @StateObject private var viewModel: RefrigeratorViewModel
    
    let addFoodSubject = PassthroughSubject<Void, Never>()
    
    @ObservedObject private var output: RefrigeratorViewModel.Output
    
    init() {
        let useCase: HomeUseCase = HomeUseCaseImpl()
        let viewModel: RefrigeratorViewModel = RefrigeratorViewModel(useCase: useCase)
        _viewModel = StateObject(wrappedValue: viewModel)
        let input = RefrigeratorViewModel.Input(addFoodSubject: addFoodSubject.eraseToAnyPublisher())
        output = viewModel.subscribe(input: input)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("食品名", text: $output.foodName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            TextField("カロリー", text: ($output.foodCalories))
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            Button(action: {
                guard let _ = Int(output.foodCalories) else {
                    print("有効なカロリーを入力してください")
                    return
                }
                // Combineを使用してViewModelにイベントを送信
                addFoodSubject.send()
            }) {
                Text("食品を追加")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding(.top, 50)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        RefrigeratorView()
    }
}
