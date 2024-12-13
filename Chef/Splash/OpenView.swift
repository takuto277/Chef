//
//  OpenView.swift
//  Chef
//
//  Created by 小野拓人 on 2024/12/07.
//

import SwiftUI

struct OpenView: View {
    @State var start = false
    @State private var isAnimating = false
    @State private var isButtonVisible = true
    @State private var isActive = false
    var body: some View {
        if isActive {
            TabBarView()
        } else {
            VStack{
                Button(action: {
                }) {
                    Image("refrigerator").resizable().scaledToFill()
                        .reflection()
                        .scaleEffect(start ? 1.03 : 1)
                        .scaleEffect(isAnimating ? 4 : 0.5)
                        .offset(y: isAnimating ? 1100 : 200)
                        .onTapGesture {
                            isButtonVisible = false
                            withAnimation(.easeIn(duration: 1)) {
                                isAnimating = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                withAnimation {
                                    self.isActive = true
                                }
                            }
                        }
                }
                
                if isButtonVisible {
                    Text("冷蔵庫を押して開こう")
                        .padding(20)
                        .border(.normalBackground, width: 14)
                        .foregroundColor(.normalText)
                        .background(.normalBackground)
                        .cornerRadius(30)
                        .offset(y: -50)
                        .scaleEffect(start ? 1.1 : 1)
                }
            }
            .onAppear (){
                withAnimation(.spring(duration:1).repeatForever(autoreverses: true)) {
                    start.toggle()
                }
            }
        }
    }
}

#Preview {
    OpenView()
}
