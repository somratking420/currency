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

    @IBOutlet weak var inputCurrencyLabel: UILabel!
    @IBOutlet weak var outputCurrencyLabel: UILabel!
    @IBOutlet weak var inputCurrencyCodeButton: UIButton!
    @IBOutlet weak var outputCurrencyCodeButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // Change status bar color.
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    @IBAction func digitPressed(sender: UIButton) {
        guard let digit = sender.titleLabel?.text else {
            print("Error setting digit value.")
            return
        }
        converter.addInput(digit)
        updateInterface()
    }

    @IBAction func clearPressed(sender: AnyObject) {
        converter.reset()
        updateInterface()
    }
    
    func updateInterface() {
        print("updateInterface")
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
        print("didChangeCurrency")
        if targetCurrency == "input" {
            converter.setInputCurrency(currencyCode)
            print("didChangeCurrency, input")
        }
        if targetCurrency == "output" {
            converter.setOutputCurrency(currencyCode)
            print("didChangeCurrency, output")
        }
        updateInterface()
    }
    
}

