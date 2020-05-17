//
//  RecordsStore.swift
//  Keepmate
//
//  Created by Rodrick Dai on 2020/5/17.
//  Copyright © 2020 Rodrick Dai. All rights reserved.
//

import SwiftUI
import Combine

class RecordsStore: ObservableObject {
    @Published var records: [Record] = [Record(fitnessTitle: "ggg", fitnessCount: 10, score: 86, date: "2020-5-19")]
    
    init() {
        let query:BmobQuery = BmobQuery(className: "FitnessRecord")
        let user = BmobUser.current()
        query.whereKey("user", equalTo: user)
        query.findObjectsInBackground { (array, error) in
            for i in 0...array!.count-1 {
                let obj = array![i] as! BmobObject
                let title = obj.object(forKey: "fitnessTitle") as? String
                let score = obj.object(forKey: "score") as? Int
                let count = obj.object(forKey: "fitnessCount") as? Int
                let date = obj.updatedAt
                let record = Record(fitnessTitle: title!, fitnessCount: count!, score: score!, date: date!.description)
                self.records.append(record)
            }
        }
        print(records)
    }
}

struct Record: Identifiable {
    var id = UUID()
    var fitnessTitle: String
    var fitnessCount: Int
    var score: Int
    var date: String
}
