//
//  Converter.swift
//  Currency
//
//  Created by Nuno Coelho Santos on 26/02/2016.
//  Copyright © 2016 Nuno Coelho Santos. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class Converter {

    let requestEndpoint = ""

    var input = ""
    var inputCurrencyCode: String = "JPY";
    var outputCurrencyCode: String = "GBP";
    var inputCurrencyExchangeRate: Double = 113.81;
    var outputCurrencyExchangeRate: Double = 0.71;

    let realm = try! Realm()

    func inputValue() -> String {
        let inputValue: Double = Double(input)!
        return convertToCurrency(inputValue, currency_code: inputCurrencyCode)
    }

    func outputValue() -> String {
        let outputValue: Double = (Double(input)! / inputCurrencyExchangeRate) * outputCurrencyExchangeRate
        return convertToCurrency(outputValue, currency_code: outputCurrencyCode)
    }

    func addInput(string: String) {
        input = input + string
    }

    func setInputCurrency(currency_code: String) {
        inputCurrencyCode = currency_code
        requestUpdateForCurrencyConvertionRate(inputCurrencyCode)
        resetExchangeRates()
    }

    func setOutputCurrency(currency_code: String) {
        outputCurrencyCode = currency_code
        requestUpdateForCurrencyConvertionRate(outputCurrencyCode)
        resetExchangeRates()
    }

    func swapInputWithOutput() {
        inputCurrencyCode = outputCurrencyCode;
        outputCurrencyCode = inputCurrencyCode;
        resetExchangeRates()
    }

    func resetInputValue() -> String {
        input = "0";
        return convertToCurrency(0, currency_code: inputCurrencyCode)
    }

    func resetOutputValue() -> String {
        return convertToCurrency(0, currency_code: outputCurrencyCode)
    }

    private func resetExchangeRates() {

    }

    private func convertToCurrency(value: Double, currency_code: String) -> String {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        formatter.currencyCode = currency_code
        formatter.usesGroupingSeparator = true;
        formatter.groupingSeparator = ","
        let formattedPriceString = formatter.stringFromNumber(value)
        return formattedPriceString!
    }

    private func requestUpdateForCurrencyConvertionRate(currency_code: String) {

    }

}
