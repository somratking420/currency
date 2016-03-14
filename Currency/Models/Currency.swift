//
//  Currency.swift
//  Currency
//
//  Created by Nuno Coelho Santos on 05/03/2016.
//  Copyright © 2016 Nuno Coelho Santos. All rights reserved.
//

import Foundation
import CoreData


class Currency: NSManagedObject {
    
    @NSManaged dynamic var name: String?
    @NSManaged dynamic var code: String?
    @NSManaged dynamic var rateFromUSD: NSNumber?
    @NSManaged dynamic var decimals: NSNumber?
    @NSManaged dynamic var symbol: String?
    @NSManaged dynamic var locale: String?

}
