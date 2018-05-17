//
//  Timer.swift
//  timer
//
//  Created by Yuriy borisov on 08.05.2018.
//  Copyright © 2018 demo. All rights reserved.
//

import Foundation
import UserNotifications
import RealmSwift

class TimerModel {
    
    let realm = try! Realm()
    var realmTimerModel: RealmTimerModel
    var seconds: Int
    var timer = Timer()
    var temp: Int = 0
    var time = TimeInterval(0)
    var estimateTime: Date?
    var identifier = UUID().uuidString
    var delegate: TimerDelegate?
    
    var notificationContent: UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = "Timer"
        content.body = comment ?? "Timer for \(seconds) seconds ended"
        content.sound = UNNotificationSound(named: "test2.wav")
        return content
    }
    
    var comment: String?
    
    var isTimerRunning = false
    var resumeTapped = false
    var isFromBackground = false
    
    init(seconds: Int, timerModel: RealmTimerModel) {
        self.realmTimerModel = timerModel
        self.seconds = timerModel.seconds
        self.temp = seconds
        self.comment = timerModel.comment
        self.identifier = timerModel.identifier
        self.estimateTime = timerModel.estimateDate
        try! self.realm.write {
            self.realm.add(realmTimerModel)
        }
        
        
    }
    
    func start() {
        temp = seconds
        runTimer()
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(seconds), repeats: false)
        let request = UNNotificationRequest(identifier: "\(identifier)", content: notificationContent, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func stop() {
        temp = seconds
        timer.invalidate()
        isTimerRunning = false
        try! realm.write {
            realmTimerModel.isTimerRunning = false
            realmTimerModel.estimateDate = nil
            self.realm.add(realmTimerModel, update: true)
        }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["\(identifier)"])
    }
    
    func pause() {
        timer.invalidate()
        isTimerRunning = false
        self.resumeTapped = true
        
        try! realm.write {
            realmTimerModel.isTimerRunning = false
            realmTimerModel.isResumeTapped = true
            realmTimerModel.timeFromPause = temp
            self.realm.add(realmTimerModel, update: true)
        }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["\(identifier)"])
    }
    
    func pauseFromBackground() {
        delegate?.updateTimer(seconds: realmTimerModel.timeFromPause)
        isFromBackground = true
    }
    
    func resume() {
        runTimer()
        isTimerRunning = true
        self.resumeTapped = false
        
        try! realm.write {
            realmTimerModel.isResumeTapped = false
            realmTimerModel.isTimerRunning = true
            self.realm.add(realmTimerModel, update: true)
        }
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(temp), repeats: false)
        let request = UNNotificationRequest(identifier: "\(identifier)", content: notificationContent, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
        time = TimeInterval(temp)
        estimateTime = Date(timeIntervalSinceNow: time)
        isTimerRunning = true
        
        
        try! realm.write {
            realmTimerModel.estimateDate = estimateTime!
            realmTimerModel.isTimerRunning = true
            self.realm.add(realmTimerModel, update: true)
        }
    }
    
    func runTimerFromBackground() {
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
        time = TimeInterval(realmTimerModel.timeFromPause)
        if realmTimerModel.isResumeTapped {
            estimateTime = Date(timeIntervalSinceNow: time)

        }
        isTimerRunning = true
        
        try! realm.write {
            realmTimerModel.estimateDate = estimateTime!
            realmTimerModel.isTimerRunning = true
            self.realm.add(realmTimerModel, update: true)
        }
    }
    
    func resumeTappedFromBackground() {
        runTimerFromBackground()
        isTimerRunning = true
        self.resumeTapped = false
        
        try! realm.write {
            realmTimerModel.isResumeTapped = false
            realmTimerModel.isTimerRunning = true
            self.realm.add(realmTimerModel, update: true)
        }
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(realmTimerModel.timeFromPause), repeats: false)
        let request = UNNotificationRequest(identifier: "\(identifier)", content: notificationContent, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        isFromBackground = false
    }
    
    @objc func updateTimer() {
        let last = estimateTime?.timeIntervalSinceNow
        let intValue = Int(last!) + 1
        temp = intValue
        
        if intValue < 1 {
            delegate?.updateTimer(seconds: 0)
            timer.invalidate()
            temp = seconds
            isTimerRunning = false
            
            try! realm.write {
                realmTimerModel.isTimerRunning = false
                realmTimerModel.estimateDate = nil
                self.realm.add(realmTimerModel, update: true)
            }
            
        } else {
            delegate?.updateTimer(seconds: intValue)
        }
    }
}

protocol TimerDelegate {
    func updateTimer(seconds: Int)
}

