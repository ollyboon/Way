import Foundation
import SwiftyJSON

enum buildingType: String {
    case fusion, library, studentUnion
}

class Building {
    
    var buildingId: Int!
    var name: String!
    var capacity: Double!
    var beaconId: String!
    var activeUsers: Double!
    var latitude: Double!
    var longitude: Double!
    
    
    init(json: JSON){
        name = json["name"].stringValue
        buildingId = json["id"].int
        capacity = json["capacity"].double
        beaconId = json["uuid"].stringValue
        activeUsers = json["active_users"].double
        latitude = json["latitude"].double
        longitude = json["longitude"].double
    }
    
    func calculatePercentage() -> Double {
        if activeUsers > 1 {
            
            let result =  activeUsers / capacity
            let activePercentage = result * 100
            
            print(name,"is",activePercentage,"% full")
            return activePercentage
        }
        return 0
    }
    

}
