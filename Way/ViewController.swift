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
import Fabric
import Crashlytics
import CoreLocation
import PCLBlurEffectAlert
import CoreBluetooth

class ViewController: UIViewController {
    
    //MARK: Variables, outlets and segues
    
    //Variables
    var pitch: CGFloat = 0
    var annotationView = MGLAnnotationView()
    var pointAnnotation = MGLPointAnnotation()
    var room: Room?
    var BTManager: CBPeripheralManager?
    var locationArray = [locations]()
    
    //Constants
    let userManager = UserManager.sharedManager
    let beaconManager = ESTBeaconManager()
    let request = Request()
    let distance: CLLocationDistance = 720
    let heading = 310.0
    let mapCenter = CLLocationCoordinate2D(latitude: 50.742977, longitude: -1.895378)
    let userDefaults = UserDefaults.standard
    let locationManager = CLLocationManager()
    let buildings = BuildingManager.shared.buildings
    let alert = PCLBlurEffectAlert.Controller(title: "Your Bluetooth is off!", message: "Please turn it on to see available work space", effect: UIBlurEffect(style: .extraLight), style: .alert)
    let alertBtn = PCLBlurEffectAlert.Action(title: "Ok", style: .cancel, handler: nil)
    
    //Outlets
    @IBOutlet weak var mapView: MGLMapView!
    @IBOutlet var Gradient: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var search: UIButton!
    @IBOutlet weak var searchIcon: UIButton!
    @IBOutlet weak var mapViewBottom: NSLayoutConstraint!
    
    
    //Actions
    @IBAction func refresh(_ sender: Any) {
        refresh()
    }
    
    @IBAction func searchButton(_ sender: Any) {
        tableSegueAnimate()
    }
    
    @IBAction func leaveButton(_ sender: Any) {
        tableSegueAnimate()
    }
    
    //Segues
    @IBAction func prepareForUnwind (segue:UIStoryboardSegue) {}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "roomList" {
            if let destination = segue.destination as? SearchViewController {
                destination.delegate = self
            }
        }
        
