//
//  RefrigeratorView.swift
//  Chef
//
//  Created by 小野拓人 on 2024/11/21.
//

import SwiftUI
import Combine

// test用
struct Foods {
    let count: Int = 1
    let name: String
}

struct RefrigeratorView: View {
    private var viewModel: RefrigeratorViewModel
    
    let addFoodSubject = PassthroughSubject<Void, Never>()
    
    @ObservedObject private var output: RefrigeratorViewModel.Output
    
    init() {
        let useCase: RefrigeratorUseCase = RefrigeratorUseCaseImpl()
        viewModel = RefrigeratorViewModel(useCase: useCase)
        let input = RefrigeratorViewModel.Input(addFoodSubject: addFoodSubject.eraseToAnyPublisher())
        output = viewModel.subscribe(input: input)
    }
    
    // test用
    let arrayFoods = [Foods(name: "玉ねぎ"), Foods(name: "ねぎ"), Foods(name: "レモン"), Foods(name: "白菜")]
    
    var body: some View {
        VStack {
            navigationBarView
            foodListView
            
            // 既存の入力フィールドとボタン
            VStack(spacing: 20) {
                TextField("食品名", text: $output.foodName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                TextField("カロリー", text: $output.foodCalories)
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
    
    private var navigationBarView: some View {
        // ナビゲーションバー
        HStack {
            // 左上のカテゴリ絞り込みボタン
            Button(action: {
                // カテゴリ絞り込みのアクション
            }) {
                HStack(spacing: 8) {
                     Text("野菜")
                         .foregroundColor(.black)
                         .font(.headline)
                     Image(systemName: "chevron.down")
                         .foregroundColor(.gray)
                 }
                 .padding(.horizontal, 12)
                 .padding(.vertical, 8)
                 .background(Color.white)
                 .cornerRadius(20)
                 .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 2)
            }
            
            Spacer()
            
            HStack(spacing: 20) {
                Button(action: {
                    // 検索アクション
                }) {
                    Image(systemName: "magnifyingglass")
                        .font(.title)
                }
                
                Button(action: {
                    // 食材を追加するアクション
                }) {
                    Image(systemName: "plus")
                        .font(.title)
                        .foregroundColor(.mainYellow)
                }
                
                Button(action: {
                    // メニューを開くアクション
                }) {
                    Image(systemName: "line.horizontal.3")
                        .font(.title)
                }
            }
        }
        .padding()
        .background(.barBackground)
    }
    
    private var foodListView: some View {
        // 食材一覧コレクションビュー
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 20) {
                ForEach(arrayFoods, id: \.name) { food in
                    VStack {
                        Text(food.name)
                            .font(.headline)
                        Text("\(food.count) 個")
                            .font(.subheadline)
                    }
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(10)
                }
            }
            .padding()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        RefrigeratorView()
    }
}
