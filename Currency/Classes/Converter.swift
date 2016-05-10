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
            inputString = "0"
        }
        if !input.decimal.isEmpty {
            inputString = inputString + "." + "\(input.decimal)"
        }
        return Double(inputString)!
    }

    func formattedInput() -> String {
        let inputValue: Double! = parsedInput()
        let formattedInput = formatToCurrency(
                inputValue,
                code: inputCurrency.code,
                locale: inputCurrency.locale,
                symbol: inputCurrency.symbol,
                decimals: inputCurrency.decimals,
                symbolPosition: inputCurrency.symbolPosition,
                useLocalization: inputCurrency.useLocalization,
                useSymbol: inputCurrency.useSymbol,
                useCustomSymbol: inputCurrency.useCustomSymbol
            )
        return formattedInput
    }

    func formattedOutput() -> String {
        let inputValue: Double! = parsedInput()
        let outputValue: Double = convertToOutputCurrency(inputValue)
        let formattedOutput = formatToCurrency(
                outputValue,
                code: outputCurrency.code,
                locale: outputCurrency.locale,
                symbol: outputCurrency.symbol,
                decimals: outputCurrency.decimals,
                symbolPosition: outputCurrency.symbolPosition,
                useLocalization: outputCurrency.useLocalization,
                useSymbol: outputCurrency.useSymbol,
                useCustomSymbol: outputCurrency.useCustomSymbol
            )
        return formattedOutput
    }

    private func formatToCurrency(
                value: Double,
                code: String,
                locale: String?,
                symbol: String?,
                decimals: Int,
                symbolPosition: String?,
                useLocalization: Bool,
                useSymbol: Bool,
                useCustomSymbol: Bool
            ) -> String {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        formatter.minimumFractionDigits = decimals
        formatter.maximumFractionDigits = decimals
        formatter.usesGroupingSeparator = true;
        formatter.groupingSeparator = ","
        
        if useLocalization {
            if let locale = locale where !locale.isEmpty {
                formatter.locale = NSLocale(localeIdentifier: locale)
            }
        } else {
            formatter.locale = NSLocale(localeIdentifier: "en_US")
        }
        
        if useSymbol {
            if useCustomSymbol {
                if let symbol = symbol where !symbol.isEmpty {
                    formatter.currencySymbol = symbol
                }
            }
        } else {
            formatter.currencySymbol = ""
        }
        
        var offset = 0
        if symbolPosition == "right" {
            if let symbol = symbol where !symbol.isEmpty {
                offset = symbol.characters.count
            }
        }
        
        var formattedCurrency: String! = formatter.stringFromNumber(value)

        if code == inputCurrency.code {
            formattedCurrency = truncateDecimalsToDecimalInputLength(formattedCurrency, decimals: decimals, offset: offset)
        } else {
            formattedCurrency = truncateEmptyDecimalsFromCurrency(formattedCurrency, decimals: decimals, offset: offset)
        }

        return formattedCurrency!
    }

    private func truncateDecimalsToDecimalInputLength(formattedCurrency: String, decimals: Int, offset: Int) -> String {
        guard decimals > 0 else {
            print("No decimals to truncate from price string")
            return formattedCurrency
        }

        let truncationLenght: Int! = (input.decimalMode ? decimals : decimals + 1) - input.decimalInputs

        guard truncationLenght > 0 else {
            print("Truncation length is a negative value");
            return formattedCurrency
        }

        let symbol: String! = String(formattedCurrency.characters.dropFirst(formattedCurrency.characters.count - offset))
        let number: String! = String(formattedCurrency.characters.dropLast(offset)).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let truncatedNumber: String! = String(number.characters.dropLast(truncationLenght))
        let truncatedPrice: String! = truncatedNumber + symbol

        return truncatedPrice
    }

    private func truncateEmptyDecimalsFromCurrency(formattedCurrency: String, decimals: Int, offset: Int) -> String {
        guard decimals > 0 else {
            print ("There are no decimals to truncate from this currency")
            return formattedCurrency
        }
        
        let truncationLenght: Int! = decimals + 1
        let symbol: String! = String(formattedCurrency.characters.dropFirst(formattedCurrency.characters.count - offset))
        let number: String! = String(formattedCurrency.characters.dropLast(offset)).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let lastCharacters: String! = String(number.characters.suffix(truncationLenght))
        let decimalDivider: String! = String(lastCharacters.characters.prefix(1))
        let emptyDecimals = decimalDivider + String(count: decimals, repeatedValue: Character("0"))
    
        if (lastCharacters == emptyDecimals) {
            let truncatedNumber: String! = String(number.characters.dropLast(truncationLenght))
            let truncatedPrice: String! = truncatedNumber + symbol
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
        print("Adding decimal input: \(newInput).")
        guard input.decimal.characters.count < inputCurrency.decimals else {
            print("Decimal input string has already reached the maximum length.")
            return
        }

        input.decimal = input.decimal + newInput
        print("New decimal input is: \(input.decimal)")
        input.decimalInputs = input.decimalInputs + 1
        print("New number of decimal inputs so far is: \(input.decimalInputs).")
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
        // First split the double into an integer and decimal string.
        let valueInteger: String = String(value.split()[0])
        let valueDecimal: String = String(value.split()[1])
        // Then define the values to be set.
        let newInteger: String = valueInteger
        let newDecimal: String = valueDecimal == "0" ? "" : valueDecimal
        let newNumberOfDecimalInputs: Int! = newDecimal.characters.count
        let isDecimalModeOn: Bool! = newNumberOfDecimalInputs == 0 ? false : true
        // Finally, set the values.
        input.integer = newInteger
        input.decimal = newDecimal
        input.decimalInputs = newNumberOfDecimalInputs
        input.decimalMode = isDecimalModeOn
    }

    func swapInputWithOutput(convertInputValue convertInputValue: Bool = true) {
        if convertInputValue {
            // First let's get the values from the output currency.
            let oldOutput = parseCurrency(
                    formattedOutput(),
                    code: outputCurrency.code,
                    locale: outputCurrency.locale,
                    symbol: outputCurrency.symbol,
                    decimals: outputCurrency.decimals,
                    symbolPosition: outputCurrency.symbolPosition,
                    useLocalization: outputCurrency.useLocalization,
                    useSymbol: outputCurrency.useSymbol,
                    useCustomSymbol: outputCurrency.useCustomSymbol
                )
            // Then set those values as the new input.
            setInputValue(oldOutput)
            // And finally, swap the currencies.
        }
        let newInputCurrencyCode = outputCurrency.code
        let newOutputCurrencyCode = inputCurrency.code
        inputCurrency.setTo(newInputCurrencyCode, update: false)
        outputCurrency.setTo(newOutputCurrencyCode, update: false)

    }

    private func parseCurrency(
                formattedCurrency: String,
                code: String,
                locale: String?,
                symbol: String?,
                decimals: Int,
                symbolPosition: String?,
                useLocalization: Bool,
                useSymbol: Bool,
                useCustomSymbol: Bool
            ) -> Double {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        formatter.minimumFractionDigits = decimals
        formatter.maximumFractionDigits = decimals
        formatter.usesGroupingSeparator = true;
        formatter.groupingSeparator = ","
        
        if useLocalization {
            if let locale = locale where !locale.isEmpty {
                formatter.locale = NSLocale(localeIdentifier: locale)
            }
        } else {
            formatter.locale = NSLocale(localeIdentifier: "en_US")
        }
        
        if useSymbol {
            if useCustomSymbol {
                if let symbol = symbol where !symbol.isEmpty {
                    formatter.currencySymbol = symbol
                }
            }
        } else {
            formatter.currencySymbol = ""
        }
        
        let double: Double = formatter.numberFromString(formattedCurrency)!.doubleValue

        return (double)
    }

    // MARK: Reset.

    func clear() {
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
    func split() -> [String] {
        return String(self).characters.split{$0 == "."}.map({
            return String($0)
        })
    }
}
