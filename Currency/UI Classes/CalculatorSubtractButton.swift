//
//  CalculatorSubtractButton.swift
//  Currency
//
//  Created by Nuno Coelho Santos on 13/03/2016.
//  Copyright © 2016 Nuno Coelho Santos. All rights reserved.
//

import Foundation
import UIKit

class CalculatorSubtractButton: UIButton {
    
    let borderColor: CGColor! = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.00).CGColor
    let normalStateColor: CGColor! = UIColor(red:0.99, green:0.99, blue:0.99, alpha:1.00).CGColor
    let highlightStateColor: CGColor! = UIColor(red:0.97, green:0.32, blue:0.32, alpha:1.00).CGColor
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        self.setImage(UIImage(named: "buttonSubtractIconHighlighted.png"), forState: .Highlighted)
        
        let border = CALayer()
        border.backgroundColor = borderColor
        border.frame = CGRect(x: 0, y: 0, width: 0.25, height: self.frame.size.height * 2)
        self.layer.masksToBounds = true
        self.layer.addSublayer(border)
        self.backgroundColor = UIColor(CGColor: normalStateColor)
    }
    
    override var highlighted: Bool {
        
        get {
            return super.highlighted
        }
        set {
            if newValue {
                let fadeIn = CABasicAnimation(keyPath: "backgroundColor")
                fadeIn.fromValue = normalStateColor
                fadeIn.toValue = highlightStateColor
                fadeIn.duration = 0.12
                fadeIn.autoreverses = false
                fadeIn.repeatCount = 1
                
                self.layer.addAnimation(fadeIn, forKey: "fadeIn")
                self.backgroundColor = UIColor(CGColor: highlightStateColor)
            }
            else {
                let fadeOut = CABasicAnimation(keyPath: "backgroundColor")
                fadeOut.fromValue = highlightStateColor
                fadeOut.toValue = normalStateColor
                fadeOut.duration = 0.12
                fadeOut.autoreverses = false
                fadeOut.repeatCount = 1
                
                self.layer.addAnimation(fadeOut, forKey: "fadeOut")
                self.backgroundColor = UIColor(CGColor: normalStateColor)
            }
            super.highlighted = newValue
        }
    }
    
}