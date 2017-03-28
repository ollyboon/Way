import Foundation
import UIKit
import Mapbox


class CustomAnnotation: MGLPointAnnotation {
    
    var building: Building!
    
    init(building: Building) {
        self.building = building
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
