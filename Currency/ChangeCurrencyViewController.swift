//
//  TableViewController.swift
//  Currency
//
//  Created by Nuno Coelho Santos on 28/02/2016.
//  Copyright © 2016 Nuno Coelho Santos. All rights reserved.
//

import UIKit
import RealmSwift

class ChangeCurrencyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let realm = try! Realm()
    
    @IBAction func doneButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(realm.objects(Currency).count)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("CurrencyCell")
        let index = indexPath.row
        // Below we will create an array for the currency objects so we can retrieve
        // the currency that we want at an index. I couldn't find a way to do this
        // with a Realm List, and this implementation is far from desirable.
        var currenciesArray: Array<Object> = Array(realm.objects(Currency).sorted("name"))
        let currency = currenciesArray[index] as! Currency

        cell?.textLabel!.text = currency.name
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Set new currency.
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    
}