//
//  RoundedImageView.swift
//  Donor
//
//  Created by кит on 02/04/2020.
//  Copyright © 2020 kitaev. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class RoundedImageView: UIImageView {

    @IBInspectable var cornerRadius: CGFloat = 0.0
    @IBInspectable var borderWidth: CGFloat = 0.0
    @IBInspectable var borderColor: UIColor = .lightGray
    
    override func awakeFromNib() {
        super.awakeFromNib()
        config()
    }

    private func config() {
        clipsToBounds = true
        layer.cornerRadius = frame.height / 2.0
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
    }
}
