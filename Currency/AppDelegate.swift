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

func bundlePath(path: String) -> String? {
    let resourcePath = NSBundle.mainBundle().resourcePath as NSString?
    return resourcePath?.stringByAppendingPathComponent(path)
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        if Currency.allObjects().count == 0 {
            let defaultPath = Realm.Configuration.defaultConfiguration.path!
            if let initialDatabasePath = bundlePath("initial.realm") {
                do {
                    try NSFileManager.defaultManager().removeItemAtPath(defaultPath)
                    try NSFileManager.defaultManager().copyItemAtPath(initialDatabasePath, toPath: defaultPath)
                } catch {}
            }
        }
        
        return true
    }

}

