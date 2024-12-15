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
    @State private var selectedCategory: String = "野菜"
    @State private var isCategoryDropdownVisible: Bool = false
    
    @State private var navigationBarHeight: CGFloat = 0
    
    // カテゴリの一覧
    private let categories = ["野菜", "果物", "肉", "魚", "乳製品", "穀物ああああああああああああああ"]
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack {
                navigationBarView
                foodListView
                Spacer()
            }
            
            // ドロップダウンメニューのオーバーレイ
            if isCategoryDropdownVisible {
                
                Color.black.opacity(0.001)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation {
                            isCategoryDropdownVisible = false
                        }
                    }
                
                CategoryDropdownView(
                    selectedCategory: $selectedCategory,
                    isVisible: $isCategoryDropdownVisible,
                    categories: categories
                )
                .offset(x: 0, y: navigationBarHeight)
                .transition(.opacity.combined(with: .opacity))
            }
        }
    }
    
    
    
    private var navigationBarView: some View {
        GeometryReader { geometry in
            HStack {
                // 左上のカテゴリ絞り込みボタン
                Button(action: {
                    isCategoryDropdownVisible.toggle()
                }) {
                    HStack(spacing: 8) {
                        Text(selectedCategory)
                            .foregroundColor(.black)
                            .font(.headline)
                        Image(systemName: isCategoryDropdownVisible ? "chevron.up" : "chevron.down")
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
                            .foregroundColor(.mainYellow)
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
                            .foregroundColor(.mainYellow)
                    }
                }
            }
            .padding()
            .background(.barBackground)
            .onAppear {
                // GeometryReaderを使用して高さを取得
                navigationBarHeight = geometry.size.height
            }
            .background(.green)
        }
        .frame(height: 60)
        
        
        
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

struct CategoryDropdownView: View {
    @Binding var selectedCategory: String
    @Binding var isVisible: Bool
    let categories: [String]
    
    var body: some View {
        VStack(spacing: 0) {
            // 吹き出しの矢印部分
            Triangle()
                .fill(Color.mainYellow)
                .frame(width: 30, height: 30)
                .padding(.leading, 8)
                .shadow(color: Color.gray.opacity(0.7), radius: 5, x: 0, y: 2)
                .offset(x: -UIScreen.main.bounds.width / 2 + 40, y: 0)
            
            // カテゴリリスト部分
            VStack(alignment: .leading, spacing: 0) {
                ForEach(categories, id: \.self) { category in
                    Button(action: {
                        selectedCategory = category
                        withAnimation {
                            isVisible = false
                        }
                    }) {
                        Text(category)
                            .foregroundColor(.black)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.white)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    if category != categories.last {
                        Divider()
                            .background(Color.gray.opacity(0.3))
                    }
                }
            }
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 2)
        }
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        
        return path
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        RefrigeratorView()
    }
}
