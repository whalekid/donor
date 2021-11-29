////
////  Avatar.swift
////  Donor
////
////  Created by кит on 02/04/2020.
////  Copyright © 2020 kitaev. All rights reserved.
////
//
import Foundation
import UIKit

class Avatar {
    static let shared = Avatar()
    private init() {}

    private let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    private let fileManager = FileManager.default

    var image: UIImage? {
        get {
            if fileManager.fileExists(atPath: documentDirectory + "/image.jpeg") {
                if let image = UIImage(contentsOfFile: documentDirectory + "/image.jpeg") {
                    return image
                }
            }
            return UIImage(named: "image")
        }
        
        set {
            if let newValue = newValue {
                if let data = newValue.jpegData(compressionQuality: 1.0) {
                    fileManager.createFile(atPath: documentDirectory + "/image.jpeg", contents: data, attributes: nil)
                }
            }
            else {
                do {
                    try fileManager.removeItem(atPath: documentDirectory + "/image.jpeg")
                }  catch let error {
                    print ("Calendar Event Error: \(error)")
                }
            }
        }
    }
}
