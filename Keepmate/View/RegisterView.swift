//
//  RegisterView.swift
//  Keepmate
//
//  Created by Rodrick Dai on 2020/1/14.
//  Copyright © 2020 Rodrick Dai. All rights reserved.
//

import SwiftUI

struct RegisterView: View {
    @State var email = ""
    @State private var password = ""
    @State private var username = ""
    @State var err = ""
    @Binding var isPresented: Bool
    var body: some View {
        ZStack {
            Color("LoginAndRegisterBkg")
                .edgesIgnoringSafeArea(.all)
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .navigationBarTitle(Text("Home"))
            .edgesIgnoringSafeArea([.top, .bottom])
            VStack {
                Button(action: {
                    self.isPresented.toggle()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20))
                        .foregroundColor(Color("BackBtn1"))
                    
                }
            }
            .frame(width: 30, height: 30, alignment: .topLeading)
            .position(x: 30, y: 20)
            VStack {
                Text("Keepmate")
                    .fontWeight(.bold)
                    .font(.custom("Marker Felt", size: 50))
                    .foregroundColor(Color("Font1"))
                    .padding(40)
                VStack(alignment: .trailing, spacing: 20) {
                    HStack {
                        Text("Email:")
                            .fontWeight(.bold)
                            .font(.custom("Chalkboard SE", size: 20))
                            .foregroundColor(Color("Font1"))
                            .multilineTextAlignment(.leading)
                        TextField("Enter email...", text: $email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 200, alignment: .center)
                            .font(.custom("Chalkboard SE", size: 18))
                    }
                    HStack {
                        Text("Username:")
                            .fontWeight(.bold)
                            .font(.custom("Chalkboard SE", size: 20))
                            .foregroundColor(Color("Font1"))
                            .multilineTextAlignment(.leading)
                        TextField("Enter Username...", text: $username)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 200, alignment: .center)
                            .font(.custom("Chalkboard SE", size: 18))
                    }
                    HStack {
                        Text("Password:")
                            .fontWeight(.bold)
                            .font(.custom("Chalkboard SE", size: 20))
                            .foregroundColor(Color("Font1"))
                            .multilineTextAlignment(.leading)
                        SecureField("Enter password...", text: $password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 200, alignment: .center)
                            .font(.custom("Chalkboard SE", size: 18))
                    }
                }
                .padding(.bottom, -7.0)
                MultilineTextView(text: $err)
                    .frame(minWidth: 0, maxWidth: 280, minHeight: 0, maxHeight: 50)
                Button(action: {
                    print(self.email, self.password)
                }) {
                    HStack {
                        Text("Register")
                            .fontWeight(.bold)
                            .font(.custom("Chalkboard SE", size: 28))
                    }
                    .frame(minWidth: 0, maxWidth: 300)
                    .padding(5)
                    .foregroundColor(.white)
                    .background(LinearGradient(gradient: Gradient(colors: [Color("DarkBtnBkg1"), Color("LightBtnBkg1")]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(40)
                }
            }
            // end of the view
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: Alignment.top)
            
        }
    }
}
#if DEBUG
struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            RegisterView(isPresented: .constant(true)).previewDevice("iPhone 11 Pro Max")
            RegisterView(isPresented: .constant(true)).previewDevice("iPhone 11")
                .environment(\.colorScheme, .dark)
            RegisterView(isPresented: .constant(true)).previewDevice("iPhone 8")
        }

    }
}
#endif
