import Foundation
import SwiftyJSON
class Room {
    
    var roomNumber : String!
    var roomName : String!
    var latitude : Double!
    var longitude : Double!
    var directions : String!
    var buildingId : Int!
    var description : String!
    var facilityType : String!
    var long = CLLocationDegrees()
    var lat = CLLocationDegrees()

    
    init(json : JSON) {
        roomNumber = json["room_number"].stringValue
        roomName = json["room_name"].stringValue
        latitude = json["latitude"].double
        longitude = json ["longitude"].double
        directions = json["directions"].stringValue
        buildingId = json["building_id"].intValue
        description = json["search"].stringValue
        facilityType = json["facility_type"].stringValue
    }
    
    var location : CLLocation {
       return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    func distance(to location: CLLocation) -> CLLocationDistance {
        return location.distance(from: self.location)
    }
    
}
