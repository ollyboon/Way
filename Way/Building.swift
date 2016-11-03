import Foundation
import SwiftyJSON


class Building {
    
    var name: String!
    
    init(json: JSON){
        name = json["name"].stringValue
    }
    
}
