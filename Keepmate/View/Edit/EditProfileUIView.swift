//
//  EditProfileUIView.swift
//  Keepmate
//
//  Created by Rodrick Dai on 2020/5/17.
//  Copyright © 2020 Rodrick Dai. All rights reserved.
//

import SwiftUI

struct EditProfileUIView: View {
    @Binding var username: String
    @Binding var status: String
    
    var body: some View {
            VStack(alignment: .center) {
                Form {
                    Section(header: Text("")) {
                        NavigationLink(destination: Text("Detail View")) {
                            HStack {
                                Text("Username")
                                    .bold()
                                Spacer()
                                Text(username)
                                Spacer()
                            }
                        }
                        NavigationLink(destination: EditPersonalStatusUIView(status: $status)) {
                            HStack {
                                Text("Status")
                                    .bold()
                                Spacer()
                                Text(status)
                                    .lineLimit(1)
                                    .font(.footnote)
                                Spacer()
                            }
                        }
                    }
                }
            }
            .navigationBarTitle(Text("Edit Profile"), displayMode: .inline)
    }
        
}

struct EditProfileUIView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileUIView(username: .constant("RodrickOMG"), status: .constant("Hello World"))
    }
}
