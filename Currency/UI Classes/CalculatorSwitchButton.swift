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
    
    let borderColor: CGColor! = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.00).CGColor
    let normalStateColor: CGColor! = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.00).CGColor
    let highlightStateColor: CGColor! = UIColor(red:1.00, green:0.62, blue:0.00, alpha:1.00).CGColor
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        self.setImage(UIImage(named: "buttonSwitchIconHighlighted.png"), forState: .Highlighted)
        
        let leftBorder = CALayer()
        leftBorder.backgroundColor = borderColor
        leftBorder.frame = CGRect(x: 0, y: 0, width: 0.25, height: self.frame.size.height * 2)
        
        let topBorder = CALayer()
        topBorder.backgroundColor = borderColor
        topBorder.frame = CGRect(x: 0, y: 0, width: self.frame.size.width * 2, height: 0.25)
        
        self.layer.masksToBounds = true
        self.layer.addSublayer(leftBorder)
        self.layer.addSublayer(topBorder)
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
