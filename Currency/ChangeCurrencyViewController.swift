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
    var currencies:Array<Currency>!
    var recentCurrencies:Array<Currency>!
    var searchResults:Array<Currency>?
    var tableData:Array<Array<Currency>>!
    var tableSectionTitles:Array<String>!

    @IBOutlet weak var tableView: UITableView!

    @IBAction func doneButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {})
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = 54.0
        self.searchDisplayController?.searchResultsTableView.rowHeight = 54.0
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        managedObjectContext = appDelegate.managedObjectContext as NSManagedObjectContext

        currencies = fetchCurrencies()
        recentCurrencies = fetchRecentCurrencies()
        tableData = [recentCurrencies, currencies]
        tableSectionTitles = ["Recent currencies", "All currencies"]
    }

    func fetchCurrencies() -> [Currency]{
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
        return result as! [Currency]
    }

    func fetchRecentCurrencies() -> [Currency]{
        let fetch = NSFetchRequest(entityName: "Currency")
        let sortDescriptor = NSSortDescriptor(key: "lastSelected", ascending: false)
        let sortDescriptors = [sortDescriptor]
        let predicate = NSPredicate(format: "lastSelected != nil")
        fetch.sortDescriptors = sortDescriptors
        fetch.predicate = predicate
        fetch.fetchLimit = 5
        var result = [AnyObject]()
        do {
            result = try managedObjectContext!.executeFetchRequest(fetch)
        } catch let error as NSError {
            print("Error fetching recent currencies error: %@", error)
        }
        return result as! [Currency]
    }

}

// MARK: - Table View

extension ChangeCurrencyViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if tableView == self.searchDisplayController!.searchResultsTableView {
            return 1
        } else {
            return tableData.count
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.searchDisplayController!.searchResultsTableView {
            return searchResults?.count ?? 0
        } else {
            return tableData[section].count
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("CurrencyCell")
        let currency: Currency
        
        if tableView == self.searchDisplayController!.searchResultsTableView {
            currency = searchResults![indexPath.row]
        } else {
            currency = tableData[indexPath.section][indexPath.row]
        }
        cell!.textLabel!.text = currency.name!
        cell!.detailTextLabel!.text = currency.code!
        cell!.accessoryType = UITableViewCellAccessoryType.None

        if currency.code! == selectedCurrency {
            cell!.accessoryType = UITableViewCellAccessoryType.Checkmark
        }

        return cell!
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == self.searchDisplayController!.searchResultsTableView {
            return nil
        } else {
            return tableSectionTitles[section]
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (tableData[section].count == 0) {
            return 0.0
        }
        return UITableViewAutomaticDimension
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let currency: Currency
        
        if tableView == self.searchDisplayController!.searchResultsTableView {
            currency = searchResults![indexPath.row]
        } else {
            currency = tableData[indexPath.section][indexPath.row]
        }
        
        let currencyCode = currency.code!

        delegate?.didChangeCurrency(currencyCode, targetCurrency: targetCurrency)
        self.dismissViewControllerAnimated(true, completion: {})
    }

}

// MARK: - Search

extension ChangeCurrencyViewController: UISearchBarDelegate, UISearchDisplayDelegate {

    func filterContentForSearchText(searchText: String) {

        var filteredContent:Array<Currency> = []
        let searchText = searchText.lowercaseString

        for currency in currencies {
            let matchesName = currency.name!.lowercaseString.rangeOfString(searchText) != nil
            let matchesCode = currency.code!.lowercaseString.rangeOfString(searchText) != nil

            if (matchesName || matchesCode) {
                filteredContent += [currency]
            }
        }

        self.searchResults = filteredContent

    }

    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String?) -> Bool {
        self.filterContentForSearchText(searchString!)
        return true
    }

}
