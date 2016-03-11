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

    @IBOutlet weak var inputCurrencyLabel: UILabel!
    @IBOutlet weak var outputCurrencyLabel: UILabel!
    @IBOutlet weak var inputCurrencyCodeButton: UIButton!
    @IBOutlet weak var outputCurrencyCodeButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Style view.
        view.layer.cornerRadius = 3.0
        view.backgroundColor = UIColor(red:0.97, green:0.97, blue:0.97, alpha:1)
        view.clipsToBounds = true
    }

    @IBAction func digitPressed(sender: UIButton) {
        guard let digit = sender.titleLabel?.text else {
            print("Error setting digit value.")
            return
        }
        converter.addInput(digit)
        updateInterface()
    }

    @IBAction func clearPressed(sender: UIButton) {
        converter.reset()
        updateInterface()
    }
    
    @IBAction func addPressed(sender: UIButton) {
        calculator.newAddition(Double(converter.input)!)
        converter.input = String(calculator.initialValue)
        updateInterface()
        converter.input = "0"
    }
    
    @IBAction func minusPressed(sender: UIButton) {
        calculator.newSubtraction(Double(converter.input)!)
        converter.input = String(calculator.initialValue)
        updateInterface()
        converter.input = "0"
    }
    
    @IBAction func equalsPressed(sender: UIButton) {
        let result = calculator.calculate(Double(converter.input)!)
        converter.input = String(result)
        updateInterface()
    }
    
    
    func updateInterface() {
        inputCurrencyLabel.text = converter.inputValue()
        outputCurrencyLabel.text = converter.outputValue()
    }
    
    // MARK: - Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ChangeInputCurrency" {
            let changeCurrencyViewController = (segue.destinationViewController as! UINavigationController).topViewController as! ChangeCurrencyViewController
            changeCurrencyViewController.targetCurrency = "input"
            changeCurrencyViewController.selectedCurrency = inputCurrencyCodeButton.titleLabel!.text
            changeCurrencyViewController.delegate = self
        }
        
        if segue.identifier == "ChangeOutputCurrency" {
            let changeCurrencyViewController = (segue.destinationViewController as! UINavigationController).topViewController as! ChangeCurrencyViewController
            changeCurrencyViewController.targetCurrency = "output"
            changeCurrencyViewController.selectedCurrency = outputCurrencyCodeButton.titleLabel!.text
            changeCurrencyViewController.delegate = self
        }
        
    }
    
}

extension MainViewController: ChangeCurrencyViewControllerDelegate {
    
    func didChangeCurrency(currencyCode: String, targetCurrency: String) {
        if targetCurrency == "input" {
            converter.setInputCurrency(currencyCode)
            inputCurrencyCodeButton.setTitle(currencyCode, forState: .Normal)
        }
        if targetCurrency == "output" {
            converter.setOutputCurrency(currencyCode)
            outputCurrencyCodeButton.setTitle(currencyCode, forState: .Normal)
        }
        updateInterface()
    }
    
}