        if segue.identifier == "building" {
            if let destination = segue.destination as? buildingVC {
                guard let building = sender as? Building else { return }
                destination.room = room
                destination.building = building
            }
        }
    }

    
    
    //MARK: View did load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaults.standard.register(defaults: [String : Any]())
        request.delegate = self
        request.loadRooms()
        BTManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)
    
        
        //Configure Bluetooth Alert
        alert.addAction(alertBtn)
        alert.addImageView(with: #imageLiteral(resourceName: "bluetooth"))
        alert.configure(cornerRadius: 20)
        alert.configure(titleColor: .black)
        alert.configure(titleFont: UIFont(name: "din", size: 22)!)
        alert.configure(messageFont: UIFont(name: "din", size: 14)!)
        alert.configure(messageColor: .black)
    
        //initial map setup
        mapView.layer.cornerRadius = 15
        mapView.delegate = self
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.compassView.isHidden = true
        mapView.logoView.isHidden = false
        mapView.attributionButton.isHidden = true
        mapView.setCenter(mapCenter, zoomLevel: 12, direction: 0, animated: false)
        
        //iBeacon regions + Core Location
        beaconManager.delegate = self
        beaconManager.requestAlwaysAuthorization()
        let fusionRegion = CLBeaconRegion(proximityUUID: UUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!, major: 4838, minor: 14161, identifier: "Fusion")
        self.beaconManager.startMonitoring(for: fusionRegion)
        
        locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        let campusRegion = locations(coord: CLLocationCoordinate2D(latitude: 50.742802, longitude: -1.895592), identifier: "talbotCampus")
        locationArray.append(campusRegion)
        
        for location in locationArray {
            locationManager.startMonitoring(for: location.region)
        }
        
        //auto refresh
        let refreshTimer = Timer.scheduledTimer(timeInterval: 120 , target: self, selector: #selector(self.refresh(_:)), userInfo: nil, repeats: true)
        autoRefresh(refreshTimer)
        
        let activeUserTimer = Timer.scheduledTimer(timeInterval: 5 , target: self, selector: #selector(self.refreshAnimate(_:)), userInfo: nil, repeats: true)
        refreshAnimate(activeUserTimer)
        

        

        
    }
    

    //MARK: View did appear
    
    override func viewDidAppear(_ animated: Bool) {
        appearAnimation()
    }
    
    //MARK: Custom Functions
    
    //Live Animations
    func liveAnimate() {
        (0...10).forEach { (_) in
            generateAnimatedViews()
        }
    }
    func generateAnimatedViews() {
        let image = drand48() > 0.5 ? #imageLiteral(resourceName: "smiley face"): #imageLiteral(resourceName: "nerd")
        let liveImage = UIImageView(image: image)
        let dimension = 20 + drand48() * 10
        liveImage.frame = CGRect(x: 0, y: 0, width: dimension, height: dimension)
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = customPath().cgPath
        animation.duration = 1.5 + drand48() * 3
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        liveImage.layer.add(animation, forKey: nil)
        view.addSubview(liveImage)
    }
    
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
    
    func  autoRefresh(_ timer: Timer) {
        rotate()
        if let annotations = mapView.annotations {
            mapView.removeAnnotations(annotations)
        }
        BuildingManager.shared.buildings.removeAll()
        request.loadBuildings()
    }
    
    func refresh() {
        rotate()
        if let annotations = mapView.annotations {
              self.mapView.removeAnnotations(annotations)
        }
        BuildingManager.shared.buildings.removeAll()
        request.loadBuildings()
        room = nil
        
        func mapViewDidRefresh(_ mapView: MGLMapView) {
            
            let camera = MGLMapCamera(lookingAtCenter: mapCenter, fromDistance: 750, pitch: 0, heading: 310)
            
            mapView.setCamera(camera, withDuration: 1, animationTimingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
        }
        mapViewDidRefresh(mapView)
    }
    
    func refreshAnimate(_ timer: Timer) {
        request.campusRefresh()
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
    
    func settings() {
        let mapboxTelemetry = userDefaults.bool(forKey: "MGLMapboxMetricsEnabled")
        if mapboxTelemetry == true {
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
            guard building.buildingId < 99 else { continue }
            let point = CustomAnnotation(building: building)
            let buildingCoord = CLLocationCoordinate2D(latitude: building.latitude, longitude: building.longitude)
            point.coordinate = buildingCoord
            pointAnnotations.append(point)
        }
        
        mapView.addAnnotations(pointAnnotations)
    }
    
    func loadedCampus() {
        
        self.liveAnimate()

        for building in BuildingManager.shared.buildings {
            if building.buildingId == 101 {
                var activeUsers = building.activeUsers {
                    didSet {
                        if activeUsers! > oldValue! {
                            self.liveAnimate()
                        }
                        print("Someone new is on campus")
                    }
                }
            }
        }
        
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
        mapView.setZoomLevel(18, animated: true)
        let coordinate = roomPin.coordinate
        
        func mapViewDidAppear(_ mapView: MGLMapView) {
            
            let camera = MGLMapCamera(lookingAtCenter: coordinate, fromDistance: 250, pitch: 0, heading: 310)
            
            mapView.setCamera(camera, withDuration: 1, animationTimingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
        }
        mapViewDidAppear(mapView)
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
    
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        
        let camera = MGLMapCamera(lookingAtCenter: mapView.centerCoordinate, fromDistance: 750, pitch: 0, heading: 310)
        
        mapView.setCamera(camera, withDuration: 2, animationTimingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
    }

}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        
        print(region.identifier)
        
        if region.identifier == "talbotCampus" {
          request.userEnter(buildingId: 101)
        }
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        
        print(region.identifier)
        
        if region.identifier == "talbotCampus" {
            request.userLeft(buildingId: 101)
        }
        
        
    }
}

extension ViewController: CBPeripheralManagerDelegate {
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager){
        print(#function)
        if peripheral.state == CBManagerState.poweredOn {
        } else if peripheral.state == CBManagerState.poweredOff {
            alert.show()
            BTManager!.stopAdvertising()
        } else if peripheral.state == CBManagerState.unsupported {
        } else if peripheral.state == CBManagerState.unauthorized {
        }
    }
    
}

func customPath() -> UIBezierPath {
    
    let path = UIBezierPath()
    let endPoint = CGPoint(x: 400, y: 20)
    let randomY = 200 + drand48() * 300
    let cp1 = CGPoint(x: 100, y: 100 - randomY)
    let cp2 = CGPoint(x: 150, y: 100 + randomY)
    
    path.move(to: CGPoint(x: 0, y: 70))
    path.lineWidth = 3
    path.addCurve(to: endPoint, controlPoint1: cp1, controlPoint2: cp2)
    
    return path
}

class liveAnnimation: UIView {
    
    override func draw(_ rect: CGRect) {
        
        let path = customPath()
        
        path.stroke()
    }
}








