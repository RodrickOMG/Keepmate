//
//  UpdateListView.swift
//  Keepmate
//
//  Created by Rodrick Dai on 2020/1/16.
//  Copyright © 2020 Rodrick Dai. All rights reserved.
//

import SwiftUI

struct UpdateListView: View {
    @State var isSheetShown = false
    var body: some View {
        NavigationView {
            List(/*@START_MENU_TOKEN@*/0 ..< 5/*@END_MENU_TOKEN@*/) { item in
                NavigationLink(destination: Text("1")) { Text("Navigate 1") }
            }
            .navigationBarTitle(Text("Updates"))
            .navigationBarItems(trailing:
                Button(action: {self.isSheetShown.toggle()}) {
                    Image(systemName: "gear")
                }
            )
            .sheet(isPresented: $isSheetShown, content: {Text("hello")})
        }
    }
}

struct UpdateListView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateListView()
    }
}
