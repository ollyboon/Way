import Foundation

class RoomManager {
    
    static let shared = RoomManager()
    
    var rooms = [Room]()
    
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
    
    
    
}
