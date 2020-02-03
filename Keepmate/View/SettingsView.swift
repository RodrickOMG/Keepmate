//
//  SettingsView.swift
//  Keepmate
//
//  Created by Rodrick Dai on 2020/1/17.
//  Copyright © 2020 Rodrick Dai. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @Binding var isPresented: Bool
    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                Form {
                    Section(header: Text("")) {
                        // set header: Text("") to fix the form jump up issue.
                        Toggle(isOn: .constant(true)) {
                            Text("Receive notifications")
                        }

                        NavigationLink(destination: Text("Detail View")) {
                            Text("Hello World")
                        }
                        NavigationLink(destination: Text("Detail View")) {
                            Text("Hello World")
                        }
                        NavigationLink(destination: Text("Detail View")) {
                            Text("Hello World")
                        }
                        NavigationLink(destination: Text("Detail View")) {
                            Text("Hello World")
                        }
                    }
                    NavigationLink(destination: Text("Detail View")) {
                        Text("Hello World")
                    }
                    NavigationLink(destination: Text("Detail View")) {
                        Text("Hello World")
                    }
                    NavigationLink(destination: Text("Detail View")) {
                        Text("Hello World")
                    }
                }
                .navigationBarItems(leading:
                    Button(action: {
                        self.isPresented.toggle()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18))
                            .foregroundColor(Color("BackBtn1"))
                    }
                    .frame(width: 30, height: 30)
                    .padding(.leading, -5)
                )
                .navigationBarTitle(Text("Settings"), displayMode: .inline)
            }
            
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SettingsView(isPresented: .constant(true)).previewDevice("iPhone Xs Max")
            SettingsView(isPresented: .constant(true)).previewDevice("iPhone 11 Pro")
            SettingsView(isPresented: .constant(true)).previewDevice("iPhone 11")
                .environment(\.colorScheme, .dark)
            SettingsView(isPresented: .constant(true)).previewDevice("iPhone 8")
        }
    }
}
