//
//  CollectionVC.swift
//  timer
//
//  Created by demo on 05.05.2018.
//  Copyright © 2018 demo. All rights reserved.
//

import UIKit

class CollectionVC: UIViewController {
    
    var colletionView: UICollectionView?
    var timers = [TimerModel]() {
        didSet{
            self.colletionView?.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addTimerButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBtnTapped))
        self.navigationItem.rightBarButtonItem = addTimerButton
        
        let flowLayout = UICollectionViewFlowLayout()
        colletionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        colletionView?.backgroundColor = backColor
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
    }
    @objc func addBtnTapped() {
        let nextVC = AddTimerVC()
        nextVC.delegate = self
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}

extension CollectionVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, AddTimerDelegate {
    func addTimerToList(timer: TimerModel) {
        self.timers.append(timer)
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return timers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCollectionCell", for: indexPath) as! CollectionViewCell
        let timer = timers[indexPath.row]
        cell.timerModel = timer
        cell.timerModel?.delegate = cell
        cell.timerModel = timers[indexPath.row]
        cell.timerLabel.attributedText = NSAttributedString(string: cell.timeString(time: TimeInterval((cell.timerModel?.seconds)!)), attributes: cell.labelAttributes)

//        cell.timerLabel.attributedText = NSAttributedString(string: cell.timeString(time: TimeInterval(timers[indexPath.row].seconds)), attributes: cell.labelAttributes)
//        cells.append(cell)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 20, height: 90)

    }
}

protocol AddTimerDelegate {
    func addTimerToList(timer: TimerModel)
}
