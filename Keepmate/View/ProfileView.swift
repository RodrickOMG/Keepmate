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
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .topLeading) {
                Color("mainBackground")
                    .edgesIgnoringSafeArea(.all)
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
                }.edgesIgnoringSafeArea(.top)
                Button(action: {
                    self.isPresented.toggle()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20))
                        .foregroundColor(Color(.white))
                    
                }.frame(width: 30, height: 30)
                    .padding(.leading, 5)
            }
        }
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
