import Foundation
import SwiftyJSON

class Building {
    
    var buildingId: Int!
    var name: String!
    var capacity: Double!
    var beaconId: String!
    var activeUsers: Double!
    var latitude: Double!
    var longitude: Double!
    var status : String!
    var coffee : Bool!
    var printer : Bool!
    var food : Bool!
    
    
    init(json: JSON){
        name = json["name"].stringValue
        buildingId = json["id"].int
        capacity = json["capacity"].double
        beaconId = json["uuid"].stringValue
        activeUsers = json["active_users"].double
        latitude = json["latitude"].double
        longitude = json["longitude"].double
        status = json["status"].stringValue
        coffee = json["coffee"].boolValue
        food = json["food"].boolValue
        printer = json["printer"].boolValue
    }
    
    func calculatePercentage() -> Double {
        if activeUsers > 1 {
            
            let result =  activeUsers / capacity
            let activePercentage = result * 100
            
            return activePercentage
        }
        return 0
    }
    

}
