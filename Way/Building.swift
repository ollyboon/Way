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
    var activeUsers: Int!
    var latitude: Double!
    var longitude: Double!
    
    
    init(json: JSON){
        name = json["name"].stringValue
        buildingId = json["id"].int
        capacity = json["capacity"].int
        beaconId = json["uuid"].stringValue
        activeUsers = json["active_users"].int
        latitude = json["latitude"].double
        longitude = json["longitude"].double
    }
    
    func calculatePercentage() {
        
        if activeUsers >= 1 {
            
            let result =  activeUsers / capacity
            let activePercentage = result * 100
            
            print(activePercentage)
        }
        
        
    }
}
