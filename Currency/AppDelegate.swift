//
//  AppDelegate.swift
//  Currency
//
//  Created by Nuno Coelho Santos on 11/02/2016.
//  Copyright © 2016 Nuno Coelho Santos. All rights reserved.
//

import UIKit
//import RealmSwift

// Define a function to get a path of a bundled asset by passing the asset name.
func bundlePath(path: String) -> String? {
    let resourcePath = NSBundle.mainBundle().resourcePath as NSString?
    return resourcePath?.stringByAppendingPathComponent(path)
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        /*Realm.Configuration.defaultConfiguration = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 1,
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if oldSchemaVersion < 1 {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
        })*/
        
//        let realm = try! Realm()
        
        // Clone database from bundle if empty.
        /*if realm.objects(Currency).count == 0 {
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
        }*/
        
        return true
    }

}

