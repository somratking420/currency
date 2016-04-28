//
//  CalculatorButton.swift
//  Currency
//
//  Created by Nuno Coelho Santos on 25/02/2016.
//  Copyright © 2016 Nuno Coelho Santos. All rights reserved.
//

import Foundation
import UIKit

class CalculatorButton: UIButton {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!

        self.layer.borderWidth = 0.25
        self.layer.borderColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.00).CGColor
        self.tintColor = UIColor(red:0.2, green:0.2, blue:0.2, alpha:1)
        self.layer.masksToBounds = true
    }
    
    override var highlighted: Bool {
        get {
            return super.highlighted
        }
        set {
            if newValue {
                self.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1)
            }
            else {
                self.backgroundColor = nil
            }
            super.highlighted = newValue
        }
    }
    
}