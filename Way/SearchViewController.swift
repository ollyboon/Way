//
//  SearchViewController.swift
//  Way
//
//  Created by Olly Boon on 10/04/2017.
//  Copyright © 2017 Oliver Boon (i7263244). All rights reserved.
//

import UIKit
import SHSearchBar

protocol RoomViewControllerDelegate {
    
    func didSelect(_ room: Room)
    
}

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var card: CustomUIView!
    @IBOutlet weak var back: UIButton!
    var rooms = RoomManager.shared.rooms
    var room : Room!
    let request = Request()
    var delegate: RoomViewControllerDelegate?
    var searchBar: SHSearchBar!
    
    @IBAction func backButton(_ sender: Any) {
        
        leaveAnimation()
        
    }
    
    
    var viewConstraints: [NSLayoutConstraint] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let rasterSize: CGFloat = 11.0
        
        searchBar = defaultSearchBar(withRasterSize: rasterSize, delegate: self as SHSearchBarDelegate)
        searchBar.textField.leftViewMode = .always
        searchBar.textField.font = UIFont(name: "din", size: 28)
        view.addSubview(searchBar)
        setupViewConstraints(usingMargin: rasterSize)
        
        searchBar.delegate = self
        searchBar.isHidden = false
        
        // Update the searchbar config
        let delayTime = DispatchTime.now()
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            var config: SHSearchBarConfig = self.defaultSearchBarConfig(rasterSize)
            config.cancelButtonTextColor = UIColor.white
            config.rasterSize = 20.0
            self.searchBar.config = config

            
            self.setupViewConstraints(usingMargin: config.rasterSize)
        }
        
        self.tableView.reloadData()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        searchBar.alpha = 0
        
        UIView.animate(withDuration: 0.3) { 
            self.card.frame = CGRect(x: 19, y: 40, width: 337, height: 50)
        }
        
        UIView.animate(withDuration: 0.3, delay: 0.15, options: [], animations: {
            self.searchBar.alpha = 1
        }, completion: nil)

        
        UIView.animate(withDuration: 0.3, delay: 0.25, options: [], animations: {
            self.card.alpha = 0
        }, completion: nil)
        
    }
    
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        self.tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.0)
        
        return rooms.count
        
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        
        cell.roomNumber.text = rooms[indexPath.row].roomNumber
        cell.roomName.text = rooms[indexPath.row].roomName
        cell.backgroundColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.0)
        
        return cell
        
    }
    
     func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    
        cell.alpha = 0

        UIView.animate(withDuration: 0.5, animations: {
            cell.alpha = 1
        })
    }
    
    
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let room = RoomManager.shared.rooms[indexPath.row]
        delegate?.didSelect(room)
        leaveAnimation()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
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
        return true
    }
    
    func defaultSearchBar(withRasterSize rasterSize: CGFloat, delegate: SHSearchBarDelegate) -> SHSearchBar {
        let config = defaultSearchBarConfig(rasterSize)
        let bar = SHSearchBar(config: config)
        bar.delegate = delegate
        bar.textField.placeholder = "Search"
        bar.updateBackgroundWith(6, corners: [.allCorners], color: UIColor.white)
        bar.layer.shadowColor = UIColor.black.cgColor
        bar.layer.shadowOffset = CGSize(width: 0, height: 8)
        bar.layer.shadowRadius = 10
        bar.layer.shadowOpacity = 0.5
        return bar
    }
    
    func defaultSearchBarConfig(_ rasterSize: CGFloat) -> SHSearchBarConfig {
        var config: SHSearchBarConfig = SHSearchBarConfig()
        config.rasterSize = rasterSize
        config.textColor = UIColor(red: 103.0/255.0, green: 103.0/255.0, blue: 103.0/255.0, alpha: 1.0)
        config.textContentType = UITextContentType.fullStreetAddress.rawValue
        config.cancelButtonTitle = "Cancel"
        config.cancelButtonTextColor = UIColor(red: 103.0/255.0, green: 103.0/255.0, blue: 103.0/255.0, alpha: 1.0)
        return config
    }
    
    func leaveAnimation() {
        
        UIView.animate(withDuration: 0.2) {
            self.card.frame = CGRect(x: 0, y: -16, width: 375, height: 50)
            self.card.alpha = 1
            self.searchBar.alpha = 0
        }
        
        UIView.animate(withDuration: 0.4, animations: {
            self.card.frame = CGRect(x: 0, y: -16, width: 375, height: 621)
            self.tableView.alpha = 0
            self.back.alpha = 0
    }) { (finished) in
            self.performSegue(withIdentifier: "unwindRooms", sender: nil)
        }
    }
    




}


extension SearchViewController: SHSearchBarDelegate {
    
    func searchBar(_ searchBar: SHSearchBar, textDidChange text: String) {
        
        if text == "" {
            rooms = RoomManager.shared.rooms
        } else {
            rooms = RoomManager.shared.search(string: text)
        }
        
        
        
        tableView.reloadData()
        
    }
    
}

