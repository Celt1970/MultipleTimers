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
    
    var timers = [TimerModel]() {
        didSet{
            self.colletionView?.reloadData()
        }
    }
    
    lazy var timersToo: Results<RealmTimerModel> = {self.realm.objects(RealmTimerModel.self)}()

    override func viewDidLoad() {
        super.viewDidLoad()
        setModel()
        

        let addTimerButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBtnTapped))
        self.navigationItem.rightBarButtonItem = addTimerButton
        
        let flowLayout = UICollectionViewFlowLayout()
        colletionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        colletionView?.backgroundColor = CustomColors.backColor
        colletionView?.register(CollectionViewCell.self , forCellWithReuseIdentifier: "myCollectionCell")
        colletionView?.delegate = self
        colletionView?.dataSource = self

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
}

extension CollectionVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, AddTimerDelegate  {
   
    func addTimerToList(timer: TimerModel) {
        self.timers.append(timer)
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
