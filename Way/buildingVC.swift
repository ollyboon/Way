import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class buildingVC: UIViewController {
    
    //MARK: Outlets, actions and variables
    
    @IBOutlet weak var backgroundView: GradientView!
    @IBOutlet weak var defaultGradient: GradientView!
    @IBOutlet weak var buildingLabel: UILabel!
    @IBOutlet weak var emojiImage: UIImageView!
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var iconStack: UIStackView!
    @IBOutlet weak var directionBar: GradientView!
    @IBOutlet weak var back: UIButton!
    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet weak var buildingStatus: UILabel!
    @IBOutlet weak var cardView: CustomUIView!
    @IBOutlet weak var cardHeight: NSLayoutConstraint!
    @IBOutlet weak var food: UIImageView!
    @IBOutlet weak var coffee: UIImageView!
    @IBOutlet weak var printer: UIImageView!
    @IBOutlet weak var labelStack: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    @IBAction func backButton(_ sender: Any) {
        backAnimate()
    }
    
    var room: Room?
    var building : Building!
    var yPosition : CGFloat = 0.0
    let gradientLayer = CAGradientLayer()
    let parallax = ViewController()
    var fusionArray = [UIImage]()
    var floorPlanArray = [UIImage]()
    
    //MARK: View did load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
                emojiImage.alpha = 0
                emojiLabel.alpha = 0
                buildingLabel.alpha = 0
                buildingStatus.alpha = 0
                defaultGradient.alpha = 1
                back.alpha = 0
                directionLabel.alpha = 0
                directionBar.alpha = 0
                iconStack.alpha = 0
                labelStack.alpha = 0
                cardHeight.constant = 621
                scrollView.alpha = 0
        
        
                parallax.motion(toView: cardView, magnitude: 10)
        
                facilityStatus()
        
        fusionArray = [#imageLiteral(resourceName: "Fusion-Ground-Floor"),#imageLiteral(resourceName: "Fusion-F1"),#imageLiteral(resourceName: "Fusion-F2"),#imageLiteral(resourceName: "Fusion-F3")]
        
        var yPosition = 0.0
        let height = CGFloat(scrollView.frame.height)
        
        for image in 0..<fusionArray.count {
            let imageView = UIImageView()
            imageView.image = fusionArray[image]
            imageView.contentMode = .scaleAspectFit
            yPosition += Double(height + 1)
            imageView.frame = CGRect(x: 0, y: CGFloat(yPosition), width: scrollView.frame.width, height: height)
            
            
            scrollView.contentSize.height = height * CGFloat(fusionArray.count)
            
            scrollView.addSubview(imageView)
        }
        
        

        
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
        
                    self.gradientLayer.colors = [UIColor(red: 148.0/255.0, green: 217.0/255.0, blue: 72.0/255.0, alpha: 1.0).cgColor, UIColor(red: 0.0/255.0, green: 255.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor]
        
        
                case 40.0..<69.0 :
        
                    emojiImage.image = UIImage( named:"thinking face")
                    emojiLabel.text = "There's probably some space to work"
        
                    self.gradientLayer.colors = [UIColor(red: 255.0/255.0, green: 226.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor, UIColor(red: 255.0/255.0, green: 156.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor]
        
        
                case 70.0..<100.0 :
        
                    emojiImage.image = UIImage( named:"crying face")
                    emojiLabel.text = "There's nowhere to sit!!!"
        
                    self.gradientLayer.colors = [UIColor(red: 255.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor , UIColor(red: 255.0/255.0, green: 189.0/255.0, blue: 61.0/255.0, alpha: 1.0).cgColor]
        
                default:
        
                    emojiImage.image = UIImage( named:"potato")
                    emojiLabel.text = "Welcome!"
        
                    self.gradientLayer.colors = [UIColor(red: 255/255.5, green: 0/255.5, blue: 128/255.5, alpha: 1.0).cgColor, UIColor(red: 255/255.5, green: 156/255.5, blue: 0/255.5, alpha: 1.0).cgColor]
        
                }
        
                // define gradient and add to backgroundView as sublayer
                gradientLayer.frame = self.view.frame
                gradientLayer.locations = [0.0, 1.0]
                gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
                gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
                backgroundView.layer.addSublayer(gradientLayer)
        
            }
        
            //MARK: View did appear
        
            override func viewDidAppear(_ animated: Bool) {
                animate()
            }
        
            //MARK: Functions
    
        func setupWithRoom(_ room: Room) {
                    directionLabel.text = room.directions
        }
        
        func setupWithoutRoom() {
        }
        
            func backAnimate() {
        
                cardHeight.constant = 621
        
                UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.3, options: .curveEaseInOut, animations: {
                    self.view.layoutIfNeeded()
                    self.defaultGradient.alpha = 1
                    self.emojiImage.alpha = 0
                    self.emojiLabel.alpha = 0
                    self.buildingLabel.alpha = 0
                    self.directionLabel.alpha = 0
                    self.buildingStatus.alpha = 0
                    self.back.alpha = 0
                    self.iconStack.alpha = 0
                    self.directionBar.alpha = 0
                    self.labelStack.alpha = 0
                    self.scrollView.alpha = 1
                }) { (finished) in
                    self.performSegue(withIdentifier: "unwind", sender: nil)
                }
            }
        
            func animate() {
        
                cardHeight.constant = 300
        
                UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.3, options: .curveEaseInOut, animations: {
                    self.view.layoutIfNeeded()
                }, completion: nil)
        
                UIView.animate(withDuration: 0.5) {
                    self.emojiImage.alpha = 1
                    self.emojiLabel.alpha = 1
                    self.buildingLabel.alpha = 1
                    self.directionLabel.alpha = 1
                    self.buildingStatus.alpha = 1
                    self.back.alpha = 1
                    self.iconStack.alpha = 1
                    self.directionBar.alpha = 1
                    self.labelStack.alpha = 1
                }
                
                UIView.animate(withDuration: 2) {
                    self.defaultGradient.alpha = 0
                    self.scrollView.alpha = 1
                    
                }
                
            }
        
            func facilityStatus() {
                
                if building.coffee == true {
                    coffee.image = #imageLiteral(resourceName: "coffeeTick")
                } else {
                    coffee.image = #imageLiteral(resourceName: "coffeeX")
                }
                
                if building.food == true {
                    food.image = #imageLiteral(resourceName: "foodTick")
                } else {
                    food.image = #imageLiteral(resourceName: "foodX")        }
                
                if building.printer == true {
                    printer.image = #imageLiteral(resourceName: "PrinterTick")
                } else {
                    printer.image = #imageLiteral(resourceName: "PrinterX")
                }
            }
    
    }


