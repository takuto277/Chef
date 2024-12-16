//
//  FoodDetailView.swift
//  Chef
//
//  Created by 小野拓人 on 2024/12/15.
//

import SwiftUI

enum Filde {
    case hoge
    case huga
}

struct FoodDetailView: View {
    @State var hoge: String = ""
    @FocusState var focus: Filde?
    @State var width: CGFloat = 0
    @State var anim: CGFloat = 0
    var body: some View {
        VStack {
            TextField("", text: $hoge)
                .padding()
                .textFStyle(width: width, text: "Email", anim: anim)
                .focused($focus, equals: .hoge)
            TextField("", text: $hoge)
                .padding()
                .textFStyle(width: width, text: "Email", anim: anim)
                .focused($focus, equals: .huga)
        }
            .onChange(of: focus) { oldValue, newValue in
                if hoge.isEmpty {
                    withAnimation(.spring()) {
                        if newValue == .hoge {
                            anim = -30
                            width = 60
                        } else {
                            anim = 0
                            width = 0
                        }
                    }
                }
            }
    }
}

struct TextFStyle: ViewModifier {
    var width: CGFloat
    var text: String
    var anim: CGFloat
    func body(content: Content) -> some View {
        content
            .overlay {
                ZStack{
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(lineWidth: 2.5)
                    ZStack (alignment: .leading) {
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .frame(width: width, height: 27)
                            .padding(.leading, 12)
                            .foregroundColor(.gray)
                        Text("Email").bold()
                            .padding(.leading, 20)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .offset(y: anim)
                }
            }
    }
}

struct FoodDetailView_Previews: PreviewProvider {
    static var previews: some View {
        FoodDetailView()
    }
}

extension View {
    func textFStyle(width: CGFloat, text: String, anim: CGFloat) -> some View {
        modifier(TextFStyle(width: width, text: text, anim: anim))
    }
}
