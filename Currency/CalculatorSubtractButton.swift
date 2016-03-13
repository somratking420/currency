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
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        self.setBackgroundImage(UIImage(named: "buttonMinusBackground.png"), forState: .Highlighted)
        self.setImage(UIImage(named: "buttonMinusIconHighlighted.png"), forState: .Highlighted)
    }
    
}