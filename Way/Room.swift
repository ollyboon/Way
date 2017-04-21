import Foundation
import SwiftyJSON

class Room {
    
    var roomNumber : String!
    var roomName : String!
    var latitude : Double!
    var longitude : Double!
    var directions : String!
    var buildingId: Int!
    var description: String!
    var isToilet : Bool!
    var isPrinter : Bool!
    
    init(json : JSON) {
        roomNumber = json["room_number"].stringValue
        roomName = json["room_name"].stringValue
        latitude = json["latitude"].double
        longitude = json ["longitude"].double
        directions = json["directions"].stringValue
        buildingId = json["building_id"].intValue
        description = json["search"].stringValue
        isToilet = json["is_toilet"].boolValue
        isPrinter = json["is_printer"].boolValue
    }
    
}
