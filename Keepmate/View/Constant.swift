//
//  Constant.swift
//  Keepmate
//
//  Created by Rodrick Dai on 2020/2/2.
//  Copyright © 2020 Rodrick Dai. All rights reserved.
//

import Foundation
import SwiftUI

struct Menu : Identifiable {
    var id = UUID()
    var title : String
    var icon : String
}

struct WorkoutItemCard : Identifiable {
    var id = UUID()
    var title : String
    var imageName : String
    var backgroundColor : Color
    var backgroundShadowColor : Color
}
