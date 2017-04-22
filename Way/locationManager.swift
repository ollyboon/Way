import Foundation

class locationManager {
    
    static let shared = locationManager()
    
    var myLocation = [MyLocation]()
    
    private init() { }
    
}
