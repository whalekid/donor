//
//  DrawOnView.swift
//  Donor
//
//  Created by кит on 07/03/2020.
//  Copyright © 2020 kitaev. All rights reserved.
//

import UIKit
    @IBDesignable
   class DrawOnView: UIView {
      
    var x1 = 0,y1: Int = 0
    var x2 = 0,y2: Int = 0
    var x3 = 0,y3: Int = 0
    var x4 = 0,y4: Int = 0
        
    @IBInspectable var borderColor: UIColor = UIColor.white {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
        
    @IBInspectable var borderWidth: CGFloat = 2.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
        
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
        
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(1.0)
        context?.setStrokeColor(UIColor.black.cgColor)
        context?.move(to: CGPoint(x:x1, y:y1))
        context?.addLine(to: CGPoint(x:x2, y:y2))
        context?.move(to: CGPoint(x:x3, y:y3))
        context?.addLine(to: CGPoint(x:x4, y:y4))
        context?.strokePath()
    }
  
}
