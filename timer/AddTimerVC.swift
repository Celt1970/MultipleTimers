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
    var delegate: AddTimerDelegate?
    let addButton = UIButton()
    let commentField = UITextField()
    
    var picker = TimePicker()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configureGestures()
        self.view.backgroundColor = CustomColors.backColor
//        configUI()
        picker.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(picker)
        
        commentField.translatesAutoresizingMaskIntoConstraints = false
        commentField.textAlignment = .center
        
        
        commentField.font = UIFont(name: "Helvetica", size: 21)
        commentField.textColor = CustomColors.borderColor
        commentField.backgroundColor = CustomColors.backColor
        commentField.layer.borderColor = CustomColors.borderColor.cgColor
        commentField.layer.borderWidth = 3
        commentField.layer.cornerRadius = 15
        commentField.addTarget(self, action: #selector(buttonPressed(_:)), for: UIControlEvents.primaryActionTriggered)
        self.view.addSubview(commentField)
        
        addButton.setAttributedTitle(NSAttributedString(string: "ADD TIMER", attributes: [NSAttributedStringKey.font : UIFont(name: "Helvetica Bold", size: 20), NSAttributedStringKey.foregroundColor : CustomColors.myYellow]), for: .normal )
        addButton.layer.borderColor = CustomColors.myYellow.cgColor
        addButton.layer.borderWidth = 4.0
        addButton.layer.cornerRadius = 5.0
        addButton.backgroundColor = CustomColors.backColor
        addButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(addButton)
        
        self.view.addConstraints([
            NSLayoutConstraint(item: picker, attribute: .top, relatedBy: .equal, toItem: commentField, attribute: .top, multiplier: 1, constant: 50),
            NSLayoutConstraint(item: picker, attribute: .leading, relatedBy: .equal, toItem: self.view , attribute: .leading, multiplier: 1, constant: 20),
            NSLayoutConstraint(item: picker, attribute: .trailing, relatedBy: .equal , toItem: self.view , attribute: .trailing, multiplier: 1 , constant: -20),
            NSLayoutConstraint(item: picker, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: UIScreen.main.bounds.height / 2),
            NSLayoutConstraint(item: addButton, attribute: .centerX, relatedBy: .equal, toItem: self.view , attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: commentField, attribute: .top, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 10),
            NSLayoutConstraint(item: commentField, attribute: .leading, relatedBy: .equal, toItem: self.view , attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: commentField, attribute: .trailing, relatedBy: .equal, toItem: self.view , attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: commentField, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 70),
            NSLayoutConstraint(item: addButton, attribute: .bottom, relatedBy: .equal, toItem: self.view , attribute: .bottom, multiplier: 1, constant: -50),
            NSLayoutConstraint(item: addButton, attribute: .width , relatedBy: .equal, toItem: nil , attribute: .notAnAttribute, multiplier: 1, constant: 200)
            ])
    }

    func getHourFromDatePicker(datePicker:UIDatePicker) -> Int {
        let date = datePicker.date
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.hour, .minute, .second], from: date)
        let time = Int(components.hour! * 60 * 60) + Int(components.minute! * 60)

        return time
    }
    
    func configureGestures() {
        let tap: UIGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc func buttonPressed(_ sender: UIButton) {
        
        let intValue = picker.getTime()
        let model = RealmTimerModel()
        model.seconds = intValue
        if commentField.text?.isEmpty != true {
//            timer?.comment = commentField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            model.comment = commentField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        timer = TimerModel(seconds: intValue, timerModel: model)
        
        delegate?.addTimerToList(timer: timer!)
        self.navigationController?.popViewController(animated: true)
    }
  
}
