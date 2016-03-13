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
    
    @NSManaged var name: String?
    @NSManaged var code: String?
    @NSManaged var rateFromUSD: NSNumber?
    @NSManaged var decimals: NSNumber?
    @NSManaged var symbol: String?
    @NSManaged var locale: String?

}
