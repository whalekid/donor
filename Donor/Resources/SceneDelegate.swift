//
//  SceneDelegate.swift
//  Donor
//
//  Created by кит on 28/02/2020.
//  Copyright © 2020 kitaev. All rights reserved.
//

import UIKit
import RevealingSplashView

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    let revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "launch.png")!, iconInitialSize: CGSize(width: 200, height: 200), backgroundColor: .white)

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        window?.makeKeyAndVisible()
        revealingSplashView.animationType = .heartBeat
        window?.addSubview(revealingSplashView)
        revealingSplashView.startAnimation()
        guard let _ = (scene as? UIWindowScene) else { return }
        revealingSplashView.heartAttack = true
    }
    
}

