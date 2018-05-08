//
//  TableViewCell.swift
//  timer
//
//  Created by demo on 03.05.2018.
//  Copyright © 2018 demo. All rights reserved.
//

import UIKit
import UserNotifications

class TableViewCell: UICollectionViewCell {
    var seconds = 60
    var timer = Timer()
    var temp: Int = 0
    var time = TimeInterval(0)
    var estimateTime: Date?
    
    var isTimerRunning = false
    var resumeTapped = false
    
    let timerLabel = UILabel()
    let startButton = UIButton()
    let pauseButton = UIButton()
    let resetButton = UIButton()
    
    //    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    //        super.init(style: style, reuseIdentifier: reuseIdentifier)
    //
    //        timerLabel.text = timeString(time: TimeInterval(seconds))
    //
    //        startButton.setTitle("Start", for: .normal)
    //        startButton.setTitleColor(.red, for: .normal)
    //        startButton.backgroundColor = .yellow
    //        startButton.addTarget(self, action: #selector(startButtonTapped(_:)), for: .touchUpInside)
    //
    //        pauseButton.setTitle("Pause", for: .normal)
    //        pauseButton.setTitleColor(.blue, for: .normal)
    //        pauseButton.backgroundColor = .red
    //        pauseButton.addTarget(self, action: #selector(pauseButtonTapped(_:)), for: .touchUpInside)
    //
    //        resetButton.setTitle("Reset", for: .normal)
    //        resetButton.setTitleColor(.yellow, for: .normal)
    //        resetButton.backgroundColor = .blue
    //        resetButton.addTarget(self, action: #selector(resetButtonTapped(_:)), for: .touchUpInside)
    //
    //        let stackView = UIStackView(arrangedSubviews: [timerLabel, startButton, pauseButton, resetButton])
    //        stackView.translatesAutoresizingMaskIntoConstraints = false
    //        stackView.axis = .horizontal
    //        stackView.distribution = .fillEqually
    //        stackView.alignment = .fill
    //        stackView.spacing = 5
    //
    //        contentView.addSubview(stackView)
    //
    //        contentView.addConstraints([
    //            NSLayoutConstraint(item: stackView, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 10),
    //            NSLayoutConstraint(item: stackView, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant:-10),
    //            NSLayoutConstraint(item: stackView, attribute: .leading , relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 10),
    //            NSLayoutConstraint(item: stackView, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1, constant:-10)
    //            ])
    //
    //    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        self.contentView.layer.cornerRadius = 15
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true
        
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 4.0)
        self.layer.shadowRadius = 3.0
        self.layer.shadowOpacity = 0.8
        self.layer.masksToBounds = true
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
        
        timerLabel.text = timeString(time: TimeInterval(seconds))
        
        startButton.setTitle("Start", for: .normal)
        startButton.setTitleColor(.red, for: .normal)
        startButton.backgroundColor = .yellow
        startButton.addTarget(self, action: #selector(startButtonTapped(_:)), for: .touchUpInside)
        
        pauseButton.setTitle("Pause", for: .normal)
        pauseButton.setTitleColor(.blue, for: .normal)
        pauseButton.backgroundColor = .red
        pauseButton.addTarget(self, action: #selector(pauseButtonTapped(_:)), for: .touchUpInside)
        
        resetButton.setTitle("Reset", for: .normal)
        resetButton.setTitleColor(.yellow, for: .normal)
        resetButton.backgroundColor = .blue
        resetButton.addTarget(self, action: #selector(resetButtonTapped(_:)), for: .touchUpInside)
        
        let stackView = UIStackView(arrangedSubviews: [timerLabel, startButton, pauseButton, resetButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 5
        
        contentView.addSubview(stackView)
        
        contentView.addConstraints([
            NSLayoutConstraint(item: stackView, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 10),
            NSLayoutConstraint(item: stackView, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant:-10),
            NSLayoutConstraint(item: stackView, attribute: .leading , relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 10),
            NSLayoutConstraint(item: stackView, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1, constant:-10)
            ])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func startButtonTapped(_ sender: UIButton) {
        if isTimerRunning == false {
            runTimer()
            self.startButton.isEnabled = false
            
            
            let content = UNMutableNotificationContent()
            content.title = "Title"
            content.body = "\(seconds)"
            content.sound = UNNotificationSound(named: "test2.wav")
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(seconds), repeats: false)
            let request = UNNotificationRequest(identifier: "TestIdentifier\(seconds)", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(TableViewCell.updateTimer)), userInfo: nil, repeats: true)
        time = TimeInterval(seconds)
        estimateTime = Date(timeIntervalSinceNow: time)
        isTimerRunning = true
        pauseButton.isEnabled = true
    }
    
    @objc func pauseButtonTapped(_ sender: UIButton) {
        if self.resumeTapped == false {
            timer.invalidate()
            isTimerRunning = false
            self.resumeTapped = true
            self.pauseButton.setTitle("Resume",for: .normal)
        } else {
            runTimer()
            self.resumeTapped = false
            isTimerRunning = true
            self.pauseButton.setTitle("Pause",for: .normal)
        }
    }
    
    @objc func resetButtonTapped(_ sender: UIButton) {
        timer.invalidate()
        seconds = 60
        timerLabel.text = timeString(time: TimeInterval(seconds))
        isTimerRunning = false
        pauseButton.isEnabled = false
        startButton.isEnabled = true
    }
    
    
    @objc func updateTimer() {
        let last = estimateTime?.timeIntervalSinceNow
        let intValue = Int(last!) + 1
        
        if intValue < 1 {
            timer.invalidate()
            timerLabel.text = timeString(time: 0)
            
        } else {
            //            seconds -= 1
            timerLabel.text = timeString(time: TimeInterval(intValue))
        }
    }
    
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
}
