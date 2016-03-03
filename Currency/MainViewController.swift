//
//  MainViewController.swift
//  Currency
//
//  Created by Nuno Coelho Santos on 11/02/2016.
//  Copyright © 2016 Nuno Coelho Santos. All rights reserved.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController {

    let realm = try! Realm()
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
        inputCurrencyLabel.text = converter.inputValue()
        outputCurrencyLabel.text = converter.outputValue()
    }

    @IBAction func clearPressed(sender: AnyObject) {
        inputCurrencyLabel.text = converter.resetInputValue()
        outputCurrencyLabel.text = converter.resetOutputValue()
    }

}

