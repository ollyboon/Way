//
//  ViewController.swift
//  Way
//
//  Created by Oliver Boon (i7263244) on 28/10/2016.
//  Copyright © 2016 Oliver Boon (i7263244). All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    
    let userManager = UserManager.sharedManager
    let beaconManager = ESTBeaconManager()
    let request = Request()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        request.loadBuildings()
        
        
        beaconManager.delegate = self
        beaconManager.requestAlwaysAuthorization()
        
        let fusionRegion = CLBeaconRegion(proximityUUID: UUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!, major: 4838, minor: 14161, identifier: "Fusion")
        
        self.beaconManager.startMonitoring(for: fusionRegion)

    }


}

extension ViewController: ESTBeaconManagerDelegate {
    
    
    func beaconManager(_ manager: Any, didEnter region: CLBeaconRegion) {
        print("Enter " + region.identifier)
        request.userEnter(buildingId: 1)
    }
    
    func beaconManager(_ manager: Any, didExitRegion region: CLBeaconRegion) {
        print("Leaving " + region.identifier)
        request.userLeft(buildingId: 1)
    }
    
}



