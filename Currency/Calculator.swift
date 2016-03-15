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
    var operationSymbol: String?
    
    init() {
        initialValue = 0
        operationSymbol = nil
    }
    
    func calculate(number:Double) -> Double {
        if let operation = operationSymbol {
            var result:Double = initialValue
            if operation == "+" {
                result = initialValue + number
            }
            if operation == "-" {
                result = initialValue - number
            }
            initialValue = result
            operationSymbol = nil
            return result
        }
        return number
    }
    
    func newAddition(number: Double) {
        initialValue = calculate(number)
        operationSymbol = "+"
    }
    
    func newSubtraction(number: Double) {
        initialValue = calculate(number)
        operationSymbol = "-"
    }
    
    func reset() {
        initialValue = 0
        operationSymbol = nil
    }
    
}