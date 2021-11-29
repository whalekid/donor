//
//  UserSettings.swift
//  Donor
//
//  Created by кит on 01/04/2020.
//  Copyright © 2020 kitaev. All rights reserved.
//

import Foundation

final class UserSettings {
    
    private enum SettingsKeys: String, CaseIterable {
        case userModel
        case userName
        case userBlood
        case hasViewedWalkthrough
        case hasAuthorized
        case hasCongratulated
        case uid
    }
    
    static var userModel: Donation! {
        get {
            guard let savedData = UserDefaults.standard.object(forKey: SettingsKeys.userModel.rawValue) as? Data, let decodedModel = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedData) as? Donation else { return nil }
            return decodedModel
        }
        set {
            let defaults = UserDefaults.standard
            let key = SettingsKeys.userModel.rawValue
            
            if let userModel = newValue {
                if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: userModel, requiringSecureCoding: false) {
                    print("value: \(userModel) was added to key \(key)")
                    print("RawValue: \(SettingsKeys.userModel.rawValue)")
                    defaults.set(savedData, forKey: key)
                } else {
                    defaults.removeObject(forKey: key)
                }
            }
        }
        
    }
    
    static func reset() {
        SettingsKeys.allCases.forEach { UserDefaults.standard.removeObject(forKey: $0.rawValue) }
    }
    
    static func removeUserDonation(){
        let key = SettingsKeys.userModel.rawValue
        UserDefaults.standard.removeObject(forKey: key)
    }
    static func removeUserBlood(){
        let key = SettingsKeys.userBlood.rawValue
        UserDefaults.standard.removeObject(forKey: key)
    }
    static func removeUserName(){
        let key = SettingsKeys.userName.rawValue
        UserDefaults.standard.removeObject(forKey: key)
    }
    static func removeUid(){
        let key = SettingsKeys.uid.rawValue
        UserDefaults.standard.removeObject(forKey: key)
    }
    static func removeHasViewedWalkthrough(){
        let key = SettingsKeys.hasViewedWalkthrough.rawValue
        UserDefaults.standard.removeObject(forKey: key)
    }
    static func removeHasAuthorized(){
        let key = SettingsKeys.hasAuthorized.rawValue
        UserDefaults.standard.removeObject(forKey: key)
    }
    static func removeHasCongratulated(){
        let key = SettingsKeys.hasCongratulated.rawValue
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    static var userBlood: BloodRhesus! {
        get {
            guard let savedData = UserDefaults.standard.object(forKey: SettingsKeys.userBlood.rawValue) as? Data, let decodedModel = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedData) as? BloodRhesus else { return nil }
            return decodedModel
        }
        set {
            let defaults = UserDefaults.standard
            let key = SettingsKeys.userBlood.rawValue
            
            if let userBlood = newValue {
                if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: userBlood, requiringSecureCoding: false) {
                    print("value: \(userBlood) was added to key \(key)")
                    defaults.set(savedData, forKey: key)
                } else {
                    defaults.removeObject(forKey: key)
                }
            }
        }
    }
    
    static var userName: String! {
        get {
            return UserDefaults.standard.string(forKey: SettingsKeys.userName.rawValue)
        } set {
            
            let defaults = UserDefaults.standard
            let key = SettingsKeys.userName.rawValue
            if let name = newValue {
                print("value: \(name) was added to key \(key)")
                defaults.set(name, forKey: key)
            } else {
                defaults.removeObject(forKey: key)
            }
        }
    }
    
    static var hasViewedWalkthrough: Bool! {
        get {
            return UserDefaults.standard.bool(forKey: SettingsKeys.hasViewedWalkthrough.rawValue)
        } set {
            
            let defaults = UserDefaults.standard
            let key = SettingsKeys.hasViewedWalkthrough.rawValue
            if let walkthrough = newValue {
                print("value: \(walkthrough) was added to key \(key)")
                defaults.set(walkthrough, forKey: key)
            } else {
                defaults.removeObject(forKey: key)
            }
        }
    }
    
    static var hasAuthorized: Bool! {
        get {
            return UserDefaults.standard.bool(forKey: SettingsKeys.hasAuthorized.rawValue)
        } set {
            
            let defaults = UserDefaults.standard
            let key = SettingsKeys.hasAuthorized.rawValue
            if let login = newValue {
                print("value: \(login) was added to key \(key)")
                defaults.set(login, forKey: key)
            } else {
                defaults.removeObject(forKey: key)
            }
        }
    }
    
    static var hasCongratulated: Bool! {
        get {
            return UserDefaults.standard.bool(forKey: SettingsKeys.hasCongratulated.rawValue)
        } set {
            
            let defaults = UserDefaults.standard
            let key = SettingsKeys.hasCongratulated.rawValue
            if let congratulation = newValue {
                print("value: \(congratulation) was added to key \(key)")
                defaults.set(congratulation, forKey: key)
            } else {
                defaults.removeObject(forKey: key)
            }
        }
    }
    
    static var uid: String! {
        get {
            return UserDefaults.standard.string(forKey: SettingsKeys.uid.rawValue)
        }
        set {
            let defaults = UserDefaults.standard
            let key = SettingsKeys.uid.rawValue
            if let uid = newValue {
                print("value: \(uid) was added to key \(key)")
                defaults.set(uid, forKey: key)
            } else {
                defaults.removeObject(forKey: key)
            }
        }
    }
    
}
