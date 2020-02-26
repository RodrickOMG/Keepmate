//
//  LoginView.swift
//  Keepmate
//
//  Created by Rodrick Dai on 2020/1/13.
//  Copyright © 2020 Rodrick Dai. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    @State var email = ""
    @State private var password = ""
    @State var err = ""
    @State var isPresented = false
    @State var isLogined = false
    
    @State var isProcessed = false
    @State var degress = 0.0
    
    @State var showAlert = false
    @State var alertMsg = ""
    var body: some View {
        NavigationView {
            ZStack {
                Color("mainBackground")
                    .edgesIgnoringSafeArea(.all)
                .navigationBarHidden(true)
                .navigationBarTitle(Text(""))
                .edgesIgnoringSafeArea([.top, .bottom])
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
                    NavigationLink(destination: TabBarHomeView(), isActive: $isLogined) {
                        Button(action: {
                            self.loginPressed(self.email, self.password)
                        }) {
                            HStack {
                                Text("Login")
                                    .fontWeight(.bold)
                                    .font(.custom("Chalkboard SE", size: 28))
                            }
                            .frame(minWidth: 0, maxWidth: 300)
                            .padding(5)
                            .foregroundColor(.white)
                            .background(LinearGradient(gradient: Gradient(colors: [Color("DarkBtnBkg1"), Color("LightBtnBkg1")]), startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(40)
                        }
                        .padding( .bottom, 50)
                    }
                    HStack(spacing: 80) {
                        NavigationLink(destination: RegisterView(isPresented: $isPresented), isActive: $isPresented){
                            Button(action: {
                                print("register")
                                self.isPresented.toggle()
                            }) {
                                Text("Register")
                                    .foregroundColor(.red)
                                    .font(.custom("Chalkboard SE", size: 18))
                            }
                        }
                        .alert(isPresented: $showAlert) {
                            Alert(title: Text(alertMsg))
                        }
                        Button(action: {
                            print("Forgot password?")
                        }) {
                            Text("Forgot password?")
                                .font(.custom("Chalkboard SE", size: 16))
                        }
                    }
                }
                    // end of the view
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: Alignment.top)
                if isProcessed {
                    ProgressCircleView()
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .navigationBarTitle(Text(""))
            .onAppear(perform: {
                self.isLogined = false
            })
        }
    }
    func loginPressed(_ email: String, _ password: String) {
        let user = BmobUser()
        user.email = email
        user.password = password
        self.isProcessed.toggle()
        BmobUser.loginInbackground(withAccount: email, andPassword: password) { (user, error) in
            if error != nil {
                self.isProcessed.toggle()
                self.alertMsg = error!.localizedDescription
                self.showAlert.toggle()
            } else {
                print("Login successfully")
                UserDefaults.standard.set(email, forKey: "email")
                UserDefaults.standard.set(user?.username, forKey: "username")
                UserDefaults.standard.set(true, forKey: "isLogined")
                self.isProcessed.toggle()
                self.isLogined.toggle()
            }
        }
    }
}

struct MultilineTextView: UIViewRepresentable {
    @Binding var text: String

    func makeUIView(context: Context) -> UITextView {
        let view = UITextView()
        view.isScrollEnabled = true
        view.isEditable = false
        view.isUserInteractionEnabled = false
        view.textAlignment = .center
        view.textColor = .red
        view.font = UIFont(name: "Roboto", size: 11.0)
        view.backgroundColor = UIColor(named: "LoginAndRegisterBkg")
        view.alpha = 1
        return view
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }
}

#if DEBUG
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            LoginView().previewDevice("iPhone 11 Pro Max")
            LoginView().previewDevice("iPhone 11")
                .environment(\.colorScheme, .dark)
            LoginView().previewDevice("iPhone 8")
        }
        
    }
}
#endif
