//
//  AppDelegate.swift
//  Bitmoji
//
//  Created by Jake on 2/10/18.
//  Copyright © 2018 Jake. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
        let mainViewController = MainViewController()
        window?.rootViewController = mainViewController
        return true
    }

}

