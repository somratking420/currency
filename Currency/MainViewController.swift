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
        inputCurrencyLabel.text = converter.inputValue()
        outputCurrencyLabel.text = converter.outputValue()
    }
    
    func updateInputCurrency(currencyCode: String) {
        print(currencyCode)
    }
    
    func updateOutputCurrency(currencyCode: String) {
        print(currencyCode)
    }
    
    // MARK: - Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ChangeInputCurrency" {
            let changeCurrencyViewController = (segue.destinationViewController as! UINavigationController).topViewController as! ChangeCurrencyViewController
            changeCurrencyViewController.targetCurrency = "input"
        }
        
        if segue.identifier == "ChangeOutputCurrency" {
            let changeCurrencyViewController = (segue.destinationViewController as! UINavigationController).topViewController as! ChangeCurrencyViewController
            changeCurrencyViewController.targetCurrency = "output"
        }
        
    }

}

