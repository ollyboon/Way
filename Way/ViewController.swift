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
    let distance: CLLocationDistance = 250
    var pitch: CGFloat = 50
    let heading = 310.0
    var camera = MGLMapCamera()
    let coordinate = CLLocationCoordinate2D(latitude: 50.742400, longitude: -1.894990)
    @IBOutlet weak var mapView: MGLMapView!
    @IBOutlet var Gradient: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var shadowView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        request.loadBuildings()
        
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
        
        // call drop shadow function for map subview and add corner radius to mapView
        shadowView.dropShadow()
        mapView.layer.cornerRadius = 15
        
        camera = MGLMapCamera(lookingAtCenter: coordinate, fromDistance: distance, pitch: pitch, heading: heading)
        self.mapView.camera = camera
        
        // Specify coordinates for annotations.
        
        let labelCoordinates = [
            CLLocationCoordinate2D(latitude: 50.742335, longitude: -1.894862),
            CLLocationCoordinate2D(latitude: 50.742396, longitude: -1.895785),
            CLLocationCoordinate2D(latitude: 50.742705, longitude: -1.896241),
            ]
        
        // Fill an array with point annotations and add it to the map. (eventually include coordinates on database)
        var pointAnnotations = [MGLPointAnnotation]()
        for coordinate in labelCoordinates {
            let point = MGLPointAnnotation()
            point.coordinate = coordinate
            point.title = "\(coordinate.latitude), \(coordinate.longitude)"
            pointAnnotations.append(point)
        }
        
        mapView.addAnnotations(pointAnnotations)
        
        // This delegate method is where you tell the map to load a view for a specific annotation. To load a static MGLAnnotationImage, you would use `-mapView:imageForAnnotation:`.
        func mapView1(_ mapView1: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
            // This example is only concerned with point annotations.
            guard annotation is MGLPointAnnotation else {
                return nil
            }
            
            // Use the point annotation’s longitude value (as a string) as the reuse identifier for its view.
            let reuseIdentifier = "\(annotation.coordinate.longitude)"
            
            // For better performance, always try to reuse existing annotations.
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
            
            // If there’s no reusable annotation view available, initialize a new one.
            if annotationView == nil {
                annotationView = CustomAnnotationView(reuseIdentifier: reuseIdentifier)
                annotationView!.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
                
                // Set the annotation view’s background color to a value determined by its longitude.
                let hue = CGFloat(annotation.coordinate.longitude) / 100
                annotationView!.backgroundColor = UIColor(hue: hue, saturation: 0.5, brightness: 1, alpha: 1)
            }
            
            return annotationView
        }
        
        func mapView1(_ mapView1: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
            return true
        }




        
        
        

    }


}

extension ViewController: ESTBeaconManagerDelegate {
    
    
    func beaconManager(_ manager: Any, didEnter region: CLBeaconRegion) {
        print("Enter " + region.identifier)
        request.userEnter(buildingId: 1)
    }
    
    func beaconManager(_ manager: Any, didExitRegion region: CLBeaconRegion) {
        print("Leaving " + region.identifier)
        request.userLeft(buildingId: 1)
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




