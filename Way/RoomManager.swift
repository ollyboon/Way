import Foundation
import CoreLocation

class RoomManager {
    
    static let shared = RoomManager()
    
    var rooms = [Room]()
//    var myLocation =
    
    private init() { }
    
    func search(string: String) -> [Room] {
        var search = [Room]()
        
        for room in rooms {
            if room.description.lowercased().range(of:string) != nil {
                search.append(room)
            }
        }
        
        return search
    }
    
//    rooms.sort(by: { $0.distance(to: myLocation) < $1.distance(to: myLocation) })
    
    
    
}
