//
//  CalculatorAddButton.swift
//  Currency
//
//  Created by Nuno Coelho Santos on 13/03/2016.
//  Copyright © 2016 Nuno Coelho Santos. All rights reserved.
//

import Foundation
import UIKit

class CalculatorAddButton: UIButton {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        self.setBackgroundImage(UIImage(named: "buttonAddBackgroundHighlighted.png"), forState: .Highlighted)
        self.setImage(UIImage(named: "buttonAddIconHighlighted.png"), forState: .Highlighted)
        
        let border = CALayer()
        border.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.00).CGColor
        border.frame = CGRect(x: 0, y: 0, width: 0.25, height: self.frame.size.height * 2)
        self.layer.masksToBounds = true
        self.layer.addSublayer(border)
    }
    
}