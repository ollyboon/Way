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
    @IBOutlet weak var backgroundView: UIView!
    
    var building : Building!
    var room: Room?
    let gradientLayer = CAGradientLayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        directionLabel.text = room?.directions
        buildingLabel.text = building.name
        buildingStatus.text = building.status
        
        switch building.calculatePercentage() {
            
            
        case 1.0..<39.0 :
            
            emojiImage.image = UIImage( named:"smiley face")
            emojiLabel.text = "Plenty of room..."
            gradientLayer.colors = [UIColor(red: 148.0/255.0, green: 217.0/255.0, blue: 72.0/255.0, alpha: 1.0).cgColor, UIColor(red: 0.0/255.0, green: 255.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor]
            
            
        case 40.0..<69.0 :
            
            emojiImage.image = UIImage( named:"thinking face")
            emojiLabel.text = "There's probably some space to work"
            gradientLayer.colors = [UIColor(red: 255.0/255.0, green: 226.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor, UIColor(red: 255.0/255.0, green: 156.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor]
            
        case 70.0..<100.0 :
            
            emojiImage.image = UIImage( named:"crying face")
            emojiLabel.text = "There's nowhere to sit!!!"
            gradientLayer.colors = [UIColor(red: 255.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor , UIColor(red: 255.0/255.0, green: 189.0/255.0, blue: 61.0/255.0, alpha: 1.0).cgColor]
            
            
        default:
            
            emojiImage.image = UIImage( named:"potato")
            emojiLabel.text = "No Data, have a potato"
            gradientLayer.colors = [UIColor(red: 255/255.5, green: 0/255.5, blue: 128/255.5, alpha: 1.0).cgColor, UIColor(red: 255/255.5, green: 156/255.5, blue: 0/255.5, alpha: 1.0).cgColor]
            
        }
        
        // define gradient and add to backgroundView as sublayer
        gradientLayer.frame = self.view.frame
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        backgroundView.layer.addSublayer(gradientLayer)
        
    }
}
