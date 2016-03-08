//
//  TableViewController.swift
//  Currency
//
//  Created by Nuno Coelho Santos on 28/02/2016.
//  Copyright © 2016 Nuno Coelho Santos. All rights reserved.
//

import UIKit
import CoreData

protocol ChangeCurrencyViewControllerDelegate {
    func didChangeCurrency(currencyCode: String, targetCurrency: String)
}

class ChangeCurrencyViewController: UIViewController {
    
    var managedObjectContext: NSManagedObjectContext!
    var delegate: ChangeCurrencyViewControllerDelegate?
    var targetCurrency: String!
    var selectedCurrency: String!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func doneButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(targetCurrency)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        managedObjectContext = appDelegate.managedObjectContext as NSManagedObjectContext
    }
    
    func currencies() -> [AnyObject]{
        let fetch = NSFetchRequest(entityName: "Currency")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        let sortDescriptors = [sortDescriptor]
        fetch.sortDescriptors = sortDescriptors
        var result = [AnyObject]()
        do {
            result = try managedObjectContext!.executeFetchRequest(fetch)
        } catch let error as NSError {
                print("Error fetching currencies error: %@", error)
        }
        return result
    }
    
}

extension ChangeCurrencyViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies().count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("CurrencyCell")
        let index = indexPath.row
        let currency: Currency = currencies()[index] as! Currency
        cell!.textLabel!.text = currency.name!
        cell!.detailTextLabel!.text = currency.code!
        cell!.accessoryType = UITableViewCellAccessoryType.None
        
        if currency.code! == selectedCurrency {
            cell!.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let index = indexPath.row
        let currency: Currency = currencies()[index] as! Currency
        let currencyCode = currency.code!
        print("didSelectRowAtIndexPath: " + currencyCode + " (" + targetCurrency + ")")
        
        delegate?.didChangeCurrency(currencyCode, targetCurrency: targetCurrency)
        
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
}