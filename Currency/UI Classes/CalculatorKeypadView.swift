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
    
    let borderColor: CGColor! = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.00).cgColor
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        let border = CALayer()
        border.backgroundColor = borderColor
        border.frame = CGRect(x: 0, y: -0.25, width: self.frame.size.width * 2, height: 0.25)
        self.layer.addSublayer(border)
        self.layer.masksToBounds = false
    }
    
}
