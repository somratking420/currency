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

        inputCurrency = Coin(withCode: "JPY", update: false, remember: false)
        outputCurrency = Coin(withCode: "GBP", update: false, remember: false)
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
    
    func parsedInput() -> Double {
        var inputString: String
        if let integer = Int(input.integer) {
            inputString = "\(integer)"
        } else {
            print("Unable to parse integer input.")
            inputString = "0"
        }
        if let decimal = Int(input.decimal) {
            inputString = inputString + "." + "\(decimal)"
        } else {
            print("Unable to parse decimal input.")
        }
        return Double(inputString)!
    }

    func formattedInput() -> String {
        let inputValue: Double! = parsedInput()
        return formatToCurrency(inputValue, code: inputCurrency.code, locale: inputCurrency.locale, symbol: inputCurrency.symbol, decimals: inputCurrency.decimals)
    }

    func formattedOutput() -> String {
        let inputValue: Double! = parsedInput()
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
        var formattedCurrency: String! = formatter.stringFromNumber(value)

        if code == inputCurrency.code {
            formattedCurrency = truncateDecimalsToDecimalInputLength(formattedCurrency, decimals: decimals)
        } else {
            formattedCurrency = truncateEmptyDecimalsFromCurrency(formattedCurrency, decimals: decimals)
        }

        return formattedCurrency!
    }

    private func truncateDecimalsToDecimalInputLength(formattedCurrency: String, decimals: Int) -> String {
        guard decimals > 0 else {
            print("No decimals to truncate from price string")
            return formattedCurrency
        }

        let truncationLenght: Int! = (input.decimalMode ? decimals : decimals + 1) - input.decimalInputs
        let truncatedPrice: String! = String(formattedCurrency.characters.dropLast(truncationLenght))
        return truncatedPrice
    }

    private func truncateEmptyDecimalsFromCurrency(formattedCurrency: String, decimals: Int) -> String {
        guard decimals > 0 else {
             print("No decimals to truncate from price string")
             return formattedCurrency
         }

         let lastCharacters: String! = String(formattedCurrency.characters.suffix(decimals + 1))
         let truncationLenght: Int! = input.decimalMode ? decimals : decimals + 1
         let decimalDivider: String! = String(lastCharacters.characters.prefix(1))

         let emptyDecimals = decimalDivider + String(count: decimals, repeatedValue: Character("0"))

         if (lastCharacters == emptyDecimals) {
             let truncatedPrice: String! = String(formattedCurrency.characters.dropLast(truncationLenght))
             return truncatedPrice
         } else {
             return formattedCurrency
         }
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
        if input.decimalMode && inputCurrency.decimals > 0 {
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
        input.decimalInputs = input.decimalInputs - 1
    }

    // MARK: Swap input with output.
    
    func setInputValue(value: Double) {
        
        let valueInteger: String = String(value.split()[0])
        let valueDecimal: String = String(value.split()[1])
        
        let newInteger: String = valueInteger
        let newDecimal: String = valueDecimal == "0" ? "" : valueDecimal
        let newNumberOfDecimalInputs: Int! = newDecimal.characters.count
        let isDecimalModeOn: Bool! = newNumberOfDecimalInputs == 0 ? false : true
        
        input.integer = newInteger
        input.decimal = newDecimal
        input.decimalInputs = newNumberOfDecimalInputs
        input.decimalMode = isDecimalModeOn
    }

    func swapInputWithOutput(keepInputValue: Bool) {
        
        let oldOutput = parseCurrency(formattedOutput(), code: outputCurrency.code, locale: outputCurrency.locale, symbol: outputCurrency.symbol, decimals: outputCurrency.decimals)
        
        setInputValue(oldOutput)
        
        let newInputCurrencyCode = outputCurrency.code
        let newOutputCurrencyCode = inputCurrency.code
        inputCurrency.setTo(newInputCurrencyCode, update: false)
        outputCurrency.setTo(newOutputCurrencyCode, update: false)
        
    }
    
    private func parseCurrency(formattedCurrency: String, code: String, locale: String?, symbol: String?, decimals: Int) -> Double {
        
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
        let double: Double = formatter.numberFromString(formattedCurrency)!.doubleValue
        
        return (double)
        
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

extension Double {
    func split() -> [Int] {
        return String(self).characters.split{$0 == "."}.map({
            return Int(String($0))!
        })
    }
}
