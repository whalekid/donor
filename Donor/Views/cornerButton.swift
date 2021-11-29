//
//  cornerButton.swift
//  Donor
//
//  Created by кит on 04/03/2020.
//  Copyright © 2020 kitaev. All rights reserved.
//

import UIKit

class cornerButton: UIButton {

    var indexP: Int?
    private let checkedImage = UIImage(named: "checked")
    private let unCheckedImage = UIImage(named: "unchecked")
    
    @IBInspectable var isChecked:Bool = false{
        didSet{
            self.updateImage()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addTarget(self, action: #selector(cornerButton.buttonClicked), for: UIControl.Event.touchUpInside)
        self.updateImage()
    }
    
    private func updateImage() {
        layer.cornerRadius = 6
        clipsToBounds = true
        if isChecked{
            self.setImage(checkedImage, for: [])
        }
        else{
            self.setImage(unCheckedImage, for: [])
        }
    }

    @objc private func buttonClicked(sender:UIButton) {
        if(sender == self){
            isChecked = !isChecked
        }
    }

}

