//
//  LoginView.swift
//  AcrosticPoemAdmin
//
//  Created by Poto on 2020/12/02.
//

import SwiftUI

struct LoginView: View {
    
    @State private var id = ""
    @State private var password = ""
    @State private var formOffset: CGFloat = 0

    
    
    var body: some View {
        VStack(spacing: 30) {
            VStack{
                LCTextField(value: self.$id, placeholder: "아이디", icon: Image("at`"), isSecure: false, onEditingChanged: {
                    flag in
                    withAnimation {
                        self.formOffset = flag ? -150 : 0
                    }
                })
                LCTextField(value: self.$password, placeholder: "비밀번호", icon: Image("lock"), isSecure: true)
                Button(action: {  }, label: {
                    Text("로그인")
                })
            }
        }
    }
}


struct LCTextField: View {
    
    @Binding var value: String
        var placeholder = "Placeholder"
        var icon = Image("person.crop.circle")
        var color = Color("offColor")
        var isSecure = false
        var onEditingChanged: ((Bool)->()) = {_ in }
    
    var body: some View {
        HStack{
            if isSecure {
                SecureField(placeholder, text: self.$value, onCommit: {
                    self.onEditingChanged(false)
                }).padding()
            } else {
                TextField(placeholder, text: self.$value, onEditingChanged: {
                    flag in
                    self.onEditingChanged(flag)
                }).padding()
            }
            icon.padding()
                .foregroundColor(color)
        }.background(color.opacity(0.2)).clipShape(Capsule())
    }
}

struct LCTextField_Previews: PreviewProvider {
    static var previews: some View {
        LCTextField(value: .constant(""))
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
