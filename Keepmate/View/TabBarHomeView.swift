//
//  TabBarView.swift
//  Keepmate
//
//  Created by Rodrick Dai on 2020/1/17.
//  Copyright © 2020 Rodrick Dai. All rights reserved.
//

import SwiftUI

let items: [BottomBarItem] = [
    BottomBarItem(icon: "house.fill", title: "Home", color: Color("Font1")),
    BottomBarItem(icon: "heart", title: "Likes", color: .pink),
    BottomBarItem(icon: "magnifyingglass", title: "Search", color: .green),
    BottomBarItem(icon: "person.fill", title: "Profile", color: .orange                               )
]

struct BasicView: View {
    @Binding var isLogin: Bool
    let item: BottomBarItem
    let index: Int
    
    func openTwitter() {
        guard let url = URL(string: "https://twitter.com/smartvipere75") else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    var body: some View {
        VStack {
            if index == 0 {
                HomeView(isLoginConfirmed: $isLogin)
            } else if index == 3 {
                ProfileView(isPresented: .constant(true))
            }
        }
    }
}

struct TabBarHomeView : View {
    @State private var selectedIndex: Int = 0
    @Binding var isLogin: Bool
    
    var selectedItem: BottomBarItem {
        items[selectedIndex]
    }
    
    var body: some View {
        NavigationView {
            VStack {
                BasicView(isLogin: $isLogin, item: selectedItem, index: selectedIndex)
                    .navigationBarTitle(Text(selectedItem.title))
                BottomBar(selectedIndex: $selectedIndex, items: items)
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
            TabBarHomeView(isLogin: .constant(true)).previewDevice("iPhone Xs Max")
            TabBarHomeView(isLogin: .constant(true)).previewDevice("iPhone 11 Pro")
            TabBarHomeView(isLogin: .constant(true)).previewDevice("iPhone 11")
                .environment(\.colorScheme, .dark)
            TabBarHomeView(isLogin: .constant(true)).previewDevice("iPhone 8")
        }
    }
}

