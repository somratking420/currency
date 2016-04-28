//
//  CalculatorSwitchButton.swift
//  Currency
//
//  Created by Nuno Coelho Santos on 13/03/2016.
//  Copyright © 2016 Nuno Coelho Santos. All rights reserved.
//

import Foundation
import UIKit

class CalculatorSwitchButton: UIButton {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        self.setImage(UIImage(named: "buttonSwitchIconHighlighted.png"), forState: .Highlighted)
        
        let border = CALayer()
        border.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.00).CGColor
        border.frame = CGRect(x: 0, y: 0, width: 0.25, height: self.frame.size.height * 2)
        self.layer.masksToBounds = true
        self.layer.addSublayer(border)
    }
    
    override var highlighted: Bool {
        
        get {
            return super.highlighted
        }
        set {
            if newValue {
                let fadeIn = CABasicAnimation(keyPath: "backgroundColor")
                fadeIn.fromValue = UIColor(red:1.00, green:0.62, blue:0.00, alpha:0).CGColor
                fadeIn.toValue = UIColor(red:1.00, green:0.62, blue:0.00, alpha:1).CGColor
                fadeIn.duration = 0.12
                fadeIn.autoreverses = false
                fadeIn.repeatCount = 1
                
                self.layer.addAnimation(fadeIn, forKey: "fadeIn")
                self.backgroundColor = UIColor(red:1.00, green:0.62, blue:0.00, alpha:1)
            }
            else {
                let fadeOut = CABasicAnimation(keyPath: "backgroundColor")
                fadeOut.fromValue = UIColor(red:1.00, green:0.62, blue:0.00, alpha:1).CGColor
                fadeOut.toValue = UIColor(red:1.00, green:0.62, blue:0.00, alpha:0).CGColor
                fadeOut.duration = 0.12
                fadeOut.autoreverses = false
                fadeOut.repeatCount = 1
                
                self.layer.addAnimation(fadeOut, forKey: "fadeOut")
                self.backgroundColor = nil
            }
            super.highlighted = newValue
        }
    }
    
}
