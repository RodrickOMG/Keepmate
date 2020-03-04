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
                                    .scaledToFit()
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
        self.username = UserDefaults.standard.string(forKey: "username") ?? "Not Login"
        self.email = UserDefaults.standard.string(forKey: "email") ?? ""
        if UserDefaults.standard.string(forKey: "profilePicPath") == nil || UserDefaults.standard.string(forKey: "profilePicPath") == "" {
            getRemoteProfilePic()
        } else {
            let filePath = String(UserDefaults.standard.string(forKey: "profilePicPath")!)
            let url = URL.init(fileURLWithPath: filePath)
            do {
                print("1")
                let data = try Data(contentsOf: url)
                let uiImage = UIImage(data: data)
                self.image = Image(uiImage: uiImage ?? UIImage())
            } catch let error as NSError {
                print("2")
                print(error)
                getRemoteProfilePic()
            }
        }
    }
    func getRemoteProfilePic() {
        let user = BmobUser.current()
        let profilePicFile = user?.object(forKey: "profilePic") as? BmobFile
        if profilePicFile != nil {
            let tempURL = profilePicFile!.url!
            let urlWithoutHTTPS = tempURL.suffix(from: tempURL.index(tempURL.startIndex, offsetBy: 7))
            guard let url = URL(string: String("http://" + urlWithoutHTTPS)) else {return}
            print(url)
            let task = URLSession.shared.dataTask(with: url as URL) { data, response, error in
                guard let data = data else { return }
                if error != nil {
                    print("3")
                    print(error as Any)
                    self.image = Image("profile_default_male")
                } else {
                    print("4")
                    let uiImage = UIImage(data: data)
                    self.image = Image(uiImage: uiImage ?? UIImage())
                    let filePath: String = UserInfo.savePic(data, self.username)
                    UserDefaults.standard.set(filePath, forKey: "profilePicPath")
                }
            }
            task.resume()
        } else {
            self.image = Image("profile_default_male")
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
