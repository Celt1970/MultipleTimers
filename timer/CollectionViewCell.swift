//
//  CollectionViewCell.swift
//  timer
//
//  Created by demo on 05.05.2018.
//  Copyright © 2018 demo. All rights reserved.
//

import UIKit
import UserNotifications

let backColor = UIColor(red: 66/255, green: 86/255, blue: 106/255, alpha: 1)
let borderColor = UIColor(red: 107/255, green: 131/255, blue: 153/255, alpha: 1)
let myGreen = UIColor(red: 115/255, green: 177/255, blue: 95/255, alpha: 1)
let myYellow = UIColor(red: 237/255, green: 203/255, blue: 96/255, alpha: 1)

class CollectionViewCell: UICollectionViewCell, TimerDelegate {
    
    
    var timerModel: TimerModel?
    
    let timerLabel = UILabel()
    let startButton = UIButton()
    let pauseButton = UIButton()
    let resetButton = UIButton()
    let labelAttributes: [NSAttributedStringKey : Any] = [NSAttributedStringKey.font : UIFont(name: "Helvetica", size: 30)!, NSAttributedStringKey.foregroundColor : UIColor.white]
    let commentLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = backColor
        
        
        self.contentView.layer.cornerRadius = 15.0
        self.contentView.layer.borderWidth = 3.0
        self.contentView.layer.borderColor = borderColor.cgColor
        self.contentView.layer.masksToBounds = true
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 4.0)
        self.layer.shadowRadius = 5.0
        self.layer.shadowOpacity = 0.8
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
        
        commentLabel.text = "Put your ass into the void"
        commentLabel.textAlignment = NSTextAlignment.center
        
        timerLabel.textAlignment = NSTextAlignment.left
        
        startButton.setAttributedTitle(NSAttributedString(string: "START", attributes: [NSAttributedStringKey.font : UIFont(name: "Helvetica Bold", size: 15)!, NSAttributedStringKey.foregroundColor : myGreen]), for: .normal)
        startButton.backgroundColor = backColor
        startButton.addTarget(self, action: #selector(startButtonTapped(_:)), for: .touchUpInside)
        startButton.layer.cornerRadius = 15.0
        startButton.layer.borderWidth = 3.0
        startButton.layer.borderColor = myGreen.cgColor
        startButton.layer.masksToBounds = true
        
        
        pauseButton.setAttributedTitle(NSAttributedString(string: "PAUSE", attributes: [NSAttributedStringKey.font : UIFont(name: "Helvetica Bold", size: 15)!, NSAttributedStringKey.foregroundColor : borderColor]), for: .normal)
        pauseButton.backgroundColor = backColor
        pauseButton.addTarget(self, action: #selector(pauseButtonTapped(_:)), for: .touchUpInside)
        pauseButton.layer.cornerRadius = 15.0
        pauseButton.layer.borderWidth = 3.0
        pauseButton.layer.borderColor = borderColor.cgColor
        pauseButton.layer.masksToBounds = true
        
        
        
        let stackViewFoButtons = UIStackView(arrangedSubviews: [ startButton, pauseButton])
        stackViewFoButtons.axis = .horizontal
        stackViewFoButtons.distribution = .fillEqually
        stackViewFoButtons.alignment = .fill
        stackViewFoButtons.spacing = 10
        
        let wholeStack = UIStackView(arrangedSubviews: [timerLabel, stackViewFoButtons])
        wholeStack.translatesAutoresizingMaskIntoConstraints = false
        
        wholeStack.axis = .horizontal
        wholeStack.distribution = .fillEqually
        wholeStack.alignment = .fill
        wholeStack.spacing = 10
     
        contentView.addSubview(wholeStack)
        
        contentView.addConstraints([
            NSLayoutConstraint(item: wholeStack, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 12),
            NSLayoutConstraint(item: wholeStack, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant:-12),
            NSLayoutConstraint(item: wholeStack, attribute: .leading , relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 15),
            NSLayoutConstraint(item: wholeStack, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1, constant:-15),
            NSLayoutConstraint(item: wholeStack, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 65)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    @objc func startButtonTapped(_ sender: UIButton) {
        if timerModel?.isTimerRunning == false {
            timerModel?.start()
            
            startButton.setAttributedTitle(NSAttributedString(string: "STOP", attributes: [NSAttributedStringKey.font : UIFont(name: "Helvetica Bold", size: 15)!, NSAttributedStringKey.foregroundColor : backColor]), for: .normal)
            startButton.backgroundColor = myGreen
            
            pauseButton.layer.borderColor = myYellow.cgColor
            pauseButton.setAttributedTitle(NSAttributedString(string: "PAUSE", attributes: [NSAttributedStringKey.font : UIFont(name: "Helvetica Bold", size: 15)!, NSAttributedStringKey.foregroundColor : myYellow]), for: .normal)
        } else {
            timerModel?.stop()
            
            timerLabel.attributedText = NSAttributedString(string: (timeString(time: TimeInterval((timerModel?.temp)!))), attributes: labelAttributes)
            startButton.setAttributedTitle(NSAttributedString(string: "START", attributes: [NSAttributedStringKey.font : UIFont(name: "Helvetica Bold", size: 15)!, NSAttributedStringKey.foregroundColor : myGreen]), for: .normal)
            startButton.backgroundColor = backColor
            timerModel?.isTimerRunning = false
        }
    }
    
    func runTimer() {
        timerModel?.runTimer()
        pauseButton.isEnabled = true
    }
    
    @objc func pauseButtonTapped(_ sender: UIButton) {
        if timerModel?.resumeTapped == false {
            timerModel?.pause()
            //            timerModel?.resumeTapped = true
            pauseButton.setAttributedTitle(NSAttributedString(string: "GO", attributes: [NSAttributedStringKey.font : UIFont(name: "Helvetica Bold", size: 15)!, NSAttributedStringKey.foregroundColor : backColor]), for: .normal)
            pauseButton.backgroundColor = myYellow
            pauseButton.layer.borderColor = myYellow.cgColor
        } else {
            timerModel?.resume()
            pauseButton.setAttributedTitle(NSAttributedString(string: "PAUSE", attributes: [NSAttributedStringKey.font : UIFont(name: "Helvetica Bold", size: 15)!, NSAttributedStringKey.foregroundColor : myYellow]), for: .normal)
            pauseButton.backgroundColor = backColor
            pauseButton.layer.borderColor = myYellow.cgColor
        }
    }
    
    func updateTimer(seconds: Int) {
        timerLabel.attributedText = NSAttributedString(string: timeString(time: TimeInterval(seconds)), attributes: labelAttributes)
        if seconds == 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: { [weak self] in
                self?.timerLabel.attributedText = NSAttributedString(string: (self?.timeString(time: TimeInterval(seconds)))!, attributes: self?.labelAttributes)
                self?.startButton.setAttributedTitle(NSAttributedString(string: "START", attributes: [NSAttributedStringKey.font : UIFont(name: "Helvetica Bold", size: 15)!, NSAttributedStringKey.foregroundColor : myGreen]), for: .normal)
                self?.startButton.backgroundColor = backColor
            })
        }
    }
    
    
//    @objc func updateTimer() {
//        //        let last = estimateTime?.timeIntervalSinceNow
//        //        let intValue = Int(last!) + 1
//        //        temp = intValue
//        //
//        //        if intValue < 1 {
//        //            timer.invalidate()
//        //            temp = seconds
//        //            timerLabel.attributedText = NSAttributedString(string: timeString(time: TimeInterval(temp)), attributes: labelAttributes)
//        //            isTimerRunning = false
//        //            DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: { [weak self] in
//        //                self?.timerLabel.attributedText = NSAttributedString(string: (self?.timeString(time: TimeInterval((self?.temp)!)))!, attributes: self?.labelAttributes)
//        //                self?.startButton.setAttributedTitle(NSAttributedString(string: "START", attributes: [NSAttributedStringKey.font : UIFont(name: "Helvetica Bold", size: 15)!, NSAttributedStringKey.foregroundColor : myGreen]), for: .normal)
//        //                self?.startButton.backgroundColor = backColor
//        //            })
//        //            timerLabel.attributedText = NSAttributedString(string: timeString(time: 0), attributes: labelAttributes)
//        //        } else {
//        //            timerLabel.attributedText = NSAttributedString(string: timeString(time: TimeInterval(intValue)), attributes: labelAttributes)
//        //        }
//    }
    
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.timerModel?.delegate = self
    }
    
    
}

