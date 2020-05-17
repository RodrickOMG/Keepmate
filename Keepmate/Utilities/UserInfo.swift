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
    
    static func savePic(_ data: Data, _ picName: String) -> String {
        let homeDirectory = NSHomeDirectory()
        let documentPath = homeDirectory + "/Documents"
        //文件管理器
        let fileManager: FileManager = FileManager.default
        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
        do {
            try fileManager.createDirectory(atPath: documentPath, withIntermediateDirectories: true, attributes: nil)
        }
        catch let error {
            print(error)
        }
        
        let filename = "/" + picName + ".png"
        fileManager.createFile(atPath: documentPath.appendingFormat(filename), contents: data, attributes: nil)
        //得到选择后沙盒中图片的完整路径
        let filePath: String = String(format: "%@%@", documentPath, filename)
        return filePath
    }
     
    static func updateUserStatus(_ status: String) {
        let user = BmobUser.current()
        user?.setObject(status, forKey: "status")
        user?.updateInBackground(resultBlock: { (isSuccessful, error) in
            if isSuccessful {
                print("update successfully");
            }else{
                print("update error is \(String(describing: error?.localizedDescription))")
            }
        })
    }
    
    static func addNewFitnessRecord(_ title: String, _ score: Int, _ successCount: Int ) {
        let user = BmobUser.current()
        let record:BmobObject = BmobObject(className: "FitnessRecord")
        record.setObject(score, forKey: "score")
        record.setObject(title, forKey: "fitnessTitle")
        record.setObject(successCount, forKey: "fitnessCount")
        record.setObject(user, forKey: "user")
        record.saveInBackground { (isSuccessful, error) in
            if isSuccessful {
                print("objectId \(String(describing: record.objectId))")
            }else{
                print("error \(String(describing: error))")
            }
        }
    }
    
}


