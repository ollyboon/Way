import Foundation

class RoomManager {
    
    static let shared = RoomManager()
    
    var rooms = [Room]()
    
    private init() { }
    
}
