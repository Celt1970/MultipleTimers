//
//  CollectionViewCell.swift
//  timer
//
//  Created by demo on 05.05.2018.
//  Copyright © 2018 demo. All rights reserved.
//

import UIKit
import UserNotifications

let backColor = UIColor(red: 57/255, green: 70/255, blue: 86/255, alpha: 1)
let borderColor = UIColor(red: 107/255, green: 131/255, blue: 153/255, alpha: 1)
let myGreen = UIColor(red: 115/255, green: 177/255, blue: 95/255, alpha: 1)
let myYellow = UIColor(red: 237/255, green: 203/255, blue: 96/255, alpha: 1)

class CollectionViewCell: UICollectionViewCell, TimerDelegate {
    
    
    var timerModel: TimerModel?
    var height: CGFloat = 0.0
    
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
        
        
        commentLabel.textAlignment = NSTextAlignment.center
        commentLabel.numberOfLines = 0
        
        timerLabel.textAlignment = NSTextAlignment.left
        
        startButton.setAttributedTitle(NSAttributedString(string: "START", attributes: [NSAttributedStringKey.font : UIFont(name: "Helvetica Bold", size: 14)!, NSAttributedStringKey.foregroundColor : myGreen]), for: .normal)
        startButton.backgroundColor = backColor
        startButton.addTarget(self, action: #selector(startButtonTapped(_:)), for: .touchUpInside)
        startButton.layer.cornerRadius = 15.0
        startButton.layer.borderWidth = 3.0
        startButton.layer.borderColor = myGreen.cgColor
        startButton.layer.masksToBounds = true
        
        
        pauseButton.setAttributedTitle(NSAttributedString(string: "PAUSE", attributes: [NSAttributedStringKey.font : UIFont(name: "Helvetica Bold", size: 14)!, NSAttributedStringKey.foregroundColor : borderColor]), for: .normal)
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
        
        let stackWithComment = UIStackView(arrangedSubviews: [wholeStack, commentLabel])
        stackWithComment.axis = .vertical
        stackWithComment.distribution = .fillProportionally
        stackWithComment.alignment = .fill
        stackWithComment.spacing = 10
        stackWithComment.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackWithComment)
        
        contentView.addConstraints([
            NSLayoutConstraint(item: stackWithComment, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 12),
            NSLayoutConstraint(item: stackWithComment, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant:-12),
            NSLayoutConstraint(item: stackWithComment, attribute: .leading , relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 15),
            NSLayoutConstraint(item: stackWithComment, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1, constant:-15),
            NSLayoutConstraint(item: wholeStack, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: UIScreen.main.bounds.height / 11),
            NSLayoutConstraint(item: stackWithComment, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: UIScreen.main.bounds.width - 60)
            ])
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    @objc func startButtonTapped(_ sender: UIButton) {
        if timerModel?.isTimerRunning == false {
            timerModel?.start()
            
            startButtonIsStopped()
            
            pauseButton.layer.borderColor = myYellow.cgColor
            pauseButton.setAttributedTitle(NSAttributedString(string: "PAUSE", attributes: [NSAttributedStringKey.font : UIFont(name: "Helvetica Bold", size: 14)!, NSAttributedStringKey.foregroundColor : myYellow]), for: .normal)
        } else {
            timerModel?.stop()
            
            timerLabel.attributedText = NSAttributedString(string: (timeString(time: TimeInterval((timerModel?.temp)!))), attributes: labelAttributes)
            startButton.setAttributedTitle(NSAttributedString(string: "START", attributes: [NSAttributedStringKey.font : UIFont(name: "Helvetica Bold", size: 14)!, NSAttributedStringKey.foregroundColor : myGreen]), for: .normal)
            startButton.backgroundColor = backColor
            pauseButton.backgroundColor = backColor
            pauseButton.layer.borderColor = borderColor.cgColor
            pauseButton.setAttributedTitle(NSAttributedString(string: "PAUSE", attributes: [NSAttributedStringKey.font : UIFont(name: "Helvetica Bold", size: 14)!, NSAttributedStringKey.foregroundColor : borderColor]), for: .normal)

            timerModel?.isTimerRunning = false
            
        }
    }
    
    func runTimer() {
        timerModel?.runTimer()
        pauseButton.isEnabled = true
    }
    
