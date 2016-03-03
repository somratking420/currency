//
//  Currency.swift
//  Currency
//
//  Created by Nuno Coelho Santos on 27/02/2016.
//  Copyright © 2016 Nuno Coelho Santos. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class Currency: Object {
    
    dynamic var name:String = ""
    dynamic var code:String = ""
    dynamic var rateFromUSD: Double = 0.00
    dynamic var decimalPlaces: Int = 0
    
}
