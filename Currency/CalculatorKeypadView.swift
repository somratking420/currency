//
//  CalculatorKeypadView.swift
//  Currency
//
//  Created by Nuno Coelho Santos on 14/03/2016.
//  Copyright © 2016 Nuno Coelho Santos. All rights reserved.
//

import Foundation
import UIKit

class CalculatorKeypadView: UIView {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        let border = CALayer()
        border.borderColor = UIColor(red:0.74, green:0.74, blue:0.74, alpha:1).CGColor
        border.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: 0.5)
        border.borderWidth = 0.5
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
}