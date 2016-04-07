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
    var inputCurrency:(code: String, rate: Double, locale: String?, symbol: String?, decimals: Int)
    var outputCurrency:(code: String, rate: Double, locale: String?, symbol: String?, decimals: Int)
    
    init() {
        input.integer = "0"
        input.decimal = ""
        input.decimalMode = false
        input.decimalInputs = 0
        
        inputCurrency.code = "JPY";
        inputCurrency.rate = 113.81;
        inputCurrency.locale = "ja_JP"
        inputCurrency.symbol = "¥"
        inputCurrency.decimals = 0
        
        outputCurrency.code = "GBP";
        outputCurrency.rate = 0.71;
        outputCurrency.locale = "en_GB"
        outputCurrency.symbol = "£"
        outputCurrency.decimals = 2
        
        requestUpdateForCurrencyExchangeRate(inputCurrency.code)
        requestUpdateForCurrencyExchangeRate(outputCurrency.code)
    }

    func inputValue() -> String {
        let inputValue: Double = currentInput()
        return convertToCurrency(inputValue, code: inputCurrency.code, locale: inputCurrency.locale, symbol: inputCurrency.symbol, decimals: inputCurrency.decimals)
    }

    func outputValue() -> String {
        let outputValue: Double = convertToOutputCurrency(currentInput())
        return convertToCurrency(outputValue, code: outputCurrency.code, locale: outputCurrency.locale, symbol: outputCurrency.symbol, decimals: outputCurrency.decimals)
    }
    
    func convertToInputCurrency(number: Double) -> Double {
        let result: Double = (number / outputCurrency.rate) * inputCurrency.rate
        return result
    }
    
    func convertToOutputCurrency(number: Double) -> Double {
        let result: Double = (number / inputCurrency.rate) * outputCurrency.rate
        return result
    }

    func addInput(newInput: String) {
        
        if input.decimalMode {
            guard input.decimal.characters.count < inputCurrency.decimals else {
                print("Decimal input string is complete.")
                return
            }
            input.decimal = input.decimal + newInput
            input.decimalInputs = input.decimalInputs + 1
            return
        }
        
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

    func setInputCurrency(currencyCode: String) {
        let currency = getCurrencyRecord(currencyCode)
        inputCurrency.code = currency.code
        inputCurrency.locale = currency.locale
        inputCurrency.symbol = currency.symbol
        inputCurrency.rate = currency.rate
        inputCurrency.decimals = currency.decimals
        requestUpdateForCurrencyExchangeRate(currency.code)
        recordAsSelected(currency.code)
    }

    func setOutputCurrency(currencyCode: String) {
        let currency = getCurrencyRecord(currencyCode)
        outputCurrency.code = currency.code
        outputCurrency.locale = currency.locale
        outputCurrency.symbol = currency.symbol
        outputCurrency.rate = currency.rate
        outputCurrency.decimals = currency.decimals
        requestUpdateForCurrencyExchangeRate(currency.code)
        recordAsSelected(currency.code)
    }

    func swapInputWithOutput(convertInput: Bool) {
        if convertInput {
            let old: String! = String(convertToOutputCurrency(currentInput()))
            let new: Array! = old.characters.split{$0 == "."}.map(String.init)
            
            input.integer = new[0]
            input.decimal = new[1]
        }
        let newInputCurrency = outputCurrency
        let newOutputCurrency = inputCurrency
        inputCurrency = newInputCurrency
        outputCurrency = newOutputCurrency
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
    
    func removeLastInput() {
        if input.integer == "0" {
            print("Value string is already zero.")
            return
        }
        if input.integer.characters.count == 1 {
            input.integer = "0"
            print("Converter input value: \(input.integer)")
            return
        }
        input.integer = String(input.integer.characters.dropLast())
    }

    func reset() {
        input.integer = "0"
        input.decimal = ""
        input.decimalMode = false
        input.decimalInputs = 0
    }
    
    func recordAsSelected(currencyCode: String) {
        
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
        currency.setValue(NSDate(), forKey: "lastSelected")
        
        // CoreData save.
        do {
            try managedObjectContext.save()
        } catch {
            fatalError("Error saving currency: \(error)")
        }
        
        print("Currency \(currencyCode) last selected at: \(NSDate())")
        
    }
    
    private func currentInput() -> Double {
        return Double(input.integer + "." + input.decimal)!
    }

    private func convertToCurrency(value: Double, code: String, locale: String?, symbol: String?, decimals: Int) -> String {
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
        formattedPriceString = truncateCurrency(formattedPriceString, decimals: decimals)
        
        return formattedPriceString!
    }
    
    private func truncateCurrency(formattedPrice: String, decimals: Int) -> String {
        guard decimals > 0 else {
            return formattedPrice
        }
        
        let truncationLenght: Int! = (input.decimalMode ? decimals : decimals + 1) - input.decimalInputs
        let truncatedPrice: String! = String(formattedPrice.characters.dropLast(truncationLenght))
        return truncatedPrice
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
            print("Error fetching currency: \(error)")
            return
        }
        
        // Update object.
        currency.setValue(rate, forKey: "rateFromUSD")
        
        // CoreData save.
        do {
            try managedObjectContext.save()
        } catch {
            print("Error saving currency: \(error)")
            return
        }
        
        print("Currency \(currencyCode) updated with the rate: \(rate)")
        
    }
    
    private func getCurrencyRecord(currencyCode: String) -> (name: String, code: String, rate: Double, locale: String?, symbol: String?, decimals: Int)  {
        
        // Start by showing the network indicator.
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
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
        
        let name: String = currency.name!
        let code: String = currencyCode
        let rate: Double = Double(currency.rateFromUSD!)
        let locale: String = currency.locale!
        let symbol: String = currency.symbol!
        let decimals: Int = Int(currency.decimals!)
        
        // Finish by hiding the network indicator.
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        
        return(name, code, rate, locale, symbol, decimals)
    
    }

}
