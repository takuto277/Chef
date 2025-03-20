//
//  AnalyzedFoodsConfirmationView.swift
//  Chef
//
//  Created by 小野拓人 on 2025/03/20.
//

import SwiftUI
import Combine

// TODO: GenimiAPIとPixabayの分析後に一覧を表示しているから登録できるようにする
// やるべきこと
// - 登録処理
// - 画像の置き換え
// - 元画像の設定
// - 元画像のトリミング
// - 個数の変更/名前の変更
// - 写真が気に食わなかったら、それだけ取り直しする
// - 同じ名前のものが既に登録されていたら、それのDBを引っ張ってきてそれに個数を追加させるようにする
struct AnalyzedFoodsConfirmationView: View {
    @StateObject private var viewModel: AnalyzedFoodsConfirmationViewModel
    @ObservedObject private var output: AnalyzedFoodsConfirmationViewModel.Output

    let tappedAddButton = PassthroughSubject<Void, Never>()
    let tappedImage = PassthroughSubject<SegmentedFood, Never>()
    let addNewFood = PassthroughSubject<SegmentedFood, Never>()
    let updateFoodQuantity = PassthroughSubject<(UUID, Int), Never>()
    
    init(segmentedFoods: [SegmentedFood]) {
        let viewModel = AnalyzedFoodsConfirmationViewModel()
        viewModel.setup(segmentedFoods: segmentedFoods)
        _viewModel = StateObject(wrappedValue: viewModel)
        let input = AnalyzedFoodsConfirmationViewModel.Input(
            tappedAddButton: tappedAddButton.eraseToAnyPublisher(),
            addNewFood: addNewFood.eraseToAnyPublisher(),
            updateFoodQuantity: updateFoodQuantity.eraseToAnyPublisher(),
            tappedImage: tappedImage.eraseToAnyPublisher()
        )
        output = viewModel.subscribe(input: input)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("認識された食材")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text("\(output.segmentedFoods.count)種類")
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)
            .padding(.top)
            
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 160), spacing: 16)], spacing: 20) {
                    ForEach(output.segmentedFoods) { food in
                        FoodItemCard(food: food) { newQuantity in
                            updateFoodQuantity.send((food.id, newQuantity))
                        } tappedImage: {
                            // 画像箇所が押されました
                        }
                    }
                }
                .padding()
            }
            
            // フッターボタン
            HStack(spacing: 16) {
                Button(action: {
                    tappedAddButton.send()
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("食材を追加")
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color(.systemGray6))
                    .foregroundColor(.primary)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                }
                
                Button(action: {
                    // 決定ボタンの処理
                    // 例: 選択された食材を保存する、次の画面に進むなど
                }) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                        Text("決定")
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .shadow(color: Color.blue.opacity(0.3), radius: 5, x: 0, y: 2)
                }
            }
            .padding()
            .background(
                Rectangle()
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.05), radius: 10, y: -5)
            )
        }
        .background(Color(.systemGray6).edgesIgnoringSafeArea(.all))
        .sheet(isPresented: $output.showAddSeet) {
            AddAnalyzeFoodView { newFood in
                if let food = newFood {
                    addNewFood.send(food)
                }
            }
        }
    }
}
