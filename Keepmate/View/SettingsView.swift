//
//  SettingsView.swift
//  Keepmate
//
//  Created by Rodrick Dai on 2020/1/17.
//  Copyright © 2020 Rodrick Dai. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView {
            Form {
                Toggle(isOn: .constant(true)) {
                    Text("Receive notifications")
                }
                NavigationLink(destination: Text("Detail View")) {
                    Text("Hello World")
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .navigationBarTitle(Text(""))
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
