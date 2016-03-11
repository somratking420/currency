//
//  Calculator.swift
//  Currency
//
//  Created by Nuno Coelho Santos on 11/03/2016.
//  Copyright © 2016 Nuno Coelho Santos. All rights reserved.
//

import Foundation

class Calculator {
    
    var initialValue: Double
    var operation: String?
    
    init() {
        initialValue = 0
        operation = nil
    }
    
    func calculate(number:Double) -> Double {
        if let operationSymbol = operation {
            var result:Double = initialValue
            if operationSymbol == "+" {
                result = initialValue + number
            }
            if operationSymbol == "-" {
                result = initialValue - number
            }
            initialValue = result
            operation = nil
            return result
        }
        return number
    }
    
    func newAddition(number: Double) {
        initialValue = calculate(number)
        operation = "+"
    }
    
    func newSubtraction(number: Double) {
        initialValue = calculate(number)
        operation = "-"
    }
    
    func reset() {
        initialValue = 0
        operation = nil
    }
    
}