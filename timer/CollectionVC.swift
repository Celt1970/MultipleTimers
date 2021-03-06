//
//  CollectionVC.swift
//  timer
//
//  Created by demo on 05.05.2018.
//  Copyright © 2018 demo. All rights reserved.
//

import UIKit
import UserNotifications
import RealmSwift


class CollectionVC: UIViewController {
    
    var colletionView: UICollectionView?
    var sizingCell: CollectionViewCell = CollectionViewCell()
    var heights = [CGFloat]()
    var realm = try! Realm()
    
    var timers = [TimerModel]()
    var timersToRemove = [IndexPath]()
    
    var addTimerButton = UIBarButtonItem()
    var editingButton = UIBarButtonItem()
    var deleteButton = UIBarButtonItem()
    var cancelButton = UIBarButtonItem()
    
    lazy var timersToo: Results<RealmTimerModel> = {self.realm.objects(RealmTimerModel.self)}()
    
    var isEditingPressed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setModel()
        addTimerButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBtnTapped))
        editingButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editingButtonPressed))
        deleteButton = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(deleteSelectedItems))
        cancelButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(cancelButtonPressed))
        
        self.navigationItem.rightBarButtonItem = addTimerButton
        self.navigationItem.leftBarButtonItem = editingButton
        
        let flowLayout = UICollectionViewFlowLayout()
        colletionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        colletionView?.backgroundColor = CustomColors.backColor
        colletionView?.register(CollectionViewCell.self , forCellWithReuseIdentifier: "myCollectionCell")
        colletionView?.delegate = self
        colletionView?.dataSource = self
        colletionView?.allowsSelection = false
        colletionView?.allowsMultipleSelection = false
        
        self.view.addSubview(colletionView!)
        colletionView?.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints([
            NSLayoutConstraint(item: colletionView, attribute: .top, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: colletionView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: colletionView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: colletionView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: 0),
            ])
        flowLayout.estimatedItemSize = CGSize(width: 1, height: 1)
        
    }
    
    func setModel() {
        for timer in timersToo {
            let timerModel = TimerModel(seconds: timer.seconds, timerModel: timer)
            timers.append(timerModel)
        }
    }
    
    @objc func addBtnTapped() {
        let nextVC = AddTimerVC()
        nextVC.delegate = self
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func editingButtonPressed() {
        
        self.navigationItem.leftBarButtonItem = cancelButton
        self.navigationItem.rightBarButtonItem = deleteButton
        self.colletionView?.allowsSelection = true
        self.colletionView?.allowsMultipleSelection = true
        isEditingPressed = true
        
        for item in (colletionView?.visibleCells)! {
            if item is CollectionViewCell {
                let newItem = item as! CollectionViewCell
                newItem.shakeCell()
            }
        }
        timers.forEach({$0.isShaking = true})
    }
    
    @objc func deleteSelectedItems() {
        for index in timersToRemove.sorted(by:>) {
            timers[index.row].deleteTimer()
            timers.remove(at: index.row)
        }
        colletionView?.deleteItems(at: timersToRemove)
        timersToRemove = [IndexPath]()
        cancelButtonPressed()
    }
    
    @objc func cancelButtonPressed() {
        self.navigationItem.leftBarButtonItem = editingButton
        self.navigationItem.rightBarButtonItem = addTimerButton
        self.colletionView?.allowsMultipleSelection = false
        self.colletionView?.allowsSelection = false
        isEditingPressed = false
        
        for item  in (colletionView?.visibleCells)!  {
            if item is CollectionViewCell {
                item.contentView.layer.borderColor = CustomColors.borderColor.cgColor
                let newitem = item as! CollectionViewCell
                newitem.stopShaking()
            }
        }
        timers.forEach({$0.isShaking = false; $0.isSelected = false})
    }
}

extension CollectionVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, AddTimerDelegate  {
    
    func addTimerToList(timer: TimerModel) {
        self.timers.append(timer)
        self.colletionView?.insertItems(at: [IndexPath(row: timers.count - 1, section: 0)])
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return timers.count
    }
    
    func configureCell (_ cell: CollectionViewCell, at indexPath: IndexPath) {
        cell.timerModel = timers[indexPath.row]
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = self.colletionView?.cellForItem(at: indexPath) as! CollectionViewCell
        cell.contentView.layer.borderColor = CustomColors.borderColor.cgColor
        timers[indexPath.row].isSelected = false
        for (index, timer) in timersToRemove.enumerated() {
            if timer == indexPath {
                timersToRemove.remove(at: index)
                break
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = self.colletionView?.cellForItem(at: indexPath) as! CollectionViewCell
        cell.contentView.layer.borderColor = CustomColors.myYellow.cgColor
        timers[indexPath.row].isSelected = true
        timersToRemove.append(indexPath)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCollectionCell", for: indexPath) as! CollectionViewCell
        let timer = timers[indexPath.row]
        cell.timerModel = timer
        cell.timerModel?.delegate = cell
        cell.timerModel = timers[indexPath.row]
        cell.timerLabel.attributedText = NSAttributedString(string: cell.timeString(time: TimeInterval(timers[indexPath.row].seconds)), attributes: cell.labelAttributes)
        if cell.timerModel?.comment != nil {
            cell.commentLabel.attributedText = NSAttributedString(string: "\(cell.timerModel!.comment!)", attributes: [NSAttributedStringKey.font : UIFont(name: "Helvetica", size: 20), NSAttributedStringKey.foregroundColor : CustomColors.borderColor])
            
        } else {
            cell.commentLabel.attributedText = NSAttributedString(string: "", attributes: [NSAttributedStringKey.font : UIFont(name: "Helvetica", size: 20), NSAttributedStringKey.foregroundColor : CustomColors.borderColor])
        }
        
        if (cell.timerModel?.realmTimerModel.isTimerRunning)! {
            cell.runTimerFromBackground()
            cell.pauseButton.isEnabled = true
        } else if (cell.timerModel?.realmTimerModel.isResumeTapped)! {
            cell.pauseFromBackground()
            cell.pauseButton.isEnabled = true
        } else {
            cell.pauseButton.isEnabled = false
        }
        
        if (cell.timerModel?.isShaking)! {
            cell.shakeCell()
        } else {
            cell.stopShaking()
        }
        if cell.isSelected == false {
            cell.contentView.layer.borderColor = CustomColors.borderColor.cgColor
        } else {
            cell.contentView.layer.borderColor = CustomColors.myYellow.cgColor
        }
        
        //        print(Realm.Configuration.defaultConfiguration.fileURL)
        
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
    }
    
    
}

protocol AddTimerDelegate {
    func addTimerToList(timer: TimerModel)
}
