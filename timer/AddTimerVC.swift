//
//  AddTimerVC.swift
//  timer
//
//  Created by demo on 03.05.2018.
//  Copyright © 2018 demo. All rights reserved.
//

import UIKit

class AddTimerVC: UIViewController {
    
    var timer: TimerModel?
    let fiveSecondsBtn = UIButton()
    let tenSecondsBtn = UIButton()
    let fifteenSecondsBtn = UIButton()
    let twelveSecondsBtn = UIButton()
    var delegate: AddTimerDelegate?
    let addButton = UIButton()
    
    var picker = UIDatePicker()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = backColor
//        configUI()
        picker.datePickerMode = .countDownTimer
        picker.setValue(myYellow, forKey: "textColor")
        
        picker.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(picker)
        
        addButton.setAttributedTitle(NSAttributedString(string: "ADD TIMER", attributes: [NSAttributedStringKey.font : UIFont(name: "Helvetica Bold", size: 20), NSAttributedStringKey.foregroundColor : myYellow]), for: .normal )
        addButton.layer.borderColor = myYellow.cgColor
        addButton.layer.borderWidth = 4.0
        addButton.layer.cornerRadius = 5.0
        addButton.backgroundColor = backColor
        addButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(addButton)
        
        self.view.addConstraints([
            NSLayoutConstraint(item: picker, attribute: .top, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 20),
            NSLayoutConstraint(item: picker, attribute: .leading, relatedBy: .equal, toItem: self.view , attribute: .leading, multiplier: 1, constant: 20),
            NSLayoutConstraint(item: picker, attribute: .trailing, relatedBy: .equal , toItem: self.view , attribute: .trailing, multiplier: 1 , constant: -20),
            NSLayoutConstraint(item: picker, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: UIScreen.main.bounds.height / 2),
            NSLayoutConstraint(item: addButton, attribute: .centerX, relatedBy: .equal, toItem: self.view , attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: addButton, attribute: .bottom, relatedBy: .equal, toItem: self.view , attribute: .bottom, multiplier: 1, constant: -50),
            NSLayoutConstraint(item: addButton, attribute: .width , relatedBy: .equal, toItem: nil , attribute: .notAnAttribute, multiplier: 1, constant: 200)
            ])
    }

    func getHourFromDatePicker(datePicker:UIDatePicker) -> Int
    {
        let date = datePicker.date
        
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.hour, .minute, .second], from: date)
        let time = Int(components.hour! * 60 * 60) + Int(components.minute! * 60)
        

        return time
    }
    
    
    func configUI() {
        
        fiveSecondsBtn.setTitle("5 minutes", for: .normal)
        fiveSecondsBtn.setTitleColor(.red, for: .normal)
        fiveSecondsBtn.backgroundColor = .blue
        fiveSecondsBtn.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        
        tenSecondsBtn.setTitle("10 minutes", for: .normal)
        tenSecondsBtn.setTitleColor(.blue, for: .normal)
        tenSecondsBtn.backgroundColor = .red
        tenSecondsBtn.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)

        fifteenSecondsBtn.setTitle("15 minutes", for: .normal)
        fifteenSecondsBtn.setTitleColor(.blue, for: .normal)
        fifteenSecondsBtn.backgroundColor = .red
        fifteenSecondsBtn.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)

        twelveSecondsBtn.setTitle("20 minutes", for: .normal)
        twelveSecondsBtn.setTitleColor(.red, for: .normal)
        twelveSecondsBtn.backgroundColor = .blue
        twelveSecondsBtn.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)

        
        let fiveAndTenStack = UIStackView(arrangedSubviews: [fiveSecondsBtn, tenSecondsBtn])
        let fifteenAndTwelveStack = UIStackView(arrangedSubviews: [fifteenSecondsBtn, twelveSecondsBtn])
        let wholeStack = UIStackView(arrangedSubviews: [fiveAndTenStack, fifteenAndTwelveStack])
        
        fiveAndTenStack.axis = .horizontal
        fiveAndTenStack.distribution = .fillEqually
        fiveAndTenStack.alignment = .fill
        
        fifteenAndTwelveStack.axis = .horizontal
        fifteenAndTwelveStack.distribution = .fillEqually
        fifteenAndTwelveStack.alignment = .fill
        
        wholeStack.axis = .vertical
        wholeStack.distribution = .fillEqually
        wholeStack.alignment = .fill
        
        let wholeStackWidth = CGFloat.minimum(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
        
        wholeStack.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(wholeStack)
        
        self.view.addConstraints([
            NSLayoutConstraint(item: wholeStack, attribute: .centerX, relatedBy: .equal, toItem: self.view , attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: wholeStack, attribute: .centerY, relatedBy: .equal, toItem: self.view , attribute: .centerY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: wholeStack, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: wholeStackWidth - 100),
            NSLayoutConstraint(item: wholeStack, attribute: .height  , relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: wholeStackWidth - 100)
            ])
        
    }
    
    @objc func buttonPressed(_ sender: UIButton) {
        
        let intValue = getHourFromDatePicker(datePicker: picker)
        timer = TimerModel(seconds: intValue)
        delegate?.addTimerToList(timer: timer!)
        self.navigationController?.popViewController(animated: true)
    }
  
}
