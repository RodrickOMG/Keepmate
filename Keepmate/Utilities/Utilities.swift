//
//  Utilities.swift
//  Keepmate
//
//  Created by Rodrick Dai on 2020/2/12.
//  Copyright © 2020 Rodrick Dai. All rights reserved.
//

import Foundation
import SwiftUI

class Utilities {
    static func isPasswordValid(_ password: String) -> Bool {
        let txt = password
        if txt.rangeOfCharacter(from: CharacterSet.uppercaseLetters) == nil {
            return false
        }
        else if txt.rangeOfCharacter(from: CharacterSet.lowercaseLetters) == nil {
            return false
        }
        else if txt.rangeOfCharacter(from: CharacterSet.decimalDigits) == nil {
            return false
        }
        else if txt.count < 8 {
            return false
        } else {
            return true
        }
    }
    
    static func judgePoints(_ predictPoints: [PredictedPoint?], _ standardPoints: [PredictedPoint?]) -> Double {
        var res: [Double] = []
        var resStandard: [Double] = []
        let p1 = predictPoints[1]?.maxPoint
        let p1Standard = standardPoints[1]?.maxPoint
        res.append(computeAngle(p1, predictPoints[0]?.maxPoint))
        resStandard.append(computeAngle(p1Standard, standardPoints[0]?.maxPoint))
        // compute head and neck
        var index = 3
        while index<5 {
            res.append(computeAngle(predictPoints[index-1]?.maxPoint,predictPoints[index]?.maxPoint))
            index += 1
        }
        index = 3
        while index<5 {
            resStandard.append(computeAngle(standardPoints[index-1]?.maxPoint,standardPoints[index]?.maxPoint))
            index += 1
        }
        res.append(computeAngle(p1, predictPoints[5]?.maxPoint))
        resStandard.append(computeAngle(p1Standard, standardPoints[5]?.maxPoint))
        index = 6
        while index<8 {
            res.append(computeAngle(predictPoints[index-1]?.maxPoint,predictPoints[index]?.maxPoint))
            index += 1
        }
        index = 6
        while index<8 {
            resStandard.append(computeAngle(standardPoints[index-1]?.maxPoint,standardPoints[index]?.maxPoint))
            index += 1
        }
        res.append(computeAngle(p1, predictPoints[8]?.maxPoint))
        resStandard.append(computeAngle(p1Standard, standardPoints[8]?.maxPoint))
        index = 9
        while index<11 {
            res.append(computeAngle(predictPoints[index-1]?.maxPoint,predictPoints[index]?.maxPoint))
            index += 1
        }
        index = 9
        while index<11 {
            resStandard.append(computeAngle(standardPoints[index-1]?.maxPoint,standardPoints[index]?.maxPoint))
            index += 1
        }
        res.append(computeAngle(p1, predictPoints[11]?.maxPoint))
        resStandard.append(computeAngle(p1Standard, standardPoints[11]?.maxPoint))
        index = 12
        while index<14 {
            res.append(computeAngle(predictPoints[index-1]?.maxPoint,predictPoints[index]?.maxPoint))
            index += 1
        }
        index = 12
        while index<14 {
            resStandard.append(computeAngle(standardPoints[index-1]?.maxPoint,standardPoints[index]?.maxPoint))
            index += 1
        }
        var Dresult = -1.0
        for i in 0...res.count-1 {
            if Dresult < fabs(res[i]-resStandard[i])/resStandard[i] {
                Dresult = fabs(res[i]-resStandard[i])/resStandard[i]
            }
        }
        if Dresult > 1 {
            return Dresult - 1.0
        } else {
            return Dresult
        }
    }
    
    static func computeAngle(_ p1: CGPoint?, _ p2: CGPoint?) -> Double {
        return Double(abs(atan2((p1?.x ?? 0)-(p2?.x ?? 0), (p1?.y ?? 0)-(p2?.y ?? 0))*180))/Double.pi
    }
    
}
