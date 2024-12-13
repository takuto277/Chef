//
//  TabBarView.swift
//  Chef
//
//  Created by 小野拓人 on 2024/12/14.
//

import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {
            RefrigeratorView()
                .tabItem {
                    Label("ホーム", systemImage: "house")
                }
            
            RefrigeratorView()
                .tabItem {
                    Label("検索", systemImage: "magnifyingglass")
                }
            
            RefrigeratorView()
                .tabItem {
                    Label("プロフィール", systemImage: "person.circle")
                }
            
            RefrigeratorView()
                .tabItem {
                    Label("設定", systemImage: "gearshape")
                }
        }
    }
}
