//
//  RealmTimerModel.swift
//  timer
//
//  Created by demo on 16.05.2018.
//  Copyright © 2018 demo. All rights reserved.
//

import Foundation
import RealmSwift

class RealmTimerModel: Object {
    @objc dynamic var seconds: Int = 0
    @objc dynamic var estimateDate: Date?
    @objc dynamic var identifier: String = UUID().uuidString
    @objc dynamic var comment: String?
    @objc dynamic var isTimerRunning: Bool = false
    @objc dynamic var isResumeTapped: Bool = false
    @objc dynamic var timeFromPause: Int = 0

    override static func primaryKey() -> String {
        return "identifier"
    }
    
    convenience init(seconds: Int, estimateDate: Date, comment: String?, isRunning: Bool, isResumeTapped: Bool) {
        self.init()
        self.seconds = seconds
        self.estimateDate = estimateDate
        self.comment = comment
        self.isTimerRunning = isRunning
        self.isResumeTapped = isResumeTapped
    }
}
