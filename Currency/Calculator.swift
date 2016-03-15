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
    var operationInProgress: Bool
    
    init() {
        initialValue = 0
        operationSymbol = nil
        operationInProgress = false
    }
    
    func calculate(number:Double) -> Double {
        if operationInProgress {
            var result:Double = initialValue
            if operationSymbol == "+" {
                result = initialValue + number
            }
            if operationSymbol == "-" {
                result = initialValue - number
            }
            initialValue = result
            operationSymbol = nil
            operationInProgress = false
            return result
        }
        return number
    }
    
    func newAddition(number: Double) -> Bool {
        if operationInProgress {
            return false
        }
        initialValue = calculate(number)
        operationSymbol = "+"
        operationInProgress = true
        return true
    }
    
    func newSubtraction(number: Double) -> Bool {
        if operationInProgress {
            return false
        }
        initialValue = calculate(number)
        operationSymbol = "-"
        operationInProgress = true
        return true
    }
    
    func reset() {
        initialValue = 0
        operationSymbol = nil
        operationInProgress = false
    }
    
}