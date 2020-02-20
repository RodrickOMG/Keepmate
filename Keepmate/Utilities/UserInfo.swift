//
//  UserInfo.swift
//  Keepmate
//
//  Created by Rodrick Dai on 2019/10/17.
//  Copyright © 2019 Rodrick Dai. All rights reserved.
//

import Foundation

class UserInfo {
    
    let userDefaults = UserDefaults.standard
    
    
    static func upload(_ filePath: String){
        let user = BmobUser.current()
        let file = BmobFile.init(filePath: filePath)
        
        file?.save(inBackground: { [weak file] (isSuccessful, error) in
            if isSuccessful {
                let weakFile = file
                print("Successfully upload file")
                user!.setObject(weakFile, forKey: "profilePic")
                user!.setObject("helloworld", forKey: "profilePicName")
                user!.updateInBackground { (isSuccessful, error) in
                    if error != nil {
                        print("save ", error as Any)
                    }
                }
            } else {
                print("upload ", error as Any)
            }
        }, withProgressBlock: { (process) in
            print("process:  ", process)
        })
    }
     
    
    
    
}


