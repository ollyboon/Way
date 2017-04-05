import Foundation
import UIKit
import Mapbox

protocol CustomAnnotationViewDelegate {
    func annotationTouched(for building: Building)
}

class CustomAnnotationView: MGLAnnotationView {
    
    var percentageBar: UIView!
    var din : UIFont = UIFont(name: "DIN", size: 15)!
    
    var delegate: CustomAnnotationViewDelegate?

    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Force the annotation view to maintain a constant size when the map is tilted.
        scalesWithViewingDistance = false
        
        // Use CALayer’s corner radius to turn this view into a circle.
        layer.cornerRadius = 15
        
        guard let annotation = annotation as? CustomAnnotation else { return }
        
        self.percentageBar = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 30))
                
        UIView.animate(withDuration: 2, animations: {
          self.percentageBar = UIView(frame: CGRect(x: 0, y: 0, width: annotation.building.calculatePercentage(), height: 30))
        })
        self.percentageBar.layer.cornerRadius = 15
        self.addSubview(self.percentageBar)
        
        

        

        
        switch annotation.building.calculatePercentage() {
            
        case 1.0..<19.0 :
            percentageBar.backgroundColor = UIColor(red: 0.0/255.0, green: 232.0/255.0, blue: 26.0/255.0, alpha: 1.0)
           
        case 20.0..<29.0 :
            percentageBar.backgroundColor = UIColor(red: 0.0/255.0, green: 232.0/255.0, blue: 26.0/255.0, alpha: 1.0)
            
        case 30.0..<39.0 :
            percentageBar.backgroundColor = UIColor(red: 0.0/255.0, green: 232.0/255.0, blue: 26.0/255.0, alpha: 1.0)
            
        case 40.0..<49.0 :
            percentageBar.backgroundColor = UIColor(red: 0.0/255.0, green: 232.0/255.0, blue: 26.0/255.0, alpha: 1.0)
            
        case 50.0..<59.0 :
            percentageBar.backgroundColor = UIColor(red: 249.0/255.0, green: 164.0/255.0, blue: 36.0/255.0, alpha: 1.0)
            
        case 60.0..<69.0 :
            percentageBar.backgroundColor = UIColor(red: 249.0/255.0, green: 164.0/255.0, blue: 36.0/255.0, alpha: 1.0)
            
        case 70.0..<79.0 :
            percentageBar.backgroundColor = UIColor(red: 249.0/255.0, green: 164.0/255.0, blue: 36.0/255.0, alpha: 1.0)
            
        case 80.0..<89.0 :
            percentageBar.backgroundColor = UIColor(red: 244.0/255.0, green: 46.0/255.0, blue: 58.0/255.0, alpha: 1.0)
            
        case 90.0..<100.0 :
            percentageBar.backgroundColor = UIColor(red: 244.0/255.0, green: 46.0/255.0, blue: 58.0/255.0, alpha: 1.0)
        
        default:
            percentageBar.backgroundColor = UIColor(red: 92/255, green: 92/255, blue: 92/255, alpha: 1.0)
            
        }
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        label.center = CGPoint(x: 50, y: 14)
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "DIN", size: 15)
        label.text = annotation.building.name
        addSubview(label)
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        button.addTarget(self, action: #selector(CustomAnnotationView.buttonPressed), for: .touchUpInside)
        addSubview(button)
    
    }
    
    func buttonPressed() {
        guard let annotation = annotation as? CustomAnnotation else { return }
        delegate?.annotationTouched(for: annotation.building)
    }
    
}
