//
//  BloodRhesus.swift
//  Donor
//
//  Created by кит on 04/04/2020.
//  Copyright © 2020 kitaev. All rights reserved.
//

import Foundation


class BloodRhesus: NSObject, NSCoding {
    
    let bloodType: String
    let rhesus: String
    
    init(rhesus: String, bloodType: String) {
        self.rhesus = rhesus
        self.bloodType = bloodType
    }
    
    required init?(coder: NSCoder) {
        bloodType = coder.decodeObject(forKey: "bloodType") as? String ?? ""
        rhesus = coder.decodeObject(forKey: "rhesus") as? String ?? ""
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(bloodType, forKey: "bloodType")
        coder.encode(rhesus, forKey: "rhesus")
    }

}
