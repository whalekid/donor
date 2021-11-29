//
//  AppDelegate.swift
//  Donor
//
//  Created by кит on 28/02/2020.
//  Copyright © 2020 kitaev. All rights reserved.
//

import UIKit
import Firebase
import CoreData
import RevealingSplashView
import UserNotifications
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window : UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {

        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

}

