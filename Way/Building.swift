import Foundation
import SwiftyJSON

enum buildingType: String {
    case fusion, library, studentUnion
}

class Building {
    
    var name: String!
    var beaconId: String!
    var buildingType: buildingType!
    var active: Int!
    
    init(json: JSON){
        name = json["name"].stringValue
        
    }
    
}
