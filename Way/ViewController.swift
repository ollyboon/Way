//
//  ViewController.swift
//  Way
//
//  Created by Oliver Boon (i7263244) on 28/10/2016.
//  Copyright © 2016 Oliver Boon (i7263244). All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Mapbox

class ViewController: UIViewController, MGLMapViewDelegate {
    
    let userManager = UserManager.sharedManager
    let beaconManager = ESTBeaconManager()
    let request = Request()
    let distance: CLLocationDistance = 550
    var pitch: CGFloat = 0
    let heading = 310.0
    var camera = MGLMapCamera()
    let mapCenter = CLLocationCoordinate2D(latitude: 50.742987, longitude: -1.896247)

    @IBOutlet weak var mapView: MGLMapView!
    @IBOutlet var Gradient: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var refreshButton: UIButton!
    
    @IBAction func refresh(_ sender: Any) {
        
        UIView.animate(withDuration: 0.25, animations:{
            self.refreshButton.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_4))
        })
        
        if let annotations = mapView.annotations {
            mapView.removeAnnotations(annotations)
        }
        request.loadBuildings()
    }
    
    @IBAction func searchButton(_ sender: Any) {
        
        //request.userEnter(buildingId: 1)
        // print("User posted")
        
    }
    
    @IBAction func leaveButton(_ sender: Any) {
        
       // request.userLeft(buildingId: 1)
       // print("Active state removed")
        
        
    }
    
    
    func annotationPressed(sender : UIButton) {
        print("Button Clicked")
        //let building = Building(json: "data")
       // let buildingData = building.name

       // self.performSegue(withIdentifier: "building", sender: buildingData)
        
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        

        if segue.identifier == "building" {
            if let destination = segue.destination as? BuildingViewController {
                destination.building = sender as! Building

                
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIView.animate(withDuration: 5, animations:{
            self.refreshButton.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_4))
        })
        
        request.delegate = self
        
        if BuildingManager.shared.buildings.count == 0 {
            request.loadBuildings()
        } else {
            loadedBuildings()
        }
        
        mapView.delegate = self
        beaconManager.delegate = self
        beaconManager.requestAlwaysAuthorization()
        
        //iBeacon regions
        let fusionRegion = CLBeaconRegion(proximityUUID: UUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!, major: 4838, minor: 14161, identifier: "Fusion")
        
        self.beaconManager.startMonitoring(for: fusionRegion)
        

        
        // define gradient and add to backgroundView as sublayer
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.frame
        gradientLayer.colors = [UIColor(red: 255/255.5, green: 0/255.5, blue: 128/255.5, alpha: 1.0).cgColor, UIColor(red: 255/255.5, green: 156/255.5, blue: 0/255.5, alpha: 1.0).cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        backgroundView.layer.addSublayer(gradientLayer)
        
        
        // timer and function for auto annotation refresh
        func refreshing(_ timer : Timer) {
            
            UIView.animate(withDuration: 0.25, animations:{
                self.refreshButton.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_4))
            })
            
            if let annotations = mapView.annotations {
                mapView.removeAnnotations(annotations)
            }
            request.loadBuildings()
            
        }
        
        let refreshTimer = Timer.scheduledTimer(timeInterval: 180 , target: self, selector: #selector(self.refresh(_:)), userInfo: nil, repeats: true)
        
        refresh(refreshTimer)
        

        
        
        
        
        
        

        
        

        
        
        //MAPBOX
        
        // call drop shadow function for map subview and add corner radius to mapView
        shadowView.dropShadow()
        mapView.layer.cornerRadius = 15
        
        //set mapview camera
        camera = MGLMapCamera(lookingAtCenter: mapCenter, fromDistance: distance, pitch: pitch, heading: heading)
        self.mapView.camera = camera
        
        
    
    }
    

    
    // This delegate method is where you tell the map to load a view for a specific annotation.
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        guard let annotation = annotation as? CustomAnnotation else {
            return nil
        }
        
        // Use the point annotation’s longitude value (as a string) as the reuse identifier for its view.
        let reuseIdentifier = "\(annotation.coordinate.longitude)"
        
        // For better performance, always try to reuse existing annotations.
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? CustomAnnotationView
        
        // If there’s no reusable annotation view available, initialize a new one.
        if annotationView == nil {
            annotationView = CustomAnnotationView(reuseIdentifier: reuseIdentifier)
            annotationView!.delegate = self
            annotationView!.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
            annotationView!.backgroundColor = UIColor(red: 92/255, green: 92/255, blue: 92/255, alpha: 1.0)
            annotationView!.layer.shadowColor = UIColor.black.cgColor
            annotationView!.layer.shadowOpacity = 0.2
            annotationView!.layer.shadowOffset = CGSize(width: 0, height: 7)
            annotationView!.layer.shadowRadius = 4
        }
        
        return annotationView
    }
}

extension ViewController: ESTBeaconManagerDelegate {
    
    
    func beaconManager(_ manager: Any, didEnter region: CLBeaconRegion) {
//        print("Enter " + region.identifier)
//        request.userEnter(buildingId: 1)
    }
    
    func beaconManager(_ manager: Any, didExitRegion region: CLBeaconRegion) {
//        print("Leaving " + region.identifier)
//        request.userLeft(buildingId: 1)
    }
    
}

extension UIView {
    
    func dropShadow() {
        
        self.backgroundColor = UIColor.clear
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: 0, height: 10)
        self.layer.shadowRadius = 5
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: 15).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        
    }
}

extension ViewController: RequestDelegate {
    
    func loadedBuildings() {
        
        var pointAnnotations = [MGLPointAnnotation]()
        
        for building in BuildingManager.shared.buildings {
            let point = CustomAnnotation(building: building)
            let buildingCoord = CLLocationCoordinate2D(latitude: building.latitude, longitude: building.longitude)
            point.coordinate = buildingCoord
        
            if pointAnnotations.count <= 8 {
                
                pointAnnotations.append(point)
                
            }
        }
        
        
        mapView.addAnnotations(pointAnnotations)
    }

}

extension ViewController: CustomAnnotationViewDelegate {
    
    func annotationTouched(for building: Building) {
        performSegue(withIdentifier: "building", sender: building)
    }
}






