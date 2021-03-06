//
//  ImagePicker.swift
//  Keepmate
//
//  Created by Rodrick Dai on 2020/2/19.
//  Copyright © 2020 Rodrick Dai. All rights reserved.
//

import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {

    @Environment(\.presentationMode)
    var presentationMode

    @Binding var image: Image?
    @Binding var pickerType: String

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

        @Binding var presentationMode: PresentationMode
        @Binding var image: Image?

        init(presentationMode: Binding<PresentationMode>, image: Binding<Image?>) {
            _presentationMode = presentationMode
            _image = image
        }

        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let uiImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            image = Image(uiImage: uiImage)
            uploadProfilePic(uiImage)
            presentationMode.dismiss()
        }

        func uploadProfilePic(_ uiImage: UIImage) {
            guard let uploadData = uiImage.jpegData(compressionQuality: 0.3) else { return }
            let username = UserDefaults.standard.string(forKey: "username")!
            let filePath: String = UserInfo.savePic(uploadData, username)
            print("filePath:" + filePath)
            UserInfo.upload(filePath)
            UserDefaults.standard.set(filePath, forKey: "profilePicPath")
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            presentationMode.dismiss()
        }
        
        

    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(presentationMode: presentationMode, image: $image)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        print(pickerType)
        if pickerType == "camera" {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        picker.delegate = context.coordinator
        picker.allowsEditing = true
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController,
                                context: UIViewControllerRepresentableContext<ImagePicker>) {

    }

    
}
