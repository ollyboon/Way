//
//  myLocation.swift
//  Way
//
//  Created by Olly Boon on 22/04/2017.
//  Copyright © 2017 Oliver Boon (i7263244). All rights reserved.
//

import Foundation
import CoreLocation

class MyLocation {
        
    var coord: CLLocationCoordinate2D!
    var distance: Double!
    var regionDistance: Double!
    var identifier: String!
    
    var region: CLCircularRegion  {
        return CLCircularRegion(center: coord, radius: regionDistance, identifier: identifier)
    }
    
    init(coord: CLLocationCoordinate2D, regionDistance: Double, identifier: String) {
        self.coord = coord
        self.regionDistance = regionDistance
        self.identifier = identifier
    }
    
}
