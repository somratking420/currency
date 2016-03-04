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
import SWXMLHash

class Converter {

    let requestEndpoint = ""

    var input: String = ""
    var inputCurrencyCode: String = "JPY";
    var outputCurrencyCode: String = "GBP";
    var inputCurrencyExchangeRate: Double = 113.81;
    var outputCurrencyExchangeRate: Double = 0.71;

    let realm = try! Realm()
    
    init() {
        requestUpdateForCurrencyConvertionRate(inputCurrencyCode)
        requestUpdateForCurrencyConvertionRate(outputCurrencyCode)
    }

    func inputValue() -> String {
        let inputValue: Double = Double(input)!
        return convertToCurrency(inputValue, currency_code: inputCurrencyCode)
    }

    func outputValue() -> String {
        let outputValue: Double = (Double(input)! / inputCurrencyExchangeRate) * outputCurrencyExchangeRate
        return convertToCurrency(outputValue, currency_code: outputCurrencyCode)
    }

    func addInput(string: String) {
        if input == "0" && string == "0" {
            print("Value string is already zero or empty.")
            return
        }
        if input == "0" && string != "0" {
            input = string
            return
        }
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

    func reset() {
        input = "0";
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

    private func requestUpdateForCurrencyConvertionRate(currencyCode: String) {
        
        let url = NSURL(string: "https://query.yahooapis.com/v1/public/yql?q=" +
            "select%20*%20from%20yahoo.finance.xchange%20where%20pair%20in%20(" +
            "%22USD" + currencyCode + "%22)&diagnostics=true&env=store%3A%2F%2F" +
            "datatables.org%2Falltableswithkeys")
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            
            let xml = SWXMLHash.parse(data!)
            
            guard let rate = xml["query"]["results"]["rate"]["Rate"].element?.text else {
                print("Could not parse XML request.")
                return
            }
            
            // Update currency record on database.
            self.updateCurrencyRecord(currencyCode, rate: Double(rate)!)
            
            // If we are dealing with the currency input currency,
            // let's update the current input rate.
            if currencyCode == self.inputCurrencyCode {
                self.inputCurrencyExchangeRate = Double(rate)!
                print("Input Currency \(currencyCode) updated with the rate: \(rate)")
            }
            
            // If we are dealing with the currency output currency,
            // let's update the current output rate.
            if currencyCode == self.outputCurrencyCode {
                self.outputCurrencyExchangeRate = Double(rate)!
                print("Output Currency \(currencyCode) updated with the rate: \(rate)")
            }
            
        }
        
        task.resume()

    }
    
    private func updateCurrencyRecord(currencyCode: String, rate: Double) {
        
        print("Currency \(currencyCode) record saved with the rate: \(rate)")
        
    }

}
