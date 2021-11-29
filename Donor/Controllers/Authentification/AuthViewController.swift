//
//  AuthViewController.swift
//  Donor
//
//  Created by кит on 20/03/2021.
//  Copyright © 2021 kitaev. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class AuthViewController: UIViewController {

    @IBOutlet weak var authBtn: UIButton!
    @IBOutlet weak var regBtn: UIButton!
    private let firebaseAuthService = FirebaseAuthService()
    override func viewDidLoad() {
        super.viewDidLoad()
        checkAuth()
        prepareVC()
    }
    
    private func checkAuth() {
        if UserSettings.hasAuthorized {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let tabbar: UITabBarController? = (storyBoard.instantiateViewController(withIdentifier: "MainTB") as? UITabBarController)
            self.navigationController?.pushViewController(tabbar!, animated: true)
            self.navigationController?.setNavigationBarHidden(true, animated: false)
        }
        else {
            UserSettings.reset()
        }
    }
    
    private func prepareVC() {
        authBtn.layer.cornerRadius = 12
        regBtn.layer.cornerRadius = 12
    }
    
    @IBAction func SignInPressed(_ sender: Any) {
    }
    
    @IBAction func LogInPressed(_ sender: Any) {
    }
    
}

