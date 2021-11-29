//
//  SplashViewController.swift
//  Donor
//
//  Created by кит on 29/03/2020.
//  Copyright © 2020 kitaev. All rights reserved.
//

import UIKit
import RevealingSplashView

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        revealingSplashView.heartAttack = true
        

        // Do any additional setup after loading the view.
    }
    
// SplashView
let revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "launch.png")!, iconInitialSize: CGSize(width: 210, height: 210),  backgroundImage: UIImage(named: "bb.png")!)

func setupViews() {
    
    view.addSubview(revealingSplashView)
 revealingSplashView.animationType = .heartBeat
    revealingSplashView.startAnimation()
    // revealingSplashView.heartAttack = true
     
}
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
