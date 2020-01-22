//
//  TabBarView.swift
//  Keepmate
//
//  Created by Rodrick Dai on 2020/1/17.
//  Copyright © 2020 Rodrick Dai. All rights reserved.
//

import SwiftUI

struct TabBarHomeView: View {
    @State private var currentTab = 2
    var body: some View {
        ZStack {
            Color("mainBackground")
            .edgesIgnoringSafeArea(.top)
            TabView(selection: $currentTab) {
                ContentView().tabItem {
                    VStack {
                        Image(systemName: "person")
                        Text("Profile")
                    }
                }.tag(1)
                HomeView().tabItem {
                    VStack {
                        Image(systemName: "house")
                        Text("Home")
                    }
                }.tag(2)
                SettingsView().tabItem {
                    VStack {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
                }.tag(3)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .navigationBarTitle(Text(""))
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            TabBarHomeView().previewDevice("iPhone Xs Max")
            TabBarHomeView().previewDevice("iPhone 11 Pro")
            TabBarHomeView().previewDevice("iPhone 11")
                .environment(\.colorScheme, .dark)
            TabBarHomeView().previewDevice("iPhone 8")
        }
    }
}
