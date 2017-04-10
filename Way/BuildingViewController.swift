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
    @IBOutlet weak var cardView: CustomUIView!
    @IBOutlet weak var defaultGradient: GradientView!
    @IBOutlet weak var gradientBar: GradientView!
    @IBOutlet weak var back: UIButton!
    
    @IBAction func backButton(_ sender: Any) {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.defaultGradient.alpha = 1
            self.cardView.frame = CGRect(x: 0, y: -16, width: 375, height: 621)
            self.emojiImage.alpha = 0
            self.emojiLabel.alpha = 0
            self.buildingLabel.alpha = 0
            self.directionLabel.alpha = 0
            self.buildingStatus.alpha = 0
            self.gradientBar.alpha = 0
            self.back.alpha = 0
        }) { (finished) in
            self.performSegue(withIdentifier: "unwind", sender: nil)
        }
        
    }
    
    var building : Building!
    var room: Room?
    let gradientLayer = CAGradientLayer()
    var colorSets = [[CGColor]]()
    var currentColorSet: Int!

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardView.frame = CGRect(x: 0, y: -16, width: 375, height: 621)
        emojiImage.alpha = 0
        emojiLabel.alpha = 0
        buildingLabel.alpha = 0
        directionLabel.alpha = 0
        buildingStatus.alpha = 0
        defaultGradient.alpha = 1
        gradientBar.alpha = 0
        back.alpha = 0
        
        
        if let room = room {
            if room.buildingId == building.buildingId {
                setupWithRoom(room)
            } else {
                setupWithoutRoom()
            }
        }
        
        
        buildingLabel.text = building.name
        buildingStatus.text = building.status
        
        
        switch building.calculatePercentage() {
            
            
        case 1.0..<39.0 :
            
            emojiImage.image = UIImage( named:"smiley face")
            emojiLabel.text = "Plenty of room..."
            
            
            UIView.animate(withDuration: 3, animations: {
                self.gradientLayer.colors = [UIColor(red: 148.0/255.0, green: 217.0/255.0, blue: 72.0/255.0, alpha: 1.0).cgColor, UIColor(red: 0.0/255.0, green: 255.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor]
            })
            
            
        case 40.0..<69.0 :
            
            emojiImage.image = UIImage( named:"thinking face")
            emojiLabel.text = "There's probably some space to work"
            
            
            UIView.animate(withDuration: 3, animations: {
                self.gradientLayer.colors = [UIColor(red: 255.0/255.0, green: 226.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor, UIColor(red: 255.0/255.0, green: 156.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor]
            })
            
            
        case 70.0..<100.0 :
            
            emojiImage.image = UIImage( named:"crying face")
            emojiLabel.text = "There's nowhere to sit!!!"
            
            
            UIView.animate(withDuration: 3, animations: {
                self.gradientLayer.colors = [UIColor(red: 255.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor , UIColor(red: 255.0/255.0, green: 189.0/255.0, blue: 61.0/255.0, alpha: 1.0).cgColor]
            })
            

            
            
        default:
            
            emojiImage.image = UIImage( named:"potato")
            emojiLabel.text = "No Data, have a potato"
            
            
            UIView.animate(withDuration: 3, animations: {
                self.gradientLayer.colors = [UIColor(red: 255/255.5, green: 0/255.5, blue: 128/255.5, alpha: 1.0).cgColor, UIColor(red: 255/255.5, green: 156/255.5, blue: 0/255.5, alpha: 1.0).cgColor]
            })
        }
        
        // define gradient and add to backgroundView as sublayer
        gradientLayer.frame = self.view.frame
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        backgroundView.layer.addSublayer(gradientLayer)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        UIView.animate(withDuration: 0.3                    ) {
            self.cardView.frame = CGRect(x: 0, y: -16, width: 375, height: 347)
        }
        
        
        UIView.animate(withDuration: 0.5) {
            self.emojiImage.alpha = 1
            self.emojiLabel.alpha = 1
            self.buildingLabel.alpha = 1
            self.directionLabel.alpha = 1
            self.buildingStatus.alpha = 1
            self.gradientBar.alpha = 1
            self.back.alpha = 1
        }
        
        UIView.animate(withDuration: 2) {
            self.defaultGradient.alpha = 0

        }
    }

    func setupWithRoom(_ room: Room) {
        directionLabel.text = room.directions
    }
    
    func setupWithoutRoom() {
        
    }
}

