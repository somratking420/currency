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

    var input: Double
    var inputCurrency:(code: String, rate: Double, locale: String?, symbol: String?)
    var outputCurrency:(code: String, rate: Double, locale: String?, symbol: String?)
    
    init() {
        input = 0
        
        inputCurrency.code = "JPY";
        inputCurrency.rate = 113.81;
        inputCurrency.locale = "ja_JP"
        inputCurrency.symbol = "¥"
        
        outputCurrency.code = "GBP";
        outputCurrency.rate = 0.71;
        outputCurrency.locale = "en_GB"
        outputCurrency.symbol = "£"
        
        requestUpdateForCurrencyExchangeRate(inputCurrency.code)
        requestUpdateForCurrencyExchangeRate(outputCurrency.code)
    }

    func inputValue() -> String {
        let inputValue: Double = input
        return convertToCurrency(inputValue, code: inputCurrency.code, locale: inputCurrency.locale, symbol: inputCurrency.symbol)
    }

    func outputValue() -> String {
        let outputValue: Double = convertToOutputCurrency(input)
        return convertToCurrency(outputValue, code: outputCurrency.code, locale: outputCurrency.locale, symbol: outputCurrency.symbol)
    }
    
    func convertToInputCurrency(number: Double) -> Double {
        let result: Double = (number / outputCurrency.rate) * inputCurrency.rate
        return result
    }
    
    func convertToOutputCurrency(number: Double) -> Double {
        let result: Double = (number / inputCurrency.rate) * outputCurrency.rate
        return result
    }

    func addInput(newInput: Double) {
        if input == 0.0 && newInput == 0.0 {
            print("Value string is already zero or empty.")
            return
        }
        if input == 0.0 && newInput != 0.0 {
            input = newInput
            return
        }
        if input >= 99999999.99 {
            print("Input string is too long.")
            return
        }
        
        var inputString:String = String(Int(input))
        let newInputString:String = String(Int(newInput))
        inputString = inputString + newInputString
        input = Double(inputString)!
    }

    func setInputCurrency(currencyCode: String) {
        let currency = getCurrencyRecord(currencyCode)
        inputCurrency.code = currency.code
        inputCurrency.locale = currency.locale
        inputCurrency.symbol = currency.symbol
        inputCurrency.rate = currency.rate
        requestUpdateForCurrencyExchangeRate(currency.code)
    }

    func setOutputCurrency(currencyCode: String) {
        let currency = getCurrencyRecord(currencyCode)
        outputCurrency.code = currency.code
        outputCurrency.locale = currency.locale
        outputCurrency.symbol = currency.symbol
        outputCurrency.rate = currency.rate
        requestUpdateForCurrencyExchangeRate(currency.code)
    }

    func swapInputWithOutput(convertInput: Bool) {
        if convertInput {
            input = self.convertToOutputCurrency(input)
        }
        let newInputCurrency = outputCurrency
        let newOutputCurrency = inputCurrency
        inputCurrency = newInputCurrency
        outputCurrency = newOutputCurrency
    }
    
    func removeLastInput() {
        if input == 0 {
            print("Value string is already zero.")
            return
        }
        if input <= 9.99 {
            input = 0
            print("Converter input value: \(input)")
            return
        }
        input = input / 10
    }

    func reset() {
        input = 0
    }

    private func convertToCurrency(value: Double, code: String, locale: String?, symbol: String?) -> String {
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
        let formattedPriceStringLastCharacters: String! = String(formattedPriceString.characters.suffix(3))
        
        if (formattedPriceStringLastCharacters == ".00") {
            formattedPriceString = String(formattedPriceString.characters.dropLast(3))
        }
        
        return formattedPriceString!
    }

    private func requestUpdateForCurrencyExchangeRate(currencyCode: String) {
        
        let url = NSURL(string: "https://query.yahooapis.com/v1/public/yql?q=" +
            "select%20*%20from%20yahoo.finance.xchange%20where%20pair%20in%20(" +
            "%22USD" + currencyCode + "%22)&diagnostics=true&env=store%3A%2F%2F" +
            "datatables.org%2Falltableswithkeys")
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            
            guard data != nil else {
                print("Error performing Yahoo query.")
                return
            }
            
            let xml = SWXMLHash.parse(data!)
            
            guard let rate = xml["query"]["results"]["rate"]["Rate"].element?.text else {
                print("Could not parse XML request.")
                return
            }
            
            // Update currency record on database.
            self.updateCurrencyRecord(currencyCode, rate: Double(rate)!)
            
            // If we are dealing with the currency input currency,
            // let's update the current input rate.
            if currencyCode == self.inputCurrency.code {
                self.inputCurrency.rate = Double(rate)!
                print("Input currency updated.")
            }
            
            // If we are dealing with the currency output currency,
            // let's update the current output rate.
            if currencyCode == self.outputCurrency.code {
                self.outputCurrency.rate = Double(rate)!
                print("Output currency updated.")
            }
            
        }
        
        task.resume()

    }
    
    private func updateCurrencyRecord(currencyCode: String, rate: Double) {
        
        // CoreData setup.
        let managedObjectContext: NSManagedObjectContext!
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        managedObjectContext = appDelegate.managedObjectContext as NSManagedObjectContext
        var currency: Currency
        
        // CoreData fetching.
        let fetch = NSFetchRequest(entityName: "Currency")
        let predicate = NSPredicate(format: "%K == %@", "code", currencyCode)
        fetch.predicate = predicate
        fetch.fetchLimit = 1
        
        do {
            currency = try managedObjectContext.executeFetchRequest(fetch).first as! Currency
        } catch {
            fatalError("Error fetching currency: \(error)")
        }
        
        // Update object.
        currency.setValue(rate, forKey: "rateFromUSD")
        
        // CoreData save.
        do {
            try managedObjectContext.save()
        } catch {
            fatalError("Error saving currency: \(error)")
        }
        
        print("Currency \(currencyCode) updated with the rate: \(rate)")
        
    }
    
    private func getCurrencyRecord(currencyCode: String) -> (name: String, code: String, rate: Double, locale: String?, symbol: String?)  {
        
        // CoreData setup.
        let managedObjectContext: NSManagedObjectContext!
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        managedObjectContext = appDelegate.managedObjectContext as NSManagedObjectContext
        var currency: Currency
        
        // CoreData fetching.
        let fetch = NSFetchRequest(entityName: "Currency")
        let predicate = NSPredicate(format: "%K == %@", "code", currencyCode)
        fetch.predicate = predicate
        fetch.fetchLimit = 1
        
        do {
            currency = try managedObjectContext.executeFetchRequest(fetch).first as! Currency
        } catch {
            fatalError("Error fetching currency: \(error)")
        }
        
        let rate:Double! = Double(currency.rateFromUSD!)
        
        return(currency.name!, currencyCode, rate, currency.locale, currency.symbol)
    
    }

}
