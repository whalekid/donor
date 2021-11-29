//
//  AuthorizeViewController.swift
//  Donor
//
//  Created by кит on 20/03/2021.
//  Copyright © 2021 kitaev. All rights reserved.
//

import Foundation
import UIKit

class Validators {
    
    static func isFilled(name: String?, surname: String?, email: String?, password: String?) -> Bool {
        guard !(name ?? "").isEmpty,
            !(surname ?? "").isEmpty,
            !(email ?? "").isEmpty,
            !(password ?? "").isEmpty else {
                return false
        }
        return true
    }
    
    static func isSimpleEmail(_ email: String) -> Bool {
        let emailRegEx = "^.+@.+\\..{2,}$"
        return check(text: email, regEx: emailRegEx)
    }
    
    private static func check(text: String, regEx: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regEx)
        return predicate.evaluate(with: text)
    }
}
