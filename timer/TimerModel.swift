//
//  Timer.swift
//  timer
//
//  Created by Yuriy borisov on 08.05.2018.
//  Copyright © 2018 demo. All rights reserved.
//

import Foundation
import UserNotifications

class TimerModel {
    var seconds: Int
    var timer = Timer()
    var temp: Int = 0
    var time = TimeInterval(0)
    var estimateTime: Date?
    let identifier = UUID().uuidString
    var delegate: TimerDelegate?
    var notificationContent: UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = "Title"
        content.body = "\(seconds)"
        content.sound = UNNotificationSound(named: "test2.wav")
        return content
    }
    
    var isTimerRunning = false
    var resumeTapped = false
    
    init(seconds: Int) {
        self.seconds = seconds
        self.temp = seconds
    }
    
    func start() {
        temp = seconds
        runTimer()
        
//        let content = UNMutableNotificationContent()
//        content.title = "Title"
//        content.body = "\(seconds)"
//        content.sound = UNNotificationSound(named: "test2.wav")
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(seconds), repeats: false)
        let request = UNNotificationRequest(identifier: "\(identifier)", content: notificationContent, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func stop() {
        temp = seconds
        timer.invalidate()
        isTimerRunning = false
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["\(identifier)"])
    }
    
    func pause() {
        timer.invalidate()
        isTimerRunning = false
        self.resumeTapped = true
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["\(identifier)"])
    }
    
    func resume() {
        runTimer()
        isTimerRunning = true
        self.resumeTapped = false
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(temp), repeats: false)
        let request = UNNotificationRequest(identifier: "\(identifier)", content: notificationContent, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
        time = TimeInterval(temp)
        estimateTime = Date(timeIntervalSinceNow: time)
        isTimerRunning = true
    }
    
    @objc func updateTimer() {
        let last = estimateTime?.timeIntervalSinceNow
        let intValue = Int(last!) + 1
        temp = intValue
        
        if intValue < 1 {
            timer.invalidate()
            temp = seconds
            isTimerRunning = false
            
            delegate?.updateTimer(seconds: 0)
        } else {
            delegate?.updateTimer(seconds: intValue)
        }
    }
}

protocol TimerDelegate {
    func updateTimer(seconds: Int)
}

