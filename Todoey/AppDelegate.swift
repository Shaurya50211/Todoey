//
//  AppDelegate.swift
//  Todoey
//
//  Created by Shaurya Gupta on 2022-07-29.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        do {
            _ = try Realm()
        } catch {
            fatalError("Error initializing new realm \(error)")
        }
        
        return true
    }
}

