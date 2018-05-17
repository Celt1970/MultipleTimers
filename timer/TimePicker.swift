//
//  TimePicker.swift
//  timer
//
//  Created by Yuriy borisov on 10.05.2018.
//  Copyright © 2018 demo. All rights reserved.
//

import UIKit

class TimePicker: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let hours = Array(0...24)
    let minutes = Array(0...59)
    let seconds = Array(0...59)
    let pickerRows = 10000
    var pickerTime = Time(hours: 0, minutes: 0, seconds: 0)
    var loopMargin = 40
    
    private var foregroundColorForPicker = CustomColors.myYellow
    
    
    func getTime() -> Int {
        return pickerTime.wholeTime
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return loopMargin * hours.count
        default:
            return loopMargin * minutes.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        switch component{
        case 0:
            let hour = hours[row % hours.count]
            let attrString = NSAttributedString(string: String(hour), attributes: [NSAttributedStringKey.foregroundColor : foregroundColorForPicker])
            return attrString
        default:
            let minutesAndSeonds = minutes[row % minutes.count]
            let attrString = NSAttributedString(string: String(minutesAndSeonds), attributes: [NSAttributedStringKey.foregroundColor : foregroundColorForPicker])
            return attrString
        }
    }
    
    func setForegroundColor(_ color: UIColor) {
        self.foregroundColorForPicker = color
        self.setPickerLabels()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            let currnetIndex = row % hours.count
            self.selectRow((loopMargin / 2) * hours.count + currnetIndex, inComponent: 0, animated: false)
            pickerTime.hours = currnetIndex
        case 1:
            let currnetIndex = row % minutes.count
            self.selectRow((loopMargin / 2) * minutes.count + currnetIndex, inComponent: 1, animated: false)
            pickerTime.minutes = currnetIndex
            
        default :
            let currnetIndex = row % minutes.count
            self.selectRow((loopMargin / 2) * minutes.count + currnetIndex, inComponent: 2, animated: false)
            pickerTime.seconds = currnetIndex
            
        }
        
        
    }
    
    func setPickerLabels() {
        let label1 = UILabel()
        label1.text = "hrs"
        label1.textColor = foregroundColorForPicker
        let label2 = UILabel()
        label2.text = "min"
        label2.textColor = foregroundColorForPicker
        let label3 = UILabel()
        label3.text = "sec"
        label3.textColor = foregroundColorForPicker
        
        
        let labels = [0 : label1, 1 : label2, 2 : label3]
        
        let fontSize:CGFloat = 20
        let labelWidth:CGFloat = UIScreen.main.bounds.width / CGFloat(self.numberOfComponents)
        let x:CGFloat = UIScreen.main.bounds.origin.x
        let y:CGFloat = (UIScreen.main.bounds.size.height / 4) - (fontSize / 2)
        print(y)
        
        for i in 0...self.numberOfComponents {
            
            if let label = labels[i] {
                
                if self.subviews.contains(label) {
                    label.removeFromSuperview()
                }
                
                label.frame = CGRect(x: x + labelWidth * CGFloat(i) - 30, y: y, width: labelWidth, height: fontSize)
                label.font = UIFont.boldSystemFont(ofSize: fontSize)
                label.backgroundColor = .clear
                label.textAlignment = NSTextAlignment.right
                
            }
            
        }
        
        let stack = UIStackView(arrangedSubviews: [label1, label2, label3])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .fill
        
        self.addSubview(stack)
        
        self.addConstraints([
            NSLayoutConstraint(item: stack, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: stack, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: stack, attribute: .trailing, relatedBy: .equal, toItem: self , attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: stack, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20)
            ])
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate = self
        self.dataSource = self
        self.setPickerLabels()
        self.selectRow((loopMargin / 2) * hours.count, inComponent: 0, animated: false)
        self.selectRow((loopMargin / 2) * minutes.count, inComponent: 1, animated: false)
        self.selectRow((loopMargin / 2) * minutes.count, inComponent: 2, animated: false)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    struct Time {
        var hours: Int
        var minutes: Int
        var seconds: Int
        var wholeTime: Int {
            return (hours * 60 * 60) + (minutes * 60) + seconds
        }
    }
}

