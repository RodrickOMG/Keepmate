//
//  EditPersonalStatusUIView.swift
//  Keepmate
//
//  Created by Rodrick Dai on 2020/5/17.
//  Copyright © 2020 Rodrick Dai. All rights reserved.
//

import SwiftUI
import TextView

struct EditPersonalStatusUIView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var status: String
    @State var isEditing = false
    @State var isChanged = false
    @State var changedStatus = ""
    var body: some View {
        VStack(alignment: .center) {
            TextView(text: $changedStatus, isEditing: $isEditing)
                .padding(10)
            Spacer()
        }
        .navigationBarTitle("Edit Status", displayMode: .inline)
        .navigationBarItems(trailing: Button( action: {
            UserInfo.updateUserStatus(self.changedStatus)
            self.status = self.changedStatus
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Text("Done")
            }
        )
            .onTapGesture {
                self.isEditing.toggle()
                self.endEditing()
        }
        .onAppear {
            self.changedStatus = self.status
        }
    }
    private func endEditing() {
        UIApplication.shared.endEditing()
    }
}

struct EditPersonalStatusUIView_Previews: PreviewProvider {
    static var previews: some View {
        EditPersonalStatusUIView(status: .constant("hello world"))
    }
}
