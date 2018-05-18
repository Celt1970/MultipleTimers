//
//  AppDelegate.swift
//  timer
//
//  Created by demo on 03.05.2018.
//  Copyright © 2018 demo. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let mainVC = CollectionVC()
        mainVC.view.backgroundColor = .white
        let navigationController = UINavigationController(rootViewController: mainVC)
        navigationController.navigationBar.isTranslucent = false
        UINavigationBar.appearance().tintColor = CustomColors.myYellow
        UINavigationBar.appearance().barTintColor = CustomColors.backColor
        navigationController.navigationBar.addBorder(toSide: .Bottom, withColor: CustomColors.backColor.cgColor, andThickness: 3.0)
        navigationController.navigationBar.layer.masksToBounds = false
        navigationController.navigationBar.layer.shadowColor = UIColor.black.cgColor
        navigationController.navigationBar.layer.shadowOpacity = 0.5
        navigationController.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        navigationController.navigationBar.layer.shadowRadius = 5
        UIApplication.shared.statusBarStyle = .lightContent
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            print("granted: \(granted)")
        }
        UNUserNotificationCenter.current().delegate = self

        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
       
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
       
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
      
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
    }


}

extension UIView {
    
    // Example use: myView.addBorder(toSide: .Left, withColor: UIColor.redColor().CGColor, andThickness: 1.0)
    
    enum ViewSide {
        case Left, Right, Top, Bottom
    }
    
    func addBorder(toSide side: ViewSide, withColor color: CGColor, andThickness thickness: CGFloat) {
        
        let border = CALayer()
        border.backgroundColor = color
        
        switch side {
        case .Left: border.frame = CGRect(x: frame.minX, y: frame.minY, width: thickness, height: frame.height); break
        case .Right: border.frame = CGRect(x: frame.maxX, y: frame.minY, width: thickness, height: frame.height); break
        case .Top: border.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: thickness); break
        case .Bottom: border.frame = CGRect(x: frame.minX, y: frame.maxY, width: frame.width, height: thickness); break
        }
        
        layer.addSublayer(border)
    }
}

