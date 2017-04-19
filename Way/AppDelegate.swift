//
//  AppDelegate.swift
//  Way
//
//  Created by Oliver Boon (i7263244) on 28/10/2016.
//  Copyright © 2016 Oliver Boon (i7263244). All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Fabric
import Crashlytics



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        Fabric.with([Crashlytics.self])

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {

    }

    func applicationDidEnterBackground(_ application: UIApplication) {

    }

    func applicationWillEnterForeground(_ application: UIApplication) {

    }

    func applicationDidBecomeActive(_ application: UIApplication) {

    }

    func applicationWillTerminate(_ application: UIApplication) {
        
    }


}

