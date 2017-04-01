import Foundation
import SwiftyJSON

class Room {
    
    var roomNumber : String!
    var roomName : String!
    var latitude : Double!
    var longitude : Double!
    
    init(json : JSON) {
        roomNumber = json["room_number"].stringValue
        roomName = json["room_name"].stringValue
        latitude = json["latitude"].double
        longitude = json ["longitude"].double
    }
    
    
}
