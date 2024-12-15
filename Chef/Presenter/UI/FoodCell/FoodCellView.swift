//
//  FoodCellView.swift
//  Chef
//
//  Created by 小野拓人 on 2024/12/16.
//

import SwiftUI

struct FoodCellView: View {
    let food: FoodItem

    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            VStack(alignment: .center) {
                Text("購入から")
                Text("\("24")日目")
            }
            .padding(2)
            .font(.system(size: 10))
            .frame(maxWidth: .infinity)
            .background(.thinYellow)
            .cornerRadius(30)
            
            ZStack(alignment: .bottomTrailing) {
                Image("splashImage")
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .shadow(radius: 5)
                
                HStack(alignment: .bottom) {
                    Text("2")
                        .font(.system(size: 15))
                    Text("個")
                        .font(.system(size: 10))
                }
                .padding(5)
                .background(.mainYellow)
                .foregroundColor(. black)
                .cornerRadius(10)
            }
            
            // 食材の名前
            Text(food.name)
                .padding(6)
                .frame(maxWidth: .infinity)
                .font(.system(size: 15))
                .background(.thinYellow)
                .foregroundColor(. black)
                .cornerRadius(10)
            
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(.subYellow)
                .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 2)
        )
    }
}
