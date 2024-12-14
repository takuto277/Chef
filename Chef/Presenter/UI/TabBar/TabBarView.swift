//
//  TabBarView.swift
//  Chef
//
//  Created by 小野拓人 on 2024/12/14.
//

import SwiftUI

struct TabBarView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            RefrigeratorView()
                .tabItem {
                    Label("レシピ集", image: selectedTab == 0 ? "image_recipe_focus" : "image_recipe")
                }
                .tag(0)
            
            RefrigeratorView()
                .tabItem {
                    Label("冷蔵庫の中", image: selectedTab == 1 ? "image_refrigerator_focus" : "image_refrigerator")
                }
                .tag(1)
            
            RefrigeratorView()
                .tabItem {
                    Label("買い物リスト", image: selectedTab == 2 ? "image_shoping_list_focus" : "image_shoping_list")
                }
                .tag(2)
            
            RefrigeratorView()
                .tabItem {
                    Label("設定", image: selectedTab == 3 ? "image_setting_focus" : "image_setting")
                }
                .tag(3)
        }
        .accentColor(.tabBarFocus)
    }
}
