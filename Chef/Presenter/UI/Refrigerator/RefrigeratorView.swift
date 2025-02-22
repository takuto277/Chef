//
//  RefrigeratorView.swift
//  Chef
//
//  Created by 小野拓人 on 2024/11/21.
//

import SwiftUI
import Combine

struct RefrigeratorView: View {
    private var viewModel: RefrigeratorViewModel
    
    let buttonType = PassthroughSubject<RefrigeratorButtonType, Never>()
    let showCamera = PassthroughSubject<Void, Never>()
    let showImagePicker = PassthroughSubject<Void, Never>()
    let selectedImage = PassthroughSubject<UIImage, Never>()
    
    @ObservedObject private var output: RefrigeratorViewModel.Output
    @State private var selectedUIImage: UIImage?
    
    init() {
        let useCase: RefrigeratorUseCase = RefrigeratorUseCaseImpl()
        viewModel = RefrigeratorViewModel(
            useCase: useCase
        )
        let input = RefrigeratorViewModel.Input(
            buttonType: buttonType.eraseToAnyPublisher(),
            showCamera: showCamera.eraseToAnyPublisher(),
            showImagePicker: showImagePicker.eraseToAnyPublisher(),
            selectedImage: selectedImage.eraseToAnyPublisher()
            
        )
        output = viewModel.subscribe(input: input)
    }

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
            .sheet(isPresented: $output.showImagePicker) {
                ImagePicker(image: $selectedUIImage)
            }
            .alert(output.alertType.title, isPresented: $output.showAlert) {
                switch output.alertType {
                case .camera:
                    Button("カメラで撮影") {
                        showCamera.send()
                    }
                    Button("フォトライブラリから選択") {
                        showImagePicker.send()
                    }
                    Button("キャンセル", role: .cancel) {}
                }
            }
            .onChange(of: selectedUIImage) { _, newImage in
                if let uiImage = newImage {
                    selectedImage.send(uiImage)
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
                        buttonType.send(.camera)
                    }) {
                        Image(systemName: "camera")
                            .font(.title)
                            .foregroundColor(.mainYellow)
                    }
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
