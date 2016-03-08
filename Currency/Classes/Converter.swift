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

    var input: String
    var inputCurrencyCode: String
    var outputCurrencyCode: String
    var inputCurrencyExchangeRate: Double
    var outputCurrencyExchangeRate: Double
    
    init() {
        input = "0"
        inputCurrencyCode = "JPY";
        outputCurrencyCode = "GBP";
        inputCurrencyExchangeRate = 113.81;
        outputCurrencyExchangeRate = 0.71;
        requestUpdateForCurrencyConvertionRate(inputCurrencyCode)
        requestUpdateForCurrencyConvertionRate(outputCurrencyCode)
    }

    func inputValue() -> String {
        let inputValue: Double = Double(input)!
        return convertToCurrency(inputValue, currencyCode: inputCurrencyCode)
    }

    func outputValue() -> String {
        let outputValue: Double = (Double(input)! / inputCurrencyExchangeRate) * outputCurrencyExchangeRate
        return convertToCurrency(outputValue, currencyCode: outputCurrencyCode)
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

    func setInputCurrency(currencyCode: String) {
        inputCurrencyCode = currencyCode
        requestUpdateForCurrencyConvertionRate(inputCurrencyCode)
        print("Set input currency to: \(currencyCode).")
    }

    func setOutputCurrency(currencyCode: String) {
        outputCurrencyCode = currencyCode
        requestUpdateForCurrencyConvertionRate(outputCurrencyCode)
        print("Set output currency to: \(currencyCode).")
    }

    func swapInputWithOutput() {
        
    }

    func reset() {
        input = "0";
    }

    private func convertToCurrency(value: Double, currencyCode: String) -> String {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        formatter.currencyCode = currencyCode
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
                print("Input currency updated.")
            }
            
            // If we are dealing with the currency output currency,
            // let's update the current output rate.
            if currencyCode == self.outputCurrencyCode {
                self.outputCurrencyExchangeRate = Double(rate)!
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

}
