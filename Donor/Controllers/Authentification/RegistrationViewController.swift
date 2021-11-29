//
//  RegistrationViewController.swift
//  Donor
//
//  Created by кит on 20/03/2021.
//  Copyright © 2021 kitaev. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class RegistrationViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var regBtn: UIButton!
    @IBOutlet weak var regGoogleBtn: UIButton!
    @IBOutlet weak var RegView: DrawOnView!
    @IBOutlet weak var ErrorLabel: UILabel!
    @IBOutlet weak var SignInFinalPressed: UIButton!
    
    private let firebaseAuthService = FirebaseAuthService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareVC()
    }
    
    @IBAction func SignInFinalPressed(_ sender: Any) {
        register(email: emailTextField.text, password: passwordTextField.text) { (result) in
            switch result {
            case .success:
                self.showOK(with: "Успешно!", and: "")
                
            case .failure(let error):
                self.showAlert(with: "Ошибка", and: error.localizedDescription)
            }
        }
    }
    
    private func prepareVC() {
        ErrorLabel.alpha = 0
        regBtn.layer.cornerRadius = 12
        regGoogleBtn.layer.cornerRadius = 12
        RegView.layer.cornerRadius = 6
    }
    
    private func register(email: String?, password: String?, completion: @escaping (FirebaseAuthService.AuthResult) -> Void) {
        guard Validators.isFilled(name: nameTextField.text,
                                  surname: surnameTextField.text,
                                  email: emailTextField.text,
                                  password: passwordTextField.text) else {
                                    completion(.failure(AuthError.notFilled))
                                    return
        }
        guard let email = email, let password = password else {
            completion(.failure(AuthError.unknownError))
            return
        }
        guard Validators.isSimpleEmail(email) else {
            completion(.failure(AuthError.invalidEmail))
            return
        }
        firebaseAuthService.auth(name: nameTextField.text!, surname: surnameTextField.text!, email: email, password: password) { (result) in
            completion(result)
        }
    }
    
    private func signIn() {
        firebaseAuthService.signIn(email: emailTextField.text!, password: passwordTextField.text!) { [unowned self] in
            DispatchQueue.main.async {
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let tabbar: UITabBarController? = (storyBoard.instantiateViewController(withIdentifier: "MainTB") as? UITabBarController)
                self.navigationController?.pushViewController(tabbar!, animated: true)
                self.navigationController?.setNavigationBarHidden(true, animated: false)
            }
        }
    }
    
}

extension RegistrationViewController {
    func showOK(with title: String, and message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler:
        { [unowned self] (action: UIAlertAction!) in
            self.signIn()
            }
        )
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension UIViewController {
    func showAlert(with title: String, and message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler:nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
