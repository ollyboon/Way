//
//  Regions.swift
//  Way
//
//  Created by Olly Boon on 16/05/2017.
//  Copyright © 2017 Oliver Boon (i7263244). All rights reserved.
//

import Foundation
import CoreLocation

//this custom class sets up the regions to include coordinates, radius and a name to be used in the mapviewcontroller.
class locations {
    
    var coord: CLLocationCoordinate2D!
    var identifier: String!
    
    var region: CLCircularRegion {
        
        return CLCircularRegion(center: coord, radius: 20, identifier: identifier)
        
        
    }
    
    init(coord: CLLocationCoordinate2D, identifier: String){
        self.coord = coord
        self.identifier = identifier
        
    }
    
    
}
