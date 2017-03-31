import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class BuildingViewController: UIViewController {
    
    @IBOutlet weak var buildingLabel: UILabel!
    @IBOutlet weak var emojiImage: UIImageView!
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet weak var buildingStatus: UILabel!
    
    var building : Building!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        directionLabel.text = ""
        buildingLabel.text = building.name
        buildingStatus.text = building.status
        
        switch building.calculatePercentage() {
            
        case 1.0..<39.0 :
            
            emojiImage.image = UIImage( named:"smiley face")
            emojiLabel.text = "Plenty of room..."
            
        case 40.0..<69.0 :
            
            emojiImage.image = UIImage( named:"thinking face")
            emojiLabel.text = "There's probably some space to work"
            
        case 70.0..<100.0 :
            
            emojiImage.image = UIImage( named:"crying face")
            emojiLabel.text = "There's nowhere to sit!!!"
            
            
        default:
            
            emojiImage.image = UIImage( named:"potato")
            emojiLabel.text = "No Data, have a potato"
            
        }
        
    }
}
