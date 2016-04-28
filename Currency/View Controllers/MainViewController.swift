//
//  MainViewController.swift
//  Currency
//
//  Created by Nuno Coelho Santos on 11/02/2016.
//  Copyright © 2016 Nuno Coelho Santos. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    var converter = Converter()
    var calculator = Calculator()
    var prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()

    @IBOutlet weak var inputCurrency: UIButton!
    @IBOutlet weak var outputCurrency: UIButton!
    @IBOutlet weak var inputCurrencyCodeButton: UIButton!
    @IBOutlet weak var outputCurrencyCodeButton: UIButton!
    @IBOutlet weak var switchButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var equalsButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Style view.
        view.layer.cornerRadius = 3.0
        view.clipsToBounds = true
        inputCurrency.titleLabel?.adjustsFontSizeToFitWidth = true
        outputCurrency.titleLabel?.adjustsFontSizeToFitWidth = true
        
        // If we have the last input currency used saved on the preferences
        // file, let's use it.
        if let currencyCode = prefs.stringForKey("input") {
            converter.inputCurrency.setTo(currencyCode, remember: false)
            updateInterface()
        }
        
        // If we have the last input currency used saved on the preferences
        // file, let's use it.
        if let currencyCode = prefs.stringForKey("output") {
            converter.outputCurrency.setTo(currencyCode, remember: false)
            updateInterface()
        }
        
    }

    @IBAction func digitPressed(sender: UIButton) {
        guard let digit = sender.titleLabel?.text else {
            print("Error setting digit value.")
            return
        }
        if calculator.settingNewValue {
            converter.input.integer = "0"
            converter.input.decimal = ""
            calculator.settingNewValue = false
        }
        converter.addInput(digit)
        updateInterface()
    }

    @IBAction func clearPressed(sender: UIButton) {
        reset()
    }
    
    @IBAction func switchPressed(sender: AnyObject) {
        swapInputAndOutputCurrencies()
    }
    
    @IBAction func addPressed(sender: UIButton) {
        calculator.newAddition(converter.parsedInput())
        // Update the input label with the latest calculation,
        // at this point stored as the initial value.
        converter.setInputValue(calculator.initialValue)
        updateInterface()
        converter.clear()
        // Keep this button highlighted after it's pressed so the user
        // knows a new operation has begun.
        sender.backgroundColor = UIColor(red:0, green:0.79, blue:0.58, alpha:0.16)
    }
    
    @IBAction func minusPressed(sender: UIButton) {
        calculator.newSubtraction(converter.parsedInput())
        // Update the input label with the latest calculation,
        // at this point stored as the initial value.
        converter.setInputValue(calculator.initialValue)
        updateInterface()
        converter.clear()
        // Keep this button highlighted after it's pressed so the user
        // knows a new operation has begun.
        sender.backgroundColor = UIColor(red:0.98, green:0.31, blue:0.3, alpha:0.16)
    }
    
    @IBAction func equalsPressed(sender: UIButton) {
        let result = calculator.calculate(Double(converter.parsedInput()))
        converter.setInputValue(result)
        updateInterface()
    }
    
    @IBAction func dotPressed(sender: UIButton) {
        converter.beginDecimalInput()
        updateInterface()
    }
    
    @IBAction func ouputCurrencyPressed(sender: UIButton) {
        swapInputAndOutputCurrencies()
    }
    
    @IBAction func swipedInput(sender: AnyObject) {
        // If a user swipes on the input label, remove on digit.
        // The iOS native calculator app also has this hidden feature.
        converter.removeLastInput()
        updateInterface()
    }
    
    @IBAction func longPressedInput(sender: UIGestureRecognizer) {
        // Copy input label text to clipboard after a long press.
        if sender.state == .Began {
            UIPasteboard.generalPasteboard().string = inputCurrency.titleLabel!.text
            print("Copied input currency value to clipboard.")
        }
    }
    
    @IBAction func longPressedOutput(sender: UIGestureRecognizer) {
        // Copy input label text to clipboard after a long press.
        if sender.state == .Began {
            UIPasteboard.generalPasteboard().string = outputCurrency.titleLabel!.text
            print("Copied output currency value to clipboard.")
        }
    }

    @IBAction func longPressedEquals(sender: UILongPressGestureRecognizer) {
        if sender.state == .Began {
            reset()
        }
    }
    
    func reset() {
        converter.clear()
        calculator.reset()
        updateInterface()
    }
    
    func swapInputAndOutputCurrencies() {        
        let inputPosition = inputCurrency.center.y
        let inputColor = inputCurrency.titleLabel?.textColor
        let inputCodeButtonPosition = inputCurrencyCodeButton.center.y
        let outputPosition = outputCurrency.center.y
        let outputColor = outputCurrency.titleLabel?.textColor
        let outputCodeButtonPosition = outputCurrencyCodeButton.center.y
        
        inputCurrency.center.y = outputPosition
        inputCurrency.setTitleColor(outputColor, forState: .Normal)
        inputCurrencyCodeButton.center.y = outputCodeButtonPosition
        outputCurrency.center.y = inputPosition
        outputCurrency.setTitleColor(inputColor, forState: .Normal)
        outputCurrencyCodeButton.center.y = inputCodeButtonPosition
        
        UIView.animateWithDuration(
            0.46,
            delay: 0,
            usingSpringWithDamping: 0.66,
            initialSpringVelocity: 0.0,
            options: .CurveEaseOut,
            animations: {
                self.inputCurrency.center.y = inputPosition
                self.inputCurrency.setTitleColor(inputColor, forState: .Normal)
                self.inputCurrencyCodeButton.center.y = inputCodeButtonPosition
                self.outputCurrency.center.y = outputPosition
                self.outputCurrency.setTitleColor(outputColor, forState: .Normal)
                self.outputCurrencyCodeButton.center.y = outputCodeButtonPosition
            },
            completion: nil
        )
        
        calculator.initialValue = converter.convertToOutputCurrency(calculator.initialValue)
        if calculator.operationInProgress && !calculator.settingNewValue {
            converter.swapInputWithOutput(convertInputValue: false)
        } else {
            converter.swapInputWithOutput()
        }
        updateInterface()
        
        prefs.setObject(converter.inputCurrency.code, forKey: "input")
        prefs.setObject(converter.outputCurrency.code, forKey: "output")
        
    }
    
    func updateInterface() {
        // Update all visible labels and reset buttons to their default styles.
        inputCurrency.setTitle(converter.formattedInput(), forState: .Normal)
        outputCurrency.setTitle(converter.formattedOutput(), forState: .Normal)
        inputCurrencyCodeButton.setTitle(converter.inputCurrency.code, forState: .Normal)
        outputCurrencyCodeButton.setTitle(converter.outputCurrency.code, forState: .Normal)
        addButton.backgroundColor = nil
        addButton.setImage(UIImage(named: "buttonAddIcon.png"), forState: .Normal)
        minusButton.backgroundColor = nil
        minusButton.setImage(UIImage(named: "buttonSubtractIcon.png"), forState: .Normal)
    }
    
    // MARK: - Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // Pass the currency we are changing (input or output) and
        // the current currency code to the Change Currency View Controller.
        
        if segue.identifier == "ChangeInputCurrency" {
            let changeCurrencyViewController = (segue.destinationViewController as! UINavigationController).topViewController as! ChangeCurrencyViewController
            changeCurrencyViewController.targetCurrency = "input"
            changeCurrencyViewController.selectedCurrency = converter.inputCurrency.code
            changeCurrencyViewController.delegate = self
        }
        
        if segue.identifier == "ChangeOutputCurrency" {
            let changeCurrencyViewController = (segue.destinationViewController as! UINavigationController).topViewController as! ChangeCurrencyViewController
            changeCurrencyViewController.targetCurrency = "output"
            changeCurrencyViewController.selectedCurrency = converter.outputCurrency.code
            changeCurrencyViewController.delegate = self
        }
        
    }
    
}

// MARK: - Delegate

extension MainViewController: ChangeCurrencyViewControllerDelegate {
    
    // After selecting a new currency from the Change Currency View Controller,
    // set it as the new currency and update the interface.
    // At this point, also save it to the user preferences file.
    
    func didChangeCurrency(currencyCode: String, targetCurrency: String) {
        if targetCurrency == "input" {
            // If user changes input currency to be the same as the
            // output currency, swap them.
            if currencyCode == converter.outputCurrency.code {
                converter.swapInputWithOutput()
                converter.outputCurrency.recordAsSelected()
            } else {
                converter.inputCurrency.setTo(currencyCode)
            }
            prefs.setObject(currencyCode, forKey: "input")
            print("Input currency updated to: \(currencyCode)")
        }
        if targetCurrency == "output" {
            // If user changes output currency to be the same as the
            // input currency, swap them.
            if currencyCode == converter.inputCurrency.code {
                converter.swapInputWithOutput()
                converter.inputCurrency.recordAsSelected()
            } else {
                converter.outputCurrency.setTo(currencyCode)
            }
            prefs.setObject(currencyCode, forKey: "output")
            print("Output currency updated to: \(currencyCode)")
        }
        updateInterface()
    }
    
}

