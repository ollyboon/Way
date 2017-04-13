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

class ViewController: UIViewController {
    
    //MARK: Variables, outlets and segues
    
    let userManager = UserManager.sharedManager
    let beaconManager = ESTBeaconManager()
    let request = Request()
    let distance: CLLocationDistance = 720
    var pitch: CGFloat = 0
    let heading = 310.0
    var camera = MGLMapCamera()
    let mapCenter = CLLocationCoordinate2D(latitude: 50.742977, longitude: -1.895378)
    var room: Room?
    var annotation = MGLAnnotationView()
    

    @IBOutlet weak var mapView: MGLMapView!
    @IBOutlet var Gradient: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var search: UIButton!
    @IBOutlet weak var searchIcon: UIButton!
    
    @IBAction func refresh(_ sender: Any) {
        rotate()
        if let annotations = mapView.annotations {
            mapView.removeAnnotations(annotations)
        }
        BuildingManager.shared.buildings.removeAll()
        request.loadBuildings()
    }
    
    @IBAction func searchButton(_ sender: Any) {
        tableSegueAnimate()
    }
    
    @IBAction func leaveButton(_ sender: Any) {
        tableSegueAnimate()
    }
    
    @IBAction func prepareForUnwind (segue:UIStoryboardSegue) {}
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "roomList" {
            if let destination = segue.destination as? SearchViewController {
                destination.delegate = self
            }
        }
        
        if segue.identifier == "building" {
            if let destination = segue.destination as? BuildingViewController {
                guard let building = sender as? Building else { return }
                destination.room = room
                destination.building = building
            }
        }
    }
    
    
    //MARK: View did load
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        request.delegate = self
        request.loadRooms()
        
        //initial map setup
        mapView.layer.cornerRadius = 15
        mapView.delegate = self
        mapView.compassView.isHidden = true
        mapView.logoView.isHidden = true
        camera = MGLMapCamera(lookingAtCenter: mapCenter, fromDistance: distance, pitch: pitch, heading: heading)
        self.mapView.camera = camera

        
        //iBeacon regions
        //TODO: make iBeacon UUID come from database
        beaconManager.delegate = self
        beaconManager.requestAlwaysAuthorization()
        let fusionRegion = CLBeaconRegion(proximityUUID: UUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!, major: 4838, minor: 14161, identifier: "Fusion")
        self.beaconManager.startMonitoring(for: fusionRegion)
        
        //auto refresh
        let refreshTimer = Timer.scheduledTimer(timeInterval: 60 , target: self, selector: #selector(self.refresh(_:)), userInfo: nil, repeats: true)
        refresh(refreshTimer)
        

        
        
    }
    
    //MARK: View did appear
    
    override func viewDidAppear(_ animated: Bool) {
        appearAnimation()
    }
    
    //MARK: Custom Functions
    
    func appearAnimation() {
        
        UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.3, options: .curveEaseInOut, animations: {
            self.mapView.alpha = 1
            self.refreshButton.alpha = 1
            self.search.alpha = 1
            self.searchIcon.alpha = 1
        }, completion: nil)
        
    }
    
    func rotate() {
        
        self.refreshButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 4))
        UIView.animate(withDuration: 0.25, animations:{
            self.refreshButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        })
        
    }
    
    func refreshing(_ timer : Timer) {
        
        rotate()
        if let annotations = mapView.annotations {
            mapView.removeAnnotations(annotations)
        }
        request.loadBuildings()
    }
    
    func tableSegueAnimate() {
        
        UIView.animate(withDuration: 0.1, animations: {
            self.mapView.alpha = 0
            self.refreshButton.alpha = 0
            self.searchIcon.alpha = 0
            self.search.alpha = 0
            
        }) { (finished) in
            self.performSegue(withIdentifier: "roomList", sender: nil)
        }
        
    }
    

    
}

//MARK: Extensions

extension ViewController: ESTBeaconManagerDelegate {
    
    
    func beaconManager(_ manager: Any, didEnter region: CLBeaconRegion) {
        if region.identifier == "fusion" {
            //request.userEnter(buildingId: 1)
        }
    }
    
    func beaconManager(_ manager: Any, didExitRegion region: CLBeaconRegion) {
//        print("Leaving " + region.identifier)
//        request.userLeft(buildingId: 1)
    }
    
}



extension ViewController: RequestDelegate {
    
    func loadedBuildings() {
        
        var pointAnnotations = [MGLPointAnnotation]()
        
        for building in BuildingManager.shared.buildings {
            let point = CustomAnnotation(building: building)
            let buildingCoord = CLLocationCoordinate2D(latitude: building.latitude, longitude: building.longitude)
            point.coordinate = buildingCoord
            pointAnnotations.append(point)
            
        }
        
        mapView.addAnnotations(pointAnnotations)
    }

}

extension ViewController: CustomAnnotationViewDelegate {
    
    func annotationTouched(for building: Building) {
        
        func buildingSegueAnimate() {
            UIView.animate(withDuration: 0.05, animations: {
                self.mapView.alpha = 0
                self.search.alpha = 0
                self.searchIcon.alpha = 0
                self.refreshButton.alpha = 0
            }) { (finished) in
                self.performSegue(withIdentifier: "building", sender: building)
            }
        }
        
        buildingSegueAnimate()

    }
}


extension ViewController: RoomViewControllerDelegate {
    
    func didSelect(_ room: Room) {
        
        self.room = room
        removePointAnnotation()
        let roomPin = MGLPointAnnotation()
        roomPin.coordinate = CLLocationCoordinate2D(latitude: room.latitude, longitude: room.longitude)
        roomPin.title = room.roomNumber
        roomPin.subtitle = room.roomName
        mapView.addAnnotation(roomPin)
        

        
    }
    
    func removePointAnnotation() {
        
        guard let annotations = mapView.annotations else { return }
        
        for annotation in annotations {
            if let _ = annotation as? CustomAnnotation {
                continue
            } else {
                mapView.removeAnnotation(annotation)
            }
        }
    }
}

extension ViewController: MGLMapViewDelegate {
    
    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        
        var annotationImage = mapView.dequeueReusableAnnotationImage(withIdentifier: "pin")
        
        if annotationImage == nil {
            var image = UIImage(named: "pin")!
            
            image = image.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 0, bottom: image.size.height/2, right: 0))
            
            annotationImage = MGLAnnotationImage(image: image, reuseIdentifier: "pin")
        }
        
        return annotationImage
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        // Always allow callouts to popup when annotations are tapped.
        return true
    }
    

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
            annotationView!.frame = CGRect(x: 0, y: 0, width: 0, height: 30)
            annotationView!.backgroundColor = UIColor(red: 92/255, green: 92/255, blue: 92/255, alpha: 0.5)
            annotationView!.layer.shadowColor = UIColor.black.cgColor
            annotationView!.layer.shadowOpacity = 0.3
            annotationView!.layer.shadowOffset = CGSize(width: 0, height: 7)
            annotationView!.layer.shadowRadius = 4
            annotationView!.alpha = 0
            annotationView!.center = CGPoint(x: 50, y: 15)
            UIView.animate(withDuration: 0.2, animations: {
                annotationView!.alpha = 1
                annotationView!.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
            })
        }
        
        return annotationView
    }

}
    