    func startButtonIsStopped() {
        startButton.setAttributedTitle(NSAttributedString(string: "STOP", attributes: [NSAttributedStringKey.font : UIFont(name: "Helvetica Bold", size: 14)!, NSAttributedStringKey.foregroundColor : backColor]), for: .normal)
        startButton.backgroundColor = myGreen
        
    }
    
    func runTimerFromBackground() {
        timerModel?.runTimerFromBackground()
        pauseButton.isEnabled = true
        startButtonIsStopped()
        
        pauseButton.layer.borderColor = myYellow.cgColor
        pauseButton.setAttributedTitle(NSAttributedString(string: "PAUSE", attributes: [NSAttributedStringKey.font : UIFont(name: "Helvetica Bold", size: 14)!, NSAttributedStringKey.foregroundColor : myYellow]), for: .normal)
    }
    
    func pauseFromBackground() {
        timerModel?.pauseFromBackground()
        pauseButton.setAttributedTitle(NSAttributedString(string: "GO", attributes: [NSAttributedStringKey.font : UIFont(name: "Helvetica Bold", size: 14)!, NSAttributedStringKey.foregroundColor : backColor]), for: .normal)
        pauseButton.backgroundColor = myYellow
        pauseButton.layer.borderColor = myYellow.cgColor
        startButtonIsStopped()
    }
    
    @objc func pauseButtonTapped(_ sender: UIButton) {
        if timerModel?.isFromBackground == true{
            timerModel?.resumeTappedFromBackground()
            pauseButton.setAttributedTitle(NSAttributedString(string: "PAUSE", attributes: [NSAttributedStringKey.font : UIFont(name: "Helvetica Bold", size: 14)!, NSAttributedStringKey.foregroundColor : myYellow]), for: .normal)
            pauseButton.backgroundColor = backColor
            pauseButton.layer.borderColor = myYellow.cgColor
            return
        }
        if timerModel?.resumeTapped == false {
            timerModel?.pause()
            pauseButton.setAttributedTitle(NSAttributedString(string: "GO", attributes: [NSAttributedStringKey.font : UIFont(name: "Helvetica Bold", size: 14)!, NSAttributedStringKey.foregroundColor : backColor]), for: .normal)
            pauseButton.backgroundColor = myYellow
            pauseButton.layer.borderColor = myYellow.cgColor
        } else {
            timerModel?.resume()
            pauseButton.setAttributedTitle(NSAttributedString(string: "PAUSE", attributes: [NSAttributedStringKey.font : UIFont(name: "Helvetica Bold", size: 14)!, NSAttributedStringKey.foregroundColor : myYellow]), for: .normal)
            pauseButton.backgroundColor = backColor
            pauseButton.layer.borderColor = myYellow.cgColor
        }
    }
    
    func updateTimer(seconds: Int) {
        timerLabel.attributedText = NSAttributedString(string: timeString(time: TimeInterval(seconds)), attributes: labelAttributes)
        if seconds == 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { [weak self] in
                self?.timerLabel.attributedText = NSAttributedString(string: (self?.timeString(time: TimeInterval((self?.timerModel?.seconds)!)))!, attributes: self?.labelAttributes)
                self?.startButton.setAttributedTitle(NSAttributedString(string: "START", attributes: [NSAttributedStringKey.font : UIFont(name: "Helvetica Bold", size: 14)!, NSAttributedStringKey.foregroundColor : myGreen]), for: .normal)
                self?.startButton.backgroundColor = backColor
                self?.pauseButton.setAttributedTitle(NSAttributedString(string: "PAUSE", attributes: [NSAttributedStringKey.font : UIFont(name: "Helvetica Bold", size: 14)!, NSAttributedStringKey.foregroundColor : borderColor]), for: .normal)
                self?.pauseButton.backgroundColor = backColor
                self?.pauseButton.layer.borderColor = borderColor.cgColor
            })
        }
    }
    
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    
    override func layoutSubviews() {
        commentLabel.preferredMaxLayoutWidth = (UIScreen.main.bounds.width / 3) * 2
        super.layoutSubviews()
        height = 24 + 66 + 10 + commentLabel.bounds.size.height
        print("Height is: \(height)")
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        print("Height in updateConstraints is: \(height)")

    }

}

