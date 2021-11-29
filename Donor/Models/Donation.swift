//
//  Donation.swift
//  Donor
//
//  Created by кит on 31/03/2020.
//  Copyright © 2020 kitaev. All rights reserved.
//

import Foundation
class Donation: NSObject, NSCoding {
    
    required init?(coder: NSCoder) {
        name = coder.decodeObject(forKey: "name") as? String ?? ""
        place = coder.decodeObject(forKey: "place") as? String ?? ""
        date = coder.decodeObject(forKey: "date") as? Date ?? Date()
    }
    
    init( name: String?, date: Date?, place: String?) {
        self.name = name
        self.date = date
        self.place = place
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(place, forKey: "place")
        coder.encode(date, forKey: "date")
    }
    
    var name: String?
    var date: Date?
    var place: String?
    
}

