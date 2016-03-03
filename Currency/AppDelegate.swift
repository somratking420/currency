//
//  AppDelegate.swift
//  Currency
//
//  Created by Nuno Coelho Santos on 11/02/2016.
//  Copyright © 2016 Nuno Coelho Santos. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

// Define a function to get a path of a bundled asset by passing the asset name.
func bundlePath(path: String) -> String? {
    let resourcePath = NSBundle.mainBundle().resourcePath as NSString?
    return resourcePath?.stringByAppendingPathComponent(path)
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // First, check that the database is empty.
        if Currency.allObjects().count == 0 {
            // Then, define the path for the default realm database as a constant.
            let defaultPath = Realm.Configuration.defaultConfiguration.path!
            // If we can find the initial database dump on the bundle...
            if let initialDatabasePath = bundlePath("initial.realm") {
                do {
                    // Remove the database on the default path and place the bundled database there instead.
                    try NSFileManager.defaultManager().removeItemAtPath(defaultPath)
                    try NSFileManager.defaultManager().copyItemAtPath(initialDatabasePath, toPath: defaultPath)
                } catch {}
            }
        }
        
        return true
    }

}

