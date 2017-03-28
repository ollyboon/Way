import Foundation

class BuildingManager {
    
    static let shared = BuildingManager()

    var buildings = [Building]()
    
    private init() { }
    
}
