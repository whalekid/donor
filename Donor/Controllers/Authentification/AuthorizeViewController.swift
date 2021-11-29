//
//  AuthorizeViewController.swift
//  Donor
//
//  Created by кит on 20/03/2021.
//  Copyright © 2021 kitaev. All rights reserved.
//


import UIKit
import FirebaseAuth
import Firebase

class AuthorizeViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var authGoogleBtn: UIButton!
    @IBOutlet weak var authBtn: UIButton!
    @IBOutlet weak var ErrorLabel: UILabel!
    
    private let firebaseAuthService = FirebaseAuthService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareVC()
    }

    @IBAction func logInFinalPressed(_ sender: Any) {
        firebaseAuthService.signIn(email: emailTextField.text!, password: passwordTextField.text!) { [unowned self] in
            DispatchQueue.main.async {
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let tabbar: UITabBarController? = (storyBoard.instantiateViewController(withIdentifier: "MainTB") as? UITabBarController)
                self.navigationController?.pushViewController(tabbar!, animated: true)
                self.navigationController?.setNavigationBarHidden(true, animated: false)
            }
        }
    }

    private func prepareVC() {
        ErrorLabel.alpha = 0
        authBtn.layer.cornerRadius = 12
        authGoogleBtn.layer.cornerRadius = 12
    }
}




