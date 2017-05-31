//
//  SearchViewController.swift
//  Way
//
//  Created by Olly Boon on 10/04/2017.
//  Copyright © 2017 Oliver Boon (i7263244). All rights reserved.
//

import UIKit
import SHSearchBar
import IHKeyboardAvoiding
import CoreLocation

    //MARK: delegate protocol

protocol RoomViewControllerDelegate {
    
    func didSelect(_ room: Room)
    
}

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Variables and outlets
    
    var rooms = RoomManager.shared.rooms
    var room : Room!
    let request = Request()
    var delegate: RoomViewControllerDelegate?
    var searchBar: SHSearchBar!
    var viewConstraints: [NSLayoutConstraint] = []
    let locationManager = CLLocationManager()
    var mapVC = ViewController()

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var card: CustomUIView!
    @IBOutlet weak var back: UIButton!
    @IBOutlet weak var cardLeading: NSLayoutConstraint!
    @IBOutlet weak var cardTrailing: NSLayoutConstraint!
    @IBOutlet weak var cardBottom: NSLayoutConstraint!
    @IBOutlet weak var cardTop: NSLayoutConstraint!
    @IBOutlet weak var tableviewBottom: NSLayoutConstraint!
    
    @IBAction func backButton(_ sender: Any) {
        
        leaveAnimation()
        
    }
    
    
    //MARK: View did load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sortTable()
        self.tableView.reloadData()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        let rasterSize: CGFloat = 20.0
        
        KeyboardAvoiding.avoidingView = self.tableView
        
        searchBar = defaultSearchBar(withRasterSize: rasterSize, delegate: self as SHSearchBarDelegate)
        searchBar.textField.adjustsFontSizeToFitWidth = true
        view.addSubview(searchBar)
        searchBar.delegate = self
        searchBar.alpha = 0
        setupViewConstraints(usingMargin: rasterSize)
        
        
        
        // Update the searchbar config
        let delayTime = DispatchTime.now()
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            
            var config: SHSearchBarConfig = self.defaultSearchBarConfig(rasterSize)
            config.cancelButtonTextColor = UIColor.white
            config.rasterSize = 20.0
            self.searchBar.config = config
            self.setupViewConstraints(usingMargin: config.rasterSize)
            
        }
        
    }
    
    
    // MARK: View did appear
    
    override func viewDidAppear(_ animated: Bool) {
        appearAnimation()
    }
    
    //MARK: TableView Functions
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        
        cell.roomNumber.sizeToFit()
        cell.roomNumber.text = rooms[indexPath.row].roomNumber
        cell.roomName.text = rooms[indexPath.row].roomName
        cell.backgroundColor = UIColor.clear
        
        switch rooms[indexPath.row].buildingId {
        case 100:
            cell.buildingName.text = "Facility"
        case 1:
            cell.buildingName.text = "Fusion"
        case 2:
            cell.buildingName.text = "Library"
        case 3:
            cell.buildingName.text = "SUBU"
        case 4:
            cell.buildingName.text = "Poole"
        case 5:
            cell.buildingName.text = "Kimmeridge"
        case 6:
            cell.buildingName.text = "Dorset"
        case 7:
            cell.buildingName.text = "Weymouth"
        case 8:
            cell.buildingName.text = "Christchurch"
        default:
            cell.buildingName.text = "Outside"
        }
        
        switch rooms[indexPath.row].facilityType {
        case "toilet":
            cell.roomIcon.image = #imageLiteral(resourceName: "Toilet Icon")
        case "printer":
            cell.roomIcon.image = #imageLiteral(resourceName: "printerTable")
        case "cafe":
            cell.roomIcon.image = #imageLiteral(resourceName: "cafe")
        case "bike":
            cell.roomIcon.image = #imageLiteral(resourceName: "bike")
        case "bank":
            cell.roomIcon.image = #imageLiteral(resourceName: "atm")
        case "doctor":
            cell.roomIcon.image = #imageLiteral(resourceName: "doctors")
        default:
            cell.roomIcon.image = nil
        }

        return cell
        
    }
    
     func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    
        cell.alpha = 0

        UIView.animate(withDuration: 0.3, animations: {
            cell.alpha = 1
        })
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let room = rooms[indexPath.row]
        delegate?.didSelect(room)
        leaveAnimation()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: SHSearchBar Functions
    
    fileprivate func setupViewConstraints(usingMargin margin: CGFloat) {
        let searchbarHeight: CGFloat = 50.0
        
        // Deactivate old constraints
        for constraint in viewConstraints {
            constraint.isActive = false
        }
        
        viewConstraints = [
            
            topLayoutGuide.bottomAnchor.constraint(equalTo: searchBar.topAnchor, constant: -margin),
            searchBar.leftAnchor.constraint(equalTo: view.leftAnchor, constant: margin),
            searchBar.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -margin),
            searchBar.heightAnchor.constraint(equalToConstant: searchbarHeight),
            
        ]
        NSLayoutConstraint.activate(viewConstraints)
    }
    
    func searchBarShouldReturn(_ searchBar: SHSearchBar) -> Bool {
        searchBar.textField.resignFirstResponder()
        sortTable()
        tableView.reloadData()
        return true
    }
    
    func searchBarShouldClear(_ searchBar: SHSearchBar) -> Bool {
        rooms = RoomManager.shared.rooms
        sortTable()
        tableView.reloadData()
        return true
    }
    
    func searchBarShouldCancel(_ searchBar: SHSearchBar) -> Bool {
        sortTable()
        tableView.reloadData()
        return true
    }
    
    func defaultSearchBar(withRasterSize rasterSize: CGFloat, delegate: SHSearchBarDelegate) -> SHSearchBar {
        let config = defaultSearchBarConfig(rasterSize)
        let bar = SHSearchBar(config: config)
        bar.delegate = delegate
        bar.textField.placeholder = "Search"
        bar.textField.font = UIFont(name: "din", size: 28)
        bar.textField.clearsOnBeginEditing = true
        bar.updateBackgroundWith(25, corners: [.allCorners], color: UIColor.white)
        bar.layer.shadowColor = UIColor.black.cgColor
        bar.layer.shadowOffset = CGSize(width: 0, height: 8)
        bar.layer.shadowRadius = 10
        bar.textField.autocapitalizationType = UITextAutocapitalizationType.none
        bar.layer.shadowOpacity = 0.5
        return bar
    }
    
    func defaultSearchBarConfig(_ rasterSize: CGFloat) -> SHSearchBarConfig {
        var config: SHSearchBarConfig = SHSearchBarConfig()
        config.rasterSize = rasterSize
        config.textColor = UIColor.black
        config.textContentType = UITextContentType.fullStreetAddress.rawValue
        config.cancelButtonTitle = "Cancel"
        config.cancelButtonTextColor = UIColor.white
        return config
    }
    
    //MARK: Animation Functions
    
    func leaveAnimation() {
        
        cardBottom.constant = 9
        cardLeading.constant = 0
        cardTrailing.constant = 0
        cardTop.constant = -16
        
        UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.4, options: .curveEaseInOut, animations: {
            self.card.alpha = 1
            self.searchBar.alpha = 0
        }, completion: nil)
        
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.4, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
            self.tableView.alpha = 0
            self.back.alpha = 0
        }) { (finished) in
            self.performSegue(withIdentifier: "unwindRooms", sender: nil)
        }
    }
    
    func appearAnimation() {
        
        cardBottom.constant = 525
        cardLeading.constant = 20
        cardTrailing.constant = 20
        cardTop.constant = 40
        
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.4, options: .curveEaseInOut, animations: { 
            self.view.layoutIfNeeded()
            self.card.cornerRadius = 25
        }, completion: nil)
        
        UIView.animate(withDuration: 0.3, delay: 0.25, options: [], animations: {
            self.searchBar.alpha = 1
        }, completion: nil)
        
        
        UIView.animate(withDuration: 0.5, delay: 0.25, options: [], animations: {
            self.card.alpha = 0
        }, completion: nil)
    }
    
    func sortTable() {
       
        let myLocationCoordinate: CLLocationCoordinate2D =  (locationManager.location?.coordinate)!
        let myLocation: CLLocation = CLLocation(latitude: myLocationCoordinate.latitude, longitude: myLocationCoordinate.longitude)
        rooms.sort(by: { $0.distance(to: myLocation) < $1.distance(to: myLocation) })
        
    }
    
    func textField(textField: SHSearchBar, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if (string == " ") {
            return false
        }
        return true
    }
    
}


    //MARK: Extensions

extension SearchViewController: SHSearchBarDelegate {
    
    func searchBar(_ searchBar: SHSearchBar, textDidChange text: String) {
        
        if text == "" {
            rooms = RoomManager.shared.rooms
        } else {
            rooms = RoomManager.shared.search(string: text.lowercased())
        }
        
        sortTable()
        tableView.reloadData()
        
    }
    
    
}

extension SearchViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        sortTable()

    }
}

