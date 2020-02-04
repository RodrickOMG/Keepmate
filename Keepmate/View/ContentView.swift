//
//  ContentView.swift
//  Keepmate
//
//  Created by Rodrick Dai on 2020/1/13.
//  Copyright © 2020 Rodrick Dai. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var show = false
    @State var viewState = CGSize.zero // position
    
    var body: some View {
        ZStack {
            Color("mainBackground")
                .edgesIgnoringSafeArea(.all)
            Group{
                BlurView(style: .systemMaterial)
                
                TitleView()
                    .blur(radius: show ? 20 : 0)
                    .animation(.default)
                
                CardBottomView()
                    .blur(radius: show ? 20 : 0)
                    .animation(.default)
                
                CardView()
                    .background(Color("background1"))
                    .cornerRadius(10)
                    .shadow(radius: 20)
                    .offset(x: 0, y: show ? -400 : -44)
                    .scaleEffect(0.85)
                    .rotationEffect(Angle(degrees: show ? 15 : 0))
                    //                .rotation3DEffect(Angle(degrees: show ? 50 : 0), axis: (x: 10  , y: 10, z: 10))
                    //                .blendMode(.hardLight)
                    .animation(.easeInOut(duration: 0.6))
                    .offset(x: viewState.width, y: viewState.height)
                
                CardView()
                    .background(Color("background2"))
                    .cornerRadius(10)
                    .shadow(radius: 20)
                    .offset(x: 0, y: show ? -200 : -22)
                    .scaleEffect(0.9)
                    .rotationEffect(Angle(degrees: show ? 10 : 0))
                    //                .rotation3DEffect(Angle(degrees: show ? 40 : 0), axis: (x: 10  , y: 10, z: 10))
                    //                .blendMode(.hardLight)
                    .animation(.easeInOut(duration: 0.4))
                    .offset(x: viewState.width, y: viewState.height)
                
                MainCardView()
                    .offset(x: viewState.width, y: viewState.height)
                    .rotationEffect(Angle(degrees: show ? 5 : 0))
                    //                .rotation3DEffect(Angle(degrees: show ? 30 : 0), axis: (x: 10  , y: 10, z: 10))
                    .animation(.spring())
                    .onTapGesture {
                        self.show.toggle()
                }
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            self.viewState = value.translation
                            self.show = true
                    }
                    .onEnded { value in
                        self.viewState = CGSize.zero
                        self.show = false
                    }
                )
            }
            
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .navigationBarTitle(Text(""))
    }
}


struct CardView: View {
    var body: some View {
        VStack {
            Text("hello")
        }
        .frame(width: 300, height: 185)
    }
}

struct MainCardView: View {
    var body: some View {
        VStack {
            Image("Biceps_Curl")
                .resizable()
                .frame(width: 300, height: 185)
        }
        .cornerRadius(10)
        .shadow(radius: 20)
    }
}

struct TitleView: View {
    var body: some View {
        VStack {
            HStack {
                VStack {
                    Text("Keepmate")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                }
                Spacer()
            }
            Image("undraw_working_out")
                .resizable()
                .frame(width: 300, height: 185)
            Spacer()
        }.padding()
    }
}

struct CardBottomView: View {
    var body: some View {
        VStack(spacing: 20.0) {
            Rectangle()
                .frame(width: 60, height: 6)
                .cornerRadius(3)
                .opacity(0.1)
            Text("Keepmate can help you get better fitness, and scores for your fitness movement and provide professional guidance through AI.")
            Spacer()
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .padding()
        .padding(.horizontal)
        .background(BlurView(style: .systemMaterial))
        .cornerRadius(30)
        .shadow(radius: 20)
        .offset(y: 600)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            ContentView().previewDevice("iPhone Xs Max")
            ContentView().previewDevice("iPhone 11 Pro")
            ContentView().previewDevice("iPhone 11")
                .environment(\.colorScheme, .dark)
            ContentView().previewDevice("iPhone 8")
        }
    }
}
