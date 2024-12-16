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
    @State var email: String = ""
    @State var address: String = ""
    @FocusState var focus: Filde?
    @State var emailWidth: CGFloat = 0
    @State var emailAnim: CGFloat = 0
    @State var addressWidth: CGFloat = 0
    @State var addressAnim: CGFloat = 0
    var body: some View {
        VStack {
            TextField("", text: $email)
                .padding()
                .textFStyle(width: emailWidth, text: "Email", anim: emailAnim)
                .focused($focus, equals: .hoge)
            TextField("", text: $address)
                .padding()
                .textFStyle(width: addressWidth, text: "MailAddress", anim: addressAnim)
                .focused($focus, equals: .huga)
        }
        .onChange(of: focus) { oldValue, newValue in
            if email.isEmpty {
                withAnimation(.spring()) {
                    if newValue == .hoge {
                        emailAnim = -30
                        emailWidth = 60
                    } else {
                        emailAnim = 0
                        emailWidth = 0
                    }
                }
            }
            
            if address.isEmpty {
                withAnimation(.spring()) {
                    if newValue == .huga {
                        addressAnim = -30
                        addressWidth = 120
                    } else {
                        addressAnim = 0
                        addressWidth = 0
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
                        Text(text).bold()
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
