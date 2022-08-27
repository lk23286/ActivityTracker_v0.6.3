//
//  DataStore.swift
//  ActivityTracker_v0.6.3
//
//  Created by Laszlo Kovacs on 2022. 08. 19..
//

import Foundation

struct Brain {
    
    var tableUpEmptyArray = [String]()
    var tableDownEmptyArray = [DownTableRecord]()

    var mainTableUpDefaultArray = ["Swift", "Sport", "Meditation", "Sleep"]
    var mainTableDownDefaultArray = [
        DownTableRecord(activity: "Swift", achived: "2.0", goal: "10", precent: "20%"),
        DownTableRecord(activity: "Sport", achived: "3.0", goal: "1.0", precent: "300%"),
        DownTableRecord(activity: "Meditation", achived: "0.5", goal: "0.5", precent: "100%"),
        DownTableRecord(activity: "Sleep", achived: "7.0", goal: "7.0", precent: "100%"),
        DownTableRecord(activity: "Break", achived: "1.0", goal: "2.0", precent: "50%")
                        ]
    var tableUpArrays = [[String]]()
    var tableDownArrays = [[DownTableRecord]]()
}

struct DownTableRecord {
    let activity: String
    let achived: String
    let separator = "of"
    var goal: String
    let unit = "hours"
    var precent : String
}

struct K {
    struct Main {
        struct Identifier {
            static var segue = "toSubView"
            static var cellUp = "MainCellUp"
            static var cellDown = "MainCellDown"
        }
        static var nibName = "MainDownTableViewCell"
    }
    struct Sub {
        struct Identifier {
            static var segue = "toCounterView"
            static var cellUp = "SubCellUp"
            static var cellDown = "MainCellDown"
        }
    }
    static let maxNumberOfActivity = 4
}
