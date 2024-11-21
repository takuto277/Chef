//
//  HomeView.swift
//  Chef
//
//  Created by 小野拓人 on 2024/11/21.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel
    
    // 入力フィールドの状態
    @State private var foodName: String = ""
    @State private var foodCalories: String = ""
    
    init(viewModel: HomeViewModel = HomeViewModel.create()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("食品名", text: $foodName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            TextField("カロリー", text: $foodCalories)
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            Button(action: {
                guard let calories = Int(foodCalories) else {
                    print("有効なカロリーを入力してください")
                    return
                }
                // Combineを使用してViewModelにイベントを送信
                viewModel.addFoodSubject.send((foodName, calories))
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
        HomeView()
    }
}
