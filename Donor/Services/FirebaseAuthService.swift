//
//  FirebaseAuthService.swift
//  Donor
//
//  Created by кит on 22/11/2021.
//  Copyright © 2021 kitaev. All rights reserved.
//

import Foundation
import FirebaseAuth

class FirebaseAuthService {
    
    private let firebaseService = FirebaseService()
    
    enum AuthResult {
           case success
           case failure(Error)
       }
    
    func auth(name: String, surname: String, email: String, password: String, completion: @escaping (AuthResult) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (result, error) in
            guard let result = result else {
                completion(.failure(error!))
                return
            }
            self?.firebaseService.setAuthData(result: result, name: name, surname: surname) { (result1) in
                completion(result1)
            }
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping ()->()) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let err = error {
                print(err.localizedDescription)
            } else {
                UserSettings.uid = result!.user.uid
                UserSettings.hasAuthorized = true
                completion()
            }
        }

    }
    
    
}
