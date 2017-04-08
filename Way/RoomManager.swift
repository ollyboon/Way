import Foundation

class RoomManager {
    
    static let shared = RoomManager()
    
    var rooms = [Room]()
    
    private init() { }
    
    func filter(x: String) -> [Room] {
        var search = [Room]()
        
        for room in rooms {
            
            if room.roomNumber == x {
                search.append(room)
            }
            
        }
        
        return search
    }
    
}
