//
//  ViewController.swift
//  timer
//
//  Created by demo on 03.05.2018.
//  Copyright © 2018 demo. All rights reserved.
//

import UIKit

class MainTableVC: UIViewController {
    var collectionView: UICollectionView?
    var cells = [TableViewCell]()
    
    let leftAndRightPaddings: CGFloat = 30.0
    let numberOfItemsPerRow: CGFloat = 1.0
    let screenSize: CGRect = UIScreen.main.bounds
    private let cellReuseIdentifier = "collectionCell"
    var items = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31"]
    var timers = [Int]() {
        didSet{
            self.collectionView?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        configNavigationBar()
    }
    
    func configNavigationBar() {
        self.navigationItem.title = "Timers"
        let addTimerButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBtnTapped))
        self.navigationItem.rightBarButtonItem = addTimerButton
    }
    
    func setTableView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 30
        flowLayout.minimumLineSpacing = 30
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        collectionView?.backgroundColor = UIColor.white
        self.view.backgroundColor = .white
        collectionView?.register(TableViewCell.self, forCellWithReuseIdentifier: "myCell")
        collectionView?.clipsToBounds = false
        
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        collectionView?.allowsSelection = false
        collectionView?.delegate = self
        collectionView?.dataSource = self
        self.view.addSubview(collectionView!)
        
        self.view.addConstraints([
            NSLayoutConstraint(item: collectionView, attribute: .top, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: collectionView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: collectionView, attribute: .leading, relatedBy: .equal, toItem: self.view , attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: collectionView, attribute: .trailing, relatedBy: .equal, toItem: self.view , attribute: .trailing, multiplier: 1, constant: 0)
            ])
        
    }
    
    @objc func addBtnTapped() {
        let nextVC = AddTimerVC()
    }
}
extension MainTableVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return timers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if cells.count - 1 >= indexPath.section {
//            let cell = cells[indexPath.section]
//            return cell
//        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! TableViewCell
            cell.seconds = timers[indexPath.section]
            cell.timerLabel.text = cell.timeString(time: TimeInterval(timers[indexPath.section]))
            cells.append(cell)
        
        
        cell.layer.shadowColor = UIColor.darkGray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 4.0)
        cell.layer.shadowRadius = 3.0
        cell.layer.shadowOpacity = 0.8
        cell.layer.masksToBounds = true
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        
        
            return cell
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (screenSize.width-leftAndRightPaddings)/numberOfItemsPerRow
        return CGSize(width: screenSize.width, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)

    }
}
//extension MainTableVC: UITableViewDelegate, UITableViewDataSource, AddTimerDelegate {
//    func addTimerToList(timer: Int) {
//        self.timers.append(timer)
//    }
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return timers.count
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if cells.count - 1 >= indexPath.section {
//            let cell = cells[indexPath.section]
//            return cell
//        } else {
//            let cell = TableViewCell()
//            cell.seconds = timers[indexPath.section]
//            cell.timerLabel.text = cell.timeString(time: TimeInterval(timers[indexPath.section]))
//            cells.append(cell)
//            return cell
//        }
//
//
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 10
//    }
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let view = UIView()
//        view.backgroundColor = UIColor.gray
//        return view
//    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 70
//    }
//}


