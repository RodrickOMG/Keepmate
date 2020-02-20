//
//  ProfileView.swift
//  Keepmate
//
//  Created by Rodrick Dai on 2020/2/4.
//  Copyright © 2020 Rodrick Dai. All rights reserved.
//

import SwiftUI
import Combine


struct ProfileView: View {
    @Binding var isPresented: Bool
    @State var viewState = CGSize.zero // position
    @State var isChangeProfilePicPresented = false
    
    @State var showImagePicker: Bool = false
    @State var pickerType: String = ""
    
    @State var username: String = ""
    @State var email: String = ""
    @State var image: Image? = Image("profile_default_male")
    
    var actionSheet: ActionSheet {
        ActionSheet(title: Text("Choose a new profile picture"), buttons: [
            .default(Text("Take Photo"),action: {
                self.pickerType = "camera"
                self.showImagePicker.toggle()
            }),
            .default(Text("Choose from Album"),action: {
                self.pickerType = "photoLibrary"
                self.showImagePicker.toggle()
            }),
            .destructive(Text("Cancel"))
        ])
    }
    
    var body: some View {
        GeometryReader { geo in
            Color("mainBackground")
                .edgesIgnoringSafeArea(.all)
            ScrollView(.vertical, showsIndicators: false) {
                ZStack(alignment: .topLeading) {
                    VStack(alignment: .leading) {
                        ZStack(alignment: .bottom) {
                            Image("profile_default_background")
                                .resizable()
                                .shadow(radius: 10)
                            .frame(minWidth: 0, maxWidth: .infinity, maxHeight: geo.size.height * 0.25)
                            Button(action:{
                                print("edit profile background")
                            }) {
                                Image("profile_default_background")
                                    .resizable()
                                    .scaledToFill()
                                    .shadow(radius: 10)
                                    .opacity(0.1)
                                    .frame(minWidth: 0, maxWidth: .infinity, maxHeight: geo.size.height * 0.15)
                                
                            }
                            .frame(minWidth: 0, maxWidth: .infinity, maxHeight: geo.size.height * 0.15)
                            .buttonStyle(PlainButtonStyle())
                            
                        }
                        VStack(alignment: .leading) {
                            HStack(spacing: 20) {
                                Button(action:{
                                    self.isChangeProfilePicPresented.toggle()
                                    print("edit profile picture")
                                }) {
                                    self.image?
                                        .resizable()
                                        .scaledToFill()
                                        .cornerRadius(10) .overlay(Circle().stroke(Color("mainBackground"), lineWidth: 3))
                                        .shadow(radius: 10)
                                        .frame(width: geo.size.width * 0.25, height: geo.size.width * 0.25)
                                        .cornerRadius(50)
                                }
                                .buttonStyle(PlainButtonStyle())
                                .actionSheet(isPresented: self.$isChangeProfilePicPresented, content: {
                                    self.actionSheet
                                })
                                .sheet(isPresented: self.$showImagePicker) {
                                    ImagePicker(image: self.$image, pickerType: self.$pickerType)
                                }
                                Button(action:{
                                    print("edit profile")
                                }) {
                                    Text("Edit")
                                        .font(.callout)
                                        .foregroundColor(.white)
                                        .bold()
                                        .frame(width: geo.size.width * 0.18, height: 40, alignment:  .center)
                                        .background(Color("profileBtnBkg"))
                                        .cornerRadius(5)
                                        .shadow(radius: 10)
                                }
                                Button(action:{
                                    print("add friends")
                                }) {
                                    Text("+Friends")
                                        .font(.callout)
                                        .foregroundColor(.white)
                                        .bold()
                                        .frame(width: geo.size.width * 0.36, height: 40, alignment:  .center)
                                        .background(Color("profileBtnBkg"))
                                        .cornerRadius(5)
                                        .shadow(radius: 10)
                                }
                            }
                            .padding(.leading, 20)
                            .padding(.top, -20)
                            Text(self.username)
                                .font(.title)
                                .bold()
                                .padding(.leading, 20)
                            Text(self.email)
                                .font(.body)
                                .padding(.leading, 20)
                            Divider()
                                .frame(width: geo.size.width * 0.9)
                                .padding(.horizontal, 5)
                            Text("You haven't filled in your profile, click to add one...")
                                .font(.subheadline)
                                .padding(.leading, 20)
                        }
                    }
                    Button(action: {
                        self.isPresented.toggle()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20))
                            .foregroundColor(Color(.white))
                        
                    }.frame(width: 30, height: 30)
                        .padding(.top, 30)
                        .padding(.leading, 5)
                }
            }
            .edgesIgnoringSafeArea(.top)
        }
            
            .gesture(  // swipe to back
                DragGesture()
                    .onChanged { value in
                        self.viewState = value.translation
                }
                .onEnded { value in
                    if self.viewState.width > 0 && abs(self.viewState.height) < 50{
                        self.viewState = CGSize.zero
                        self.isPresented.toggle()
                    }
                    self.viewState = CGSize.zero
                }
        )
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .navigationBarTitle(Text(""))
        .onAppear(perform: {
            self.getCurrentUser()
        })
    }
    func getCurrentUser() {
        let user = BmobUser.current()
        self.username = UserDefaults.standard.string(forKey: "username") ?? "Not Login"
        self.email = UserDefaults.standard.string(forKey: "email") ?? ""
        print(UserDefaults.standard.string(forKey: "profilePicPath") as Any)
        if UserDefaults.standard.string(forKey: "profilePicPath") == nil {
            let profilePicFile = user?.object(forKey: "profilePic") as? BmobFile
            guard let url = URL(string: profilePicFile!.url!) else {return}
            do {
                let data = try Data(contentsOf: url)
                let uiImage = UIImage(data: data)
                self.image = Image(uiImage: uiImage ?? UIImage())
            }catch let error as NSError {
                print(error)
                self.image = Image("profile_default_male")
            }
        } else {
            let filePath = String(UserDefaults.standard.string(forKey: "profilePicPath")!)
            let url = URL.init(fileURLWithPath: filePath)
            do {
                let data = try Data(contentsOf: url)
                let uiImage = UIImage(data: data)
                self.image = Image(uiImage: uiImage ?? UIImage())
            }catch let error as NSError {
                print(error)
                self.image = Image("profile_default_male")
            }
        }
        
    }
}
final class RemoteImageURL: ObservableObject {
    var didChange = PassthroughSubject<Data, Never>()
    var data = Data() {
        didSet {
            didChange.send(data)
        }
    }
    init(imageURL: String) {
        guard let url = URL(string: imageURL) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            
            DispatchQueue.main.async { self.data = data }
            
        }.resume()
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            ProfileView(isPresented: .constant(true)).previewDevice("iPhone Xs Max")
            ProfileView(isPresented: .constant(true)).previewDevice("iPhone 11 Pro")
            ProfileView(isPresented: .constant(true)).previewDevice("iPhone 11")
                .environment(\.colorScheme, .dark)
            ProfileView(isPresented: .constant(true)).previewDevice("iPhone 8")
        }
    }
}
