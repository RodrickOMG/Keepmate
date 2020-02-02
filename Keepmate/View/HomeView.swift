//
//  HomeView.swift
//  Keepmate
//
//  Created by Rodrick Dai on 2020/1/15.
//  Copyright © 2020 Rodrick Dai. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @State var show = false
    @State var showProfile = false
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color("mainBackground")
            .edgesIgnoringSafeArea(.all)
            HomeListView()
                .blur(radius: show ? 20 : 0)
                .scaleEffect(showProfile ? 0.95 : 1)
                .animation(.default)
            
            ContentView()
                .cornerRadius(30)
                .shadow(radius: 20)
                .animation(.spring())
                .offset(y: showProfile ? 40 : UIScreen.main.bounds.height)
            
            HStack {
                MenuButton(show: $show)
                    .offset(x: (showProfile || show) ? -90 : -30, y: showProfile ? 0 : 80)
                    .animation(.spring())
                Spacer()
                MenuRight(show: $showProfile)
                    .offset(x: show ? 95 : -16, y: showProfile ? 0 : 88)
                    .animation(.spring())
            }
            
            MenuView(show: $show)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .navigationBarTitle(Text(""))
        .onDisappear(perform: {
            self.show = false
            self.showProfile = false
        })
    }
}


struct MenuRow: View {
    var image = "creditcard"
    var text = "My Account"
    @State var isPresented = false
    @State var selection = 1
    
    var body: some View {
        NavigationLink(destination: MenuDetails(selectedItem: $selection), isActive: $isPresented) {
            HStack {
                Button(action: {
                    if self.text == "Settings" {
                        self.selection = 1
                    }
                    self.isPresented.toggle()
                }) {
                    Image(systemName: image)
                        .imageScale(.large)
                        .foregroundColor(Color("icons"))
                        .frame(width: 30, height: 30)
                    Text(text)
                        .font(.headline)
                }
                Spacer()
            }
            
        }
    }
}


let menuData = [
    Menu(title: "My Account", icon: "person.crop.circle"),
    Menu(title: "Categories", icon: "tag"),
    Menu(title: "Settings", icon: "gear"),
    Menu(title: "Sign out", icon: "arrow.uturn.down")
]

struct MenuView: View {
    var menu = menuData
    @Binding var show : Bool
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            VStack {
                ForEach(menu) { item in
                    MenuRow(image: item.icon, text: item.title)
                        .foregroundColor(Color("systemFont"))
                }
                Spacer()
                HStack {
                    Text("Version 0.9")
                        .foregroundColor(Color(.gray))
                    Spacer()
                }
            }
        }
        .padding(.top, 20)
        .padding(30)
        .frame(minWidth: 0, maxWidth: .infinity)
        .background(Color("mainBackground").opacity(0.7))
        .cornerRadius(30)
        .padding(.trailing, 80)
        .shadow(radius: 15)
        .rotation3DEffect(Angle(degrees: show ? 0 : 60), axis: (x: 0, y: 10.0, z: 0))
        .animation(.easeInOut(duration: 0.3))
        .offset(x: show ? 0 : -UIScreen.main.bounds.width)
        .onTapGesture {
            self.show.toggle()
        }
    }
}

struct CircleButton: View {
    var icon = "person.crop.circle"
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.primary)
        }
        .frame(width: 44, height: 44)
        .background(BlurView(style: .systemThickMaterial))
        .cornerRadius(30)
        .shadow(color: Color("buttonShadow"), radius: 20, x: 0, y: 20)
    }
}

struct MenuButton: View {
    @Binding var show : Bool
    var body: some View {
        Button(action: { self.show.toggle() }) {
            HStack {
                Spacer()
                Image(systemName: "list.dash")
                    .foregroundColor(.primary)
            }
            .padding(.trailing, 20)
            .frame(width: 90, height: 60)
            .background(BlurView(style: .systemThickMaterial))
            .cornerRadius(30)
            .shadow(color: Color("buttonShadow"), radius: 20, x: 0, y: 20)
        }
    }
}

struct MenuRight: View {
    @Binding var show : Bool
    var body: some View {
        HStack {
            Button(action: { self.show.toggle() }) {
                CircleButton(icon: "flame")
            }
            Button(action: { self.show.toggle() }) {
                CircleButton(icon: "bell")
            }
        }
    }
}

#if DEBUG
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            HomeView().previewDevice("iPhone Xs Max")
            HomeView().previewDevice("iPhone 11 Pro")
            HomeView().previewDevice("iPhone 11")
                .environment(\.colorScheme, .dark)
            HomeView().previewDevice("iPhone 8")
        }
    }
}
#endif
