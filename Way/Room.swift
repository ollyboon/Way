import Foundation
import SwiftyJSON

class Room {
    
    var roomNumber : String!
    var roomName : String!
    var latitude : Double!
    var longitude : Double!
    var directions : String!
    var buildingId: Int!
    
    var building: Building?
    
    init(json : JSON) {
        roomNumber = json["room_number"].stringValue
        roomName = json["room_name"].stringValue
        latitude = json["latitude"].double
        longitude = json ["longitude"].double
        directions = json["directions"].stringValue
        buildingId = json["building_id"].intValue
    }
    
    
}
