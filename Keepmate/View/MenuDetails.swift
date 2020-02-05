//
//  MenuDetails.swift
//  Keepmate
//
//  Created by Rodrick Dai on 2020/2/2.
//  Copyright © 2020 Rodrick Dai. All rights reserved.
//

import SwiftUI

struct MenuDetails: View {
    @Environment(\.presentationMode) var presentation
    @Binding var selectedItem: Int
    @Binding var isPresented: Bool
    
    var body: some View {
        Group {
            if selectedItem == 1 {
                SettingsView(isPresented: $isPresented)
            } else if selectedItem == 0 {
                ProfileView(isPresented: $isPresented)
            }
        }
        .navigationBarTitle(Text(""))
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

struct MenuDetails_Previews: PreviewProvider {
    static var previews: some View {
        MenuDetails(selectedItem: .constant(1), isPresented: .constant(true))
    }
}
