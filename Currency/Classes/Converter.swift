//
//  Converter.swift
//  Currency
//
//  Created by Nuno Coelho Santos on 26/02/2016.
//  Copyright © 2016 Nuno Coelho Santos. All rights reserved.
//

import Foundation
import CoreData
import SWXMLHash

class Converter {
    
    var input:(integer: String, decimal: String, decimalMode: Bool, decimalInputs: Int)
    var inputCurrency: Coin
    var outputCurrency: Coin
    
    init() {
        input.integer = "0"
        input.decimal = ""
        input.decimalMode = false
        input.decimalInputs = 0
        
        inputCurrency = Coin(withCode: "JPY")
        outputCurrency = Coin(withCode: "GBP")
    }
    
    // MARK: Convert.
    
    func convertToInputCurrency(number: Double) -> Double {
        let result: Double = (number / outputCurrency.rate) * inputCurrency.rate
        return result
    }
    
    func convertToOutputCurrency(number: Double) -> Double {
        let result: Double = (number / inputCurrency.rate) * outputCurrency.rate
        return result
    }

    // MARK: Format as currency.
    
    func formattedInput() -> String {
        let inputValue: Double! = Double(input.integer + "." + input.decimal)!
        return formatToCurrency(inputValue, code: inputCurrency.code, locale: inputCurrency.locale, symbol: inputCurrency.symbol, decimals: inputCurrency.decimals)
    }

    func formattedOutput() -> String {
        let inputValue: Double! = Double(input.integer + "." + input.decimal)!
        let outputValue: Double = convertToOutputCurrency(inputValue)
        return formatToCurrency(outputValue, code: outputCurrency.code, locale: outputCurrency.locale, symbol: outputCurrency.symbol, decimals: outputCurrency.decimals)
    }
    
    private func formatToCurrency(value: Double, code: String, locale: String?, symbol: String?, decimals: Int) -> String {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        
        if let locale = locale where !locale.isEmpty {
            formatter.locale = NSLocale(localeIdentifier: locale)
        } else if let symbol = symbol where !symbol.isEmpty {
            formatter.positivePrefix = symbol
            formatter.negativePrefix = symbol
        } else {
            formatter.currencySymbol = ""
        }
        
        formatter.usesGroupingSeparator = true;
        formatter.groupingSeparator = ","
        var formattedPriceString: String! = formatter.stringFromNumber(value)
        formattedPriceString = truncateFormattedCurrency(formattedPriceString, decimals: decimals)
        
        return formattedPriceString!
    }
    
    private func truncateFormattedCurrency(formattedPrice: String, decimals: Int) -> String {
        guard decimals > 0 else {
            return formattedPrice
        }
        
        let truncationLenght: Int! = (input.decimalMode ? decimals : decimals + 1) - input.decimalInputs
        let truncatedPrice: String! = String(formattedPrice.characters.dropLast(truncationLenght))
        return truncatedPrice
    }

    // MARK: Add input.
    
    func addInput(newInput: String) {
        
        if input.decimalMode {
            addDecimalInput(newInput)
        } else {
            addIntegerInput(newInput)
        }
        
    }
    
    private func addIntegerInput(newInput: String) {
        guard input.integer.characters.count < 8 else {
            print("Input string is too long.")
            return
        }
        if input.integer == "0" && newInput == "0" {
            print("Value string is already zero or empty.")
            return
        }
        if input.integer == "0" && newInput != "0" {
            input.integer = newInput
            return
        }
        
        input.integer = input.integer + newInput
    }
    
    private func addDecimalInput(newInput: String) {
        guard input.decimal.characters.count < inputCurrency.decimals else {
            print("Decimal input string is complete.")
            return
        }
        
        input.decimal = input.decimal + newInput
        input.decimalInputs = input.decimalInputs + 1
    }
    
    // MARK: Remove input.
    
    func removeLastInput() {
        if input.decimalMode {
            if input.decimal.isEmpty {
                input.decimalMode = false
            } else {
                removeLastDecimalInput()
            }
        } else {
            removeLastIntegerInput()
        }
    }
    
    private func removeLastIntegerInput() {
        if input.integer == "0" {
            print("Input integer value string is already zero.")
            return
        }
        if input.integer.characters.count == 1 {
            input.integer = "0"
            print("Input integer value was set to zero because it was a single digit value.")
            return
        }
        input.integer = String(input.integer.characters.dropLast())
    }
    
    private func removeLastDecimalInput() {
        guard !input.decimal.isEmpty else {
            print("Input decimal value is already empty.")
            return
        }
        input.decimal = String(input.decimal.characters.dropLast())
    }

    // MARK: Swap input with output.
    
    func swapInputWithOutput(convertInput: Bool) {
        if convertInput {
            let inputValue: Double! = Double(input.integer + "." + input.decimal)
            let old: String! = String(convertToOutputCurrency(inputValue))
            let new: Array! = old.characters.split{$0 == "."}.map(String.init)
            
            input.integer = new[0]
            input.decimal = new[1]
        }
        let newInputCurrencyCode = outputCurrency.code
        let newOutputCurrencyCode = inputCurrency.code
        inputCurrency.setTo(newInputCurrencyCode)
        outputCurrency.setTo(newOutputCurrencyCode)
    }
    
    // MARK: Reset.
    
    func reset() {
        input.integer = "0"
        input.decimal = ""
        input.decimalMode = false
        input.decimalInputs = 0
    }
    
    func beginDecimalInput() {
        guard inputCurrency.decimals != 0 else {
            print("Input currency does not have decimals")
            return
        }
        input.decimal = ""
        input.decimalMode = true
        input.decimalInputs = 0
        print("Started inputting decimals.")
    }


}
