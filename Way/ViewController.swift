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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        beaconManager.delegate = self
        beaconManager.requestAlwaysAuthorization()
        
        let fusionRegion = CLBeaconRegion(proximityUUID: UUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!, major: 4838, minor: 14161, identifier: "Fusion")
        
        self.beaconManager.startMonitoring(for: fusionRegion)

    }


}

extension ViewController: ESTBeaconManagerDelegate {
    
    
    func beaconManager(_ manager: Any, didEnter region: CLBeaconRegion) {
        print(region.identifier)
        
        let headers = [
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        let parameters = [
            "building_id": 1,
            "active": true
        ] as [String : Any]
        
        Alamofire.request("http://178.62.44.213/api/users", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .response { response in
            guard let data = response.data else { return }
            let json = JSON(data: data)
            UserManager.sharedManager.id = json["data"]["id"].intValue
        }

    }
    
    func beaconManager(_ manager: Any, didExitRegion region: CLBeaconRegion) {
        print("Exit")
        let headers = [
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        let parameters = [
            "active": false
            ] as [String : Any]
        
        Alamofire.request("http://178.62.44.213/api/users/\(UserManager.sharedManager.id!)", method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .response { response in
                guard let data = response.data else { return }
                let _ = JSON(data: data)
                UserManager.sharedManager.id = nil
        }
    }
    
}





//Alamofire.request("http://178.62.44.213/api/users.json").response { response in
//    guard let data = response.data else { return }
//    
//    let json = JSON(data: data)
//    print(json)
//    
//}

