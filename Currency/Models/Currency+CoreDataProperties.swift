//
//  Currency+CoreDataProperties.swift
//  Currency
//
//  Created by Nuno Coelho Santos on 05/03/2016.
//  Copyright © 2016 Nuno Coelho Santos. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Currency {

    @NSManaged var name: String?
    @NSManaged var code: String?
    @NSManaged var rateFromUSD: NSNumber?
    @NSManaged var decimals: NSNumber?

}
