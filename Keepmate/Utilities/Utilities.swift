//
//  Utilities.swift
//  Keepmate
//
//  Created by Rodrick Dai on 2020/2/12.
//  Copyright © 2020 Rodrick Dai. All rights reserved.
//

import Foundation

class Utilities {
    static func emailValidity(_ email: String) -> String{
        if email.count > 0 {
            return ""
        } else {
            return "Email cannot be empty"
        }
    }
}
