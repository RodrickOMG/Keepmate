//
//  ProfileView.swift
//  Keepmate
//
//  Created by Rodrick Dai on 2020/2/4.
//  Copyright © 2020 Rodrick Dai. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                ZStack(alignment: .topLeading){
                    Color("mainBackground")
                        .edgesIgnoringSafeArea(.top)
                    VStack(alignment: .leading) {
                        Button(action:{
                            print("edit profile background")
                        }) {
                        Image("profile_default_background")
                            .resizable()
                            .edgesIgnoringSafeArea(.top)
                            .frame(height: geo.size.height * 0.1)
                            .shadow(radius: 10)
                        }
                        .buttonStyle(PlainButtonStyle())
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
                        Text("Rodrick")
                            .font(.title)
                            .bold()
                            .padding(.leading, 20)
                        Text("206552@qq.com")
                            .font(.body)
                            .padding(.leading, 20)
                    }
                    
                }
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            ProfileView().previewDevice("iPhone Xs Max")
            ProfileView().previewDevice("iPhone 11 Pro")
            ProfileView().previewDevice("iPhone 11")
                .environment(\.colorScheme, .dark)
            ProfileView().previewDevice("iPhone 8")
        }
    }
}
