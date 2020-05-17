//
//  EditPersonalStatusUIView.swift
//  Keepmate
//
//  Created by Rodrick Dai on 2020/5/17.
//  Copyright © 2020 Rodrick Dai. All rights reserved.
//

import SwiftUI

struct EditPersonalStatusUIView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var status: String
    var body: some View {
        VStack(alignment: .center) {
            TextField("", text: $status)
                .padding(10)
            Spacer()
        }
        .navigationBarTitle("Edit Status", displayMode: .inline)
        .navigationBarItems(trailing: Button( action: {
            UserInfo.updateUserStatus(self.status)
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Text("Done")
            }
        )
    }
}

struct EditPersonalStatusUIView_Previews: PreviewProvider {
    static var previews: some View {
        EditPersonalStatusUIView(status: .constant("hello world"))
    }
}
