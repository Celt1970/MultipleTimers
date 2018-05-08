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
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let mainVC = CollectionVC()
        mainVC.view.backgroundColor = .white
        let navigationController = UINavigationController(rootViewController: mainVC)
        navigationController.navigationBar.isTranslucent = false
        UINavigationBar.appearance().tintColor = myYellow
        UINavigationBar.appearance().barTintColor = backColor
        UIApplication.shared.statusBarStyle = .lightContent
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            print("granted: \(granted)")
        }
        
        return true
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

