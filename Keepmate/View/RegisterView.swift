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
    @State var isRegistered = false
    @State var viewState = CGSize.zero // position
    
    @State var isProcessed = false
    @State var degress = 0.0
    
    @State var showAlert = false
    @State var alertMsg = ""
    
    var body: some View {
        ZStack {
            Color("mainBackground")
                .edgesIgnoringSafeArea(.all)
            VStack {
                Button(action: {
                    self.isPresented.toggle()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20))
                        .foregroundColor(Color("BackBtn1"))
                    
                }.frame(width: 30, height: 30)
            }
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
                NavigationLink(destination: TabBarHomeView(isLogin: $isRegistered), isActive: $isRegistered) {
                    Button(action: {
                        self.registerPressed(self.email, self.username, self.password)
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
                .alert(isPresented: $showAlert) {
                    Alert(title: Text(alertMsg))
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
            .gesture(  // swipe to back
                DragGesture()
                    .onChanged { value in
                        self.viewState = value.translation
                }
                .onEnded { value in
                    if self.viewState.width > 0 && abs(self.viewState.height) < 50{
                        self.viewState = CGSize.zero
                        self.isPresented.toggle()
                    }
                    self.viewState = CGSize.zero
                }
        )
    }
    
    func registerPressed(_ email: String, _ username: String, _ password: String) {
        let user = BmobUser()
        user.email = email
        user.username = username
        user.password = password
        if !Utilities.isPasswordValid(password) {
            self.alertMsg = "Your password has to be at least 8 characters long, and must contain at least one lower case letter, one upper case letter."
            self.showAlert.toggle()
            return
        }
        self.isProcessed.toggle()
        user.signUpInBackground {
            (isSuccessful, error) in if isSuccessful {
                print("Successfullly created user: " + username)
                UserDefaults.standard.set(email, forKey: "email")
                UserDefaults.standard.set(username, forKey: "username")
                UserDefaults.standard.set(true, forKey: "isLogined")
                self.isProcessed.toggle()
                self.isRegistered.toggle()
            } else {
                print("Failed to create user. " + error!.localizedDescription)
                self.isProcessed.toggle()
                self.alertMsg = error!.localizedDescription
                self.showAlert.toggle()
            }
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

struct ProgressCircleView: View {
    @State var degress = 0.0
    var body: some View {
        Group {
            Rectangle()
                .stroke(Color.white, lineWidth: 0)
                .background(Color.white)
                .frame(width: 80, height: 80)
                .cornerRadius(10)
                .shadow(radius: 10)
                .opacity(0.3)
            Circle()
                .trim(from: 0.0, to: 0.6)
                .stroke(Color.blue, lineWidth: 5.0)
                .padding()
                .frame(width: 80, height: 80)
                .rotationEffect(Angle(degrees: degress))
                .onAppear(perform: {self.start()})
        }
        .padding(.bottom, 80)
    }
    
    func start() {
        _ = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { timer in
            withAnimation {
                self.degress += 10.0
            }
            if self.degress == 360.0 {
                self.degress = 0.0
            }
        }
    }
}
