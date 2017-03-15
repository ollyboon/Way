import Foundation

class UserManager {
    
    var id: Int?
    
    static let sharedManager = UserManager()
    
    private init() { }
    
}
