import Foundation
import SwiftyJSON

enum buildingType: String {
    case fusion, library, studentUnion
}

class Building {
    
    var buildingId: Int!
    var name: String!
    var capacity: Int!
    var beaconId: String!
    var active_users: Int!
    
    init(json: JSON){
        name = json["name"].stringValue
        buildingId = json["id"].int
        capacity = json["capacity"].int
        beaconId = json["uuid"].stringValue
        active_users = json["active_users"].int
        
    }
    
}
