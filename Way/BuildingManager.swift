import Foundation

class BuildingManager {
    
    static let sharedBuilding = BuildingManager()

    var buildings = [Building]()
    
    private init() { }
    
}
