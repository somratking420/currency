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
        
        self.setBackgroundImage(UIImage(named: "buttonAddBackground.png"), forState: .Highlighted)
        self.setImage(UIImage(named: "buttonAddIconHighlighted.png"), forState: .Highlighted)
    }
    
}