//
//  RefrigeratorView.swift
//  Chef
//
//  Created by 小野拓人 on 2024/11/21.
//

import SwiftUI
import Combine

struct FoodItem: Identifiable {
    let id = UUID()
    let name: String
    let count: Int
    let imageName: String
    let category: String
    let description: String
}

struct RefrigeratorView: View {
    private var viewModel: RefrigeratorViewModel
    
    let buttonType = PassthroughSubject<RefrigeratorButtonType, Never>()
    
    @ObservedObject private var output: RefrigeratorViewModel.Output
    
    init() {
        let useCase: RefrigeratorUseCase = RefrigeratorUseCaseImpl()
        viewModel = RefrigeratorViewModel(
            useCase: useCase
        )
        let input = RefrigeratorViewModel.Input(
            buttonType: buttonType.eraseToAnyPublisher()
        )
        output = viewModel.subscribe(input: input)
    }
    
    // test用
    @State private var arrayFoods: [FoodItem] = [
        FoodItem(name: "玉ねぎ", count: 2, imageName: "onion", category: "野菜", description: "新鮮な玉ねぎです。"),
        FoodItem(name: "玉ねぎ", count: 2, imageName: "onion", category: "野菜", description: "新鮮な玉ねぎです。"),
        FoodItem(name: "玉ねぎ", count: 2, imageName: "onion", category: "野菜", description: "新鮮な玉ねぎです。"),
        FoodItem(name: "玉ねぎ", count: 2, imageName: "onion", category: "野菜", description: "新鮮な玉ねぎです。"),
        FoodItem(name: "玉ねぎ", count: 2, imageName: "onion", category: "野菜", description: "新鮮な玉ねぎです。"),
        FoodItem(name: "玉ねぎ", count: 2, imageName: "onion", category: "野菜", description: "新鮮な玉ねぎです。"),
        FoodItem(name: "玉ねぎ", count: 2, imageName: "onion", category: "野菜", description: "新鮮な玉ねぎです。"),
        FoodItem(name: "玉ねぎ", count: 2, imageName: "onion", category: "野菜", description: "新鮮な玉ねぎです。"),
        FoodItem(name: "玉ねぎ", count: 2, imageName: "onion", category: "野菜", description: "新鮮な玉ねぎです。"),
        FoodItem(name: "玉ねぎ", count: 2, imageName: "onion", category: "野菜", description: "新鮮な玉ねぎです。"),
        FoodItem(name: "玉ねぎ", count: 2, imageName: "onion", category: "野菜", description: "新鮮な玉ねぎです。"),
        FoodItem(name: "玉ねぎ", count: 2, imageName: "onion", category: "野菜", description: "新鮮な玉ねぎです。"),
        FoodItem(name: "ねぎ", count: 1, imageName: "green_onion", category: "野菜", description: "香り高いねぎ。"),
        FoodItem(name: "レモン", count: 5, imageName: "lemon", category: "果物", description: "ビタミン豊富なレモン。"),
        FoodItem(name: "白菜", count: 3, imageName: "cabbage", category: "野菜", description: "瑞々しい白菜。")
    ]

    @State private var selectedCategory: String = "野菜"
    @State private var isCategoryDropdownVisible: Bool = false
    
    @State private var navigationBarHeight: CGFloat = 0
    
    // カテゴリの一覧
    private let categories = ["野菜", "果物", "肉", "魚", "乳製品", "穀物ああああああああああああああ"]
    
    var body: some View {
        NavigationStack(path: $output.navigationPath) {
            ZStack(alignment: .topLeading) {
                VStack {
                    navigationBarView
                    foodListView
                }
                
                if isCategoryDropdownVisible {
                    Color.black.opacity(0.001)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation {
                                isCategoryDropdownVisible = false
                            }
                        }
                    categoryDropdownView
                        .offset(x: 0, y: navigationBarHeight)
                        .transition(.opacity.combined(with: .opacity))
                }
            }
            .navigationBarHidden(true)
            .navigationDestination(for: RefrigeratorNavigationType.self) { type in
                switch type {
                case .foodDetail:
                    FoodDetailView(initialFoodDetail: nil)
                }
            }
        }
        .navigationViewStyle(.stack)
    }
    
    
    
    private var navigationBarView: some View {
        GeometryReader { geometry in
            HStack {
                Button(action: {
                    isCategoryDropdownVisible.toggle()
                }) {
                    HStack(spacing: 8) {
                        Text(selectedCategory)
                            .foregroundColor(.black)
                            .font(.system(size: 15))
                        Image(systemName: isCategoryDropdownVisible ? "chevron.up" : "chevron.down")
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(.thinYellow)
                    .cornerRadius(20)
                    .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 2)
                }
                
                Spacer()
                
                HStack(spacing: 20) {
                    Button(action: {
                        buttonType.send(.search)
                    }) {
                        Image(systemName: "magnifyingglass")
                            .font(.title)
                            .foregroundColor(.mainYellow)
                    }
                    
                    Button(action: {
                        buttonType.send(.plus)
                    }) {
                        Image(systemName: "plus")
                            .font(.title)
                            .foregroundColor(.mainYellow)
                    }
                    
                    Button(action: {
                        buttonType.send(.menu)
                    }) {
                        Image(systemName: "line.horizontal.3")
                            .font(.title)
                            .foregroundColor(.mainYellow)
                    }
                }
            }
            .padding()
            .background(.subYellow)
            .onAppear {
                // GeometryReaderを使用して高さを取得
                navigationBarHeight = geometry.size.height
            }
            .background(.green)
        }
        .frame(height: 60)
    }
    
    private var foodListView: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 110))], spacing: 10) {
                ForEach(output.foods.filter { $0.category == selectedCategory }) { food in
                    NavigationLink(destination: FoodDetailView(initialFoodDetail: food)) {
                        FoodCellView(food: food)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding()
        }
    }
    
    private var categoryDropdownView: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // 吹き出しの矢印部分
                Triangle()
                    .fill(Color.mainYellow)
                    .frame(width: 30, height: 30)
                    .padding(.leading, 8)
                    .shadow(color: Color.gray.opacity(0.7), radius: 5, x: 0, y: 2)
                    .offset(x: -UIScreen.main.bounds.width / 2 + 60, y: 0)
                
                // カテゴリリスト部分
                VStack(alignment: .center, spacing: 0) {
                    ForEach(categories, id: \.self) { category in
                        Button(action: {
                            selectedCategory = category
                            withAnimation {
                                isCategoryDropdownVisible = false
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
                .frame(width: geometry.size.width * 0.95)
                .background(.subYellow)
                .cornerRadius(10)
                .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 2)
                .padding(.horizontal, geometry.size.width * 0.025)
            }
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
