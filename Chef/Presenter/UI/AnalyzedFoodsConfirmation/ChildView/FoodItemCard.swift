//
//  FoodItemCard.swift
//  Chef
//
//  Created by 小野拓人 on 2025/03/20.
//

import SwiftUI

struct FoodItemCard: View {
    let food: SegmentedFood
    let onQuantityChanged: (Int) -> Void
    let tappedImage: () -> Void
    @State private var quantity: Int
    
    init(food: SegmentedFood, onQuantityChanged: @escaping (Int) -> Void, tappedImage: @escaping () -> Void) {
        self.food = food
        self.onQuantityChanged = onQuantityChanged
        self.tappedImage = tappedImage
        self._quantity = State(initialValue: food.quantity.extractNumber())
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // 食材画像
            Image(uiImage: (food.image ?? UIImage(named: "defaultImage"))!)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 120)
                .clipped()
                .cornerRadius(12, corners: [.topLeft, .topRight])
                .onTapGesture {
                    tappedImage()
                }
            
            // 食材名
            Text(food.name)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
                .lineLimit(1)
                .padding(.horizontal, 12)
            
            // 数量調整
            HStack {
                Button(action: {
                    if quantity > 1 {
                        quantity -= 1
                        onQuantityChanged(quantity)
                    }
                }) {
                    Image(systemName: "minus.circle.fill")
                        .foregroundColor(.gray)
                        .font(.system(size: 22))
                }
                
                Text("\(quantity)")
                    .font(.system(size: 18, weight: .medium))
                    .frame(minWidth: 30)
                    .foregroundColor(.primary)
                
                Button(action: {
                    quantity += 1
                    onQuantityChanged(quantity)
                }) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.blue)
                        .font(.system(size: 22))
                }
                
                Spacer()
                
                // 単位（必要に応じて）
                Text("個")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 12)
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}
