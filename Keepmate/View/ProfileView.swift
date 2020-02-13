//
//  ProfileView.swift
//  Keepmate
//
//  Created by Rodrick Dai on 2020/2/4.
//  Copyright © 2020 Rodrick Dai. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
    @Binding var isPresented: Bool
    @State var viewState = CGSize.zero // position
    
    let username = UserDefaults.standard.string(forKey: "username")
    let email = UserDefaults.standard.string(forKey: "email")
    
    var body: some View {
        GeometryReader { geo in
            Color("mainBackground")
                .edgesIgnoringSafeArea(.all)
            ScrollView(.vertical, showsIndicators: false) {
                ZStack(alignment: .topLeading) {
                    VStack(alignment: .leading) {
                        ZStack(alignment: .bottom) {
                            Image("profile_default_background")
                                .resizable()
                                .shadow(radius: 10)
                            .frame(minWidth: 0, maxWidth: .infinity, maxHeight: geo.size.height * 0.25)
                            Button(action:{
                                print("edit profile background")
                            }) {
                                Image("profile_default_background")
                                    .resizable()
                                    .shadow(radius: 10)
                                    .opacity(0.1)
                                    .frame(minWidth: 0, maxWidth: .infinity, maxHeight: geo.size.height * 0.15)
                                
                            }
                            .frame(minWidth: 0, maxWidth: .infinity, maxHeight: geo.size.height * 0.15)
                            .buttonStyle(PlainButtonStyle())
                            
                        }
                        VStack(alignment: .leading) {
                            HStack(spacing: 20) {
                                Image("profile_default_male")
                                    .resizable()
                                    
                                    .cornerRadius(10)
                                    .overlay(Circle().stroke(Color("mainBackground"), lineWidth: 3))
                                    .shadow(radius: 10)
                                    .frame(width: geo.size.width * 0.25, height: geo.size.width * 0.25)
                                    .cornerRadius(50)
                                Button(action:{
                                    print("edit profile")
                                }) {
                                    Text("Edit")
                                        .font(.callout)
                                        .foregroundColor(.white)
                                        .bold()
                                        .frame(width: geo.size.width * 0.18, height: 40, alignment:  .center)
                                        .background(Color("profileBtnBkg"))
                                        .cornerRadius(5)
                                        .shadow(radius: 10)
                                }
                                Button(action:{
                                    print("add friends")
                                }) {
                                    Text("+Friends")
                                        .font(.callout)
                                        .foregroundColor(.white)
                                        .bold()
                                        .frame(width: geo.size.width * 0.36, height: 40, alignment:  .center)
                                        .background(Color("profileBtnBkg"))
                                        .cornerRadius(5)
                                        .shadow(radius: 10)
                                }
                            }
                            .padding(.leading, 20)
                            .padding(.top, -20)
                            Text(self.username!)
                                .font(.title)
                                .bold()
                                .padding(.leading, 20)
                            Text(self.email!)
                                .font(.body)
                                .padding(.leading, 20)
                            Divider()
                                .frame(width: geo.size.width * 0.9)
                                .padding(.horizontal, 5)
                            Text("You haven't filled in your profile, click to add one...")
                                .font(.subheadline)
                                .padding(.leading, 20)
                        }
                    }
                    Button(action: {
                        self.isPresented.toggle()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20))
                            .foregroundColor(Color(.white))
                        
                    }.frame(width: 30, height: 30)
                        .padding(.top, 30)
                        .padding(.leading, 5)
                }
            }
            .edgesIgnoringSafeArea(.top)
        }
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
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            ProfileView(isPresented: .constant(true)).previewDevice("iPhone Xs Max")
            ProfileView(isPresented: .constant(true)).previewDevice("iPhone 11 Pro")
            ProfileView(isPresented: .constant(true)).previewDevice("iPhone 11")
                .environment(\.colorScheme, .dark)
            ProfileView(isPresented: .constant(true)).previewDevice("iPhone 8")
        }
    }
}
